@isTest
public with sharing class TestShring {
    
    @isTest(SeeAllData=true)
    public static void showSharing(){
        User u = [SELECT Id FROM User WHERE Username = 'mark.wahlberg@fexle.com'];
        System.runAs(u){
            Abcd.xvysd();
        }
            }
}