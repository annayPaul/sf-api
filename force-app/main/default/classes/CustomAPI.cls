@RestResource(urlMapping='/test/*')
global with sharing class CustomAPI {
    @HttpGet
    global static List<String> doGet(){
        RestRequest req = RestContext.request;
        String recordId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Account> acc = [SELECT Id FROM Account];
        List<String> ids = new List<String>();
        for(Account a: acc){
            ids.add(a.Id);
        }
        return ids;
    }
}