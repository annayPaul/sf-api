@RestResource(urlMapping='/create')
global with sharing class CreateUser {
    global static String doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Parse the incoming request body
        String requestBody = req.requestBody.toString();
        
        // Assuming the request body is in JSON format, deserialize it
        Map<String, Object> userData = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
        
        // Create a new user using the parsed data
        User newUser = new User();
        try {
            newUser.FirstName = (String)userData.get('FirstName');
            newUser.LastName = (String)userData.get('LastName');
            newUser.Email = (String)userData.get('Email');
            newUser.Username = (String)userData.get('Username');
            newUser.Alias = (String)userData.get('Alias');
            newUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;  // Assign default profile or customize it
            newUser.TimeZoneSidKey = (String)userData.get('TimeZoneSidKey');
            newUser.LocaleSidKey = (String)userData.get('LocaleSidKey');
            newUser.EmailEncodingKey = (String)userData.get('EmailEncodingKey');
            newUser.LanguageLocaleKey = (String)userData.get('LanguageLocaleKey');

            // Insert the user
            insert newUser;
            
            // Prepare the response
            res.statusCode = 201;
            return JSON.serialize(newUser); // Return the new user info as JSON
        } catch (Exception e) {
            // Handle errors and return a failure response
            res.statusCode = 400;
            return 'Error: ' + e.getMessage();
        }
    }
}