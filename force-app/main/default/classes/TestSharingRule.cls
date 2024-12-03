public with sharing class TestSharingRule {
    
    public static void seeTrainingRecord(){
        List<Training_Session__c> trainingList = [SELECT Id FROM Training_Session__c];
        System.debug(trainingList.size());
    }
}