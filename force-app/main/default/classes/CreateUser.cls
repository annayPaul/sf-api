@RestResource(urlMapping='/create')
global with sharing class CreateUser {
    @HttpPost
    global static String doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String requestBody = req.requestBody.toString();
        
        Map<String, Object> userData = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
        
        User newUser = new User();
        try {
            newUser.FirstName = (String)userData.get('FirstName');
            newUser.LastName = (String)userData.get('LastName');
            newUser.Email = (String)userData.get('Email');
            newUser.Username = (String)userData.get('Username');
            newUser.Alias = (String)userData.get('Alias');
            newUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;
            newUser.TimeZoneSidKey = (String)userData.get('TimeZoneSidKey');
            newUser.LocaleSidKey = (String)userData.get('LocaleSidKey');
            newUser.EmailEncodingKey = (String)userData.get('EmailEncodingKey');
            newUser.LanguageLocaleKey = (String)userData.get('LanguageLocaleKey');

            insert newUser;
            
            res.statusCode = 201;
            return JSON.serialize(newUser);
        } catch (Exception e) {
            res.statusCode = 400;
            return 'Error: ' + e.getMessage();
        }
    }
}