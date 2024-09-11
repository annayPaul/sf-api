@RestResource(urlMapping='/myuser/*')
global with sharing class MyUserInfo {
    @HttpGet
    global static String doGet(){
        String type = 'Type: ' + UserInfo.getUserType();
        String name = 'Name: ' + UserInfo.getName();
        String orgId = 'Org Id: ' + UserInfo.getOrganizationId();
        String profileId = 'Profile Id: ' + UserInfo.getProfileId();
        User currentLoggedInUser = [SELECT id, Profile.Name, Profile.Id FROM User WHERE Id=:Userinfo.getUserId()];
        
        if(currentLoggedInUser.Profile.Name == 'System Administrator'){
            return type + '\n\r' + name + '\n\r' + orgId + '\n\r' + profileId;
        }
        String profleId = currentLoggedInUser.Profile.id;
        String profleName = currentLoggedInUser.Profile.Name;

        type += '     ' + name;
        type += '     ' + orgId;
        type += '     ' + profileId;
        type += '     ' + profleName;
        return type;
    }
}