@RestResource(urlMapping='/MyApi/*')
global with sharing class MyApiController {

    // For Guest Profile We have to Enable A Sharing Rule.
    @HttpGet
    global static List<Account> doGet() {
        RestRequest req = RestContext.request;
        String recordId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Account> acc = [SELECT Id, Name FROM Account WHERE Id = :recordId LIMIT 1];
        return acc;
    }

    @HttpPost
    global static String doPost(String name, String phone, String website){
        Account account = new Account();
        account.Name = name;
        account.phone = phone;
        account.website = website;
        insert account;
        return account.Id;
    }
}