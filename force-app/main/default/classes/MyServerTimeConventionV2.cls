@RestResource(urlMapping='/v2/ServerTime')
global with sharing class MyServerTimeConventionV2 {
    @HttpGet
    global static String doGet(){
        Organization orgDetails = [SELECT Id, Name, TimeZoneSidKey, SystemModstamp  FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
        DateTime serverTime = System.now();
        return serverTime.format('dd-MMMM-yyyy  hh:mm:ss aaa', orgDetails.TimeZoneSidKey);
    }
}