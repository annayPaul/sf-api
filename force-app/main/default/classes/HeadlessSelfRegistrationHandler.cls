global class HeadlessSelfRegistrationHandler implements Auth.HeadlessSelfRegistrationHandler {
    static final String headless_account = 'My Account';

    global User createUser(Id profileId, Auth.UserData data, String customUserDataMap, String experienceId, String password){
        User u = new User();

        prepareUserData(data, u);

        Account a;
        List<Account> accounts = [SELECT Id FROM Account WHERE name='My Account'];

        if(accounts.isEmpty()){
            a = new Account(name=headless_account);
            insert a;
        }else{
            a = accounts[0];
        }

        handleCustomData(customUserDataMap);

        Contact c = new Contact();
        c.accountId = a.Id;
        c.firstName = u.firstName;
        c.lastName = u.lastName;
        insert c;

        u.profileId = profileId;
        u.contactId = c.Id;

        return u;
    }

    void handleCustomData(String customUserDataMap){
        System.debug('Custom data' + customuserDataMap);
        ContactInformation contactInfo = null;
        try{
            contactInfo = (HeadlessSelfRegistrationHandler.ContactInformation)JSON.deserialize(customUserDataMap, HeadlessSelfRegistrationHandler.ContactInformation.class);
            System.debug('ContactInfo.mobilePhone: ' + contactInfo.mobilePhone);
            System.debug('ContactInfo.streetAddress: ' + contactInfo.streetAddress);
            System.debug('ContactInfo.city: ' + contactInfo.city);
            System.debug('ContactInfo.state: ' + contactInfo.state);
        }catch(Exception e){
            System.debug('JSON was not formed correctly for the apex class');
        }
    }   
    
    void prepareUserData(Auth.UserData data, User u){
        String name, firstName, lastName, username, alias, email;

        System.debug('----> Passed In User Information');
        System.debug('Email: ' + data.email);
        System.debug('First Name: ' + data.firstName);
        System.debug('Last Name: ' + data.lastName);

        for(String key : data.attributeMap.keySet()){
            System.debug('key: ' + key + ' value: ' + data.attributeMap.get(key));
        }

        firstName = 'change-me';
        lastName = 'change-me';
        email = 'change@me.com';

        if(data.email != null && data.email != ''){
            email = data.email;
        }
        if(data.firstName != null && data.firstName != ''){
            firstName = data.firstName;
        }
        if(data.lastName != null && data.lastName != ''){
            lastName = data.lastName;
        }
        if(data.attributeMap.containsKey('full_name')){
            name = data.attributeMap.get('full_name');
        }if(firstName == 'change-me' && name != ''){
            firstName = name.substringBefore(' ');
        }
        if(lastName == 'change-me' && name.substringAfter(' ') != ''){
            lastName = name.substringAfter(' ');
        }

        Integer rand = Math.round(Math.random() * 100000000);
        if(data.attributeMap.containsKey('username')){
            username = data.attributeMap.get('username');
        }else {
            username = lastName + '.' + rand + '@social-sign-on.com';
        }

        alias = firstName;
        if(alias.length() > 8){
            alias = alias.substring(0, 8);
        }
        u.username = username;
        u.email = email;
        u.lastName = lastName;
        u.firstName = firstName;
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLocale();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
    }

    global class ContactInformation{
        String mobilePhone;
        String streetAddress;
        String city;
        String state;
        Boolean privacyPolicy;

    }
}