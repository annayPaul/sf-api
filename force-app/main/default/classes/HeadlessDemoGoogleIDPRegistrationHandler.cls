global class HeadlessDemoGoogleIDPRegistrationHandler implements Auth.RegistrationHandler {
    static final String headless_account = 'My Account';
    static final String headless_profile = 'Headless Demo Profile';


    global User createUser(Id portalId, Auth.UserData data){
        List<User> users = [SELECT Id, firstName, lastName, email FROM User WHERE Username = :data.email LIMIT 1];
        User u = null;
        
        if(!users.isEmpty()){
            u = users[0];
        }
        if(u == null){
            u = new User();
            prepareUserData(data, u);
            
            Account a;
            List<Account> accounts = [SELECT Id FROM Account WHERE name='My Account'];

            if(accounts.isEmpty()){
                a = new Account(name = headless_account);
                insert a;
            }else{
                a = accounts[0];
            }

            Profile p = [SELECT Id FROM Profile WHERE Name = :headless_profile LIMIT 1];
            Contact c = new Contact();
            c.accountId = a.Id;
            c.firstName = u.firstName;
            c.lastName = u.lastName;

            insert c;

            u.profileId = p.Id;
            u.contactId = c.Id;
        }else{
            u.firstName = data.firstName;
            u.lastName = data.lastName;
            u.email = data.email;
            update u;
        }
        return u;
    }

    global void updateUser(Id userId, Id portalid, Auth.UserData data){
        User u = new User(id=userId);
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        update u;
    }

    void prepareUserData(Auth.UserData data, User u){
        String name, firstName, lastName, username, alias, email;
        System.debug('-----> Passed In User Information');
        System.debug('Email: ' + data.email);
        System.debug('First Name: ' + data.firstName);
        System.debug('Last Name: ' + data.lastName);
        
        for(String key: data.attributeMap.keySet()){
            System.debug('key : ' + key + ' value: ' + data.attributeMap.get(key));
        }

        firstName = 'change-me';
        lastName = 'change-me';
        email = 'change@me.com';
        if(data.email != null && data.email != '')
            email = data.email;
        if(data.firstName != null && data.firstName != '')
            firstName = data.firstName;
        if(data.LastName != null && data.lastName != '')
            lastName = data.lastName;
        if(data.attributeMap.containsKey('full_name'))
            name = data.attributeMap.get('full_name');
        if(data.attributeMap.containsKey('name'))
            name = data.attributeMap.get('name');
        if(firstName == 'change-me' && name != '')
            firstName = name.substringBefore(' ');
        if(lastName == 'change-me' && name.substringAfter(' ') != '')
            lastName = name.substringAfter(' ');
        
        alias = firstName;

        if(alias.length() > 8)
            alias = alias.substring(0, 8);
        
        u.username = email;
        u.email = email;
        u.lastName = lastName;
        u.firstName = firstName;
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLocale();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
    }
}