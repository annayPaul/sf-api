@RestResource(urlMapping='/v1/ServerTime')
global with sharing class MyServerTimeConventionV1 {
    @HttpGet
    global static String doGet(){
        Organization orgDetails = [SELECT Id, Name, TimeZoneSidKey, SystemModstamp  FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
        DateTime serverTime = System.now();
        return serverTime.format('dd-MMMM-yyyy HH:mm:ss z', orgDetails.TimeZoneSidKey);
    }
}