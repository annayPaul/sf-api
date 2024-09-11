@RestResource(urlMapping='/v2/ServerTime/*')
global with sharing class MyServerTime2 {
    @HttpGet
    global static String doGet() {
        DateTime serverTime = DateTime.now();
        return serverTime.format('yyyy-MM-dd HH:mm:ss');
    }
}