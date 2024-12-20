/**
    * Prupose : Class to show the use of Asynchronous apex BatchClass.
    * 
    * Created Date : 17-12-2024
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */

global without sharing class LeadProcessor implements Database.Batchable<sObject>, Database.stateful{
    global Integer recordProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> leadsList){
        
        for(Lead lead : leadsList)
        {
            lead.LeadSource = 'Dreamforce';
            recordProcessed += 1;
        }
        update leadsList;
        
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('recordProcessed = ' + recordProcessed);
    }

}