Public with sharing class Abcd {
    public static void xvysd(){
        List<Training_Session__c> traiList = [SELECT Id, Webinar_Link__c FROM Training_Session__c];
        System.debug(traiList);
    }
}