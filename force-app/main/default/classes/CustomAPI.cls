@RestResource(urlMapping='/test/*')
global with sharing class CustomAPI {
    @HttpGet
    global static List<String> doGet(){
        List<Account> acc = [SELECT Id FROM Account];
        List<String> ids = new List<String>();
        for(Account a: acc){
            ids.add(a.Id);
        }
        return ids;
    }
}