/**
* Prupose : Class of Apex Assignment -2 to do Some demo Operation using SOQL, DML and Database statement.
* 
* Created Date : 29-11-2024
* 
* Created By : Abhishek Jain
* 
* Revision Logs : V_1.0 - Created
* 
* */

public without sharing class ApexAssignment2SoqlDmlDatabase {
    
    /**
* Description : Method to create complex SOQL queries to fetch training sessions based on specific criteria.
Scenario: Custom Labels and Enhanced Queries - Task1
* @Return : void
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 29/11/2024
*  
* */
    public static void customLabelUse(){
        Map<String, Id> mapOfRecordTypeNameWithId = new Map<String, Id>(); //Map to store Record Type name and Id
        
        List<RecordType> recordTypeList = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Training_Session__c'];
        for(RecordType rt : recordTypeList){
            mapOfRecordTypeNameWithId.put(rt.Name, rt.Id);
        }
        List<Training_Session__c> newSessionList = new List<Training_Session__c>();//List to Store Training_Session__c records
        for(Integer i = 1; i<=2; i++){
            String sessionType = (i == 1) ? 'Webinar' : 'Workshop'; // Define the session type dynamically
            newSessionList.add(new Training_Session__c(
                Name = 'Demo Test' + i,
                Session_Date__c = System.Today().addDays(i),
                Session_Type__c = sessionType,
                RecordTypeId = mapOfRecordTypeNameWithId.get(sessionType)
            ));}
        //Checking if newSessionList is not empty then insert the records.
        if(!newSessionList.isEmpty()){
            INSERT newSessionList; // Inserting the new Training_Session__c records
        }
        
        String workshopMessage = Label.WORKSHOP_RECORD_TYPE_MESSAGE;
        String webinarMessage = Label.WEBINAR_RECORD_TYPE_MESSAGE;
        //Debugging the Inserted list size
        for(Training_Session__c sess : newSessionList){
            if(sess.Session_Type__c == 'Webinar'){
                System.debug('New Inserted ' + webinarMessage + ' with Record Id: ' + sess.Id);
            }
            else if(sess.Session_Type__c == 'Workshop'){
                System.debug('New Inserted ' + workshopMessage + ' with Record Id: ' + sess.Id);
            }
            
        }
    }
    
    public static void createComplexSoqlQueryOnTrainingSession(){
        //Query Training Session object recors using Complex Filter to get the appropriate result.
        List<Training_Session__c> sessionList = [SELECT Id, Name , Session_Type__c, Session_Date__c, (SELECT Id FROM Attendees__r) 
                                                 FROM Training_Session__c 
                                                 WHERE Session_Type__c = 'Webinar' 
                                                 AND Session_Date__c >= TODAY 
                                                 AND Session_Date__c < NEXT_YEAR
                                                ];
        if(!sessionList.isEmpty()){
            System.debug('Successfully Fetched ' + sessionList.size() + ' Training Session Records with '); //Debug to see resuklt of query
            
        }
        
        
        for(AggregateResult ar : [SELECT Training_Session__c, COUNT(Id) IdCount 
                                  FROM Attendee__c
                                  GROUP BY Training_Session__c
                                  HAVING COUNT(Id) >= 2 ]){
                                      
                                      System.debug('For Trainnig Session Record: ' + (Id)ar.get('Training_Session__c') +
                                                   ' - Related Attendee Records are ' + (Integer)ar.get('IdCount'));                
                                  }
        
        
    }
    
    
    /**
* Description : Method to Implement bulk Insert using Database.insert.
Scenario: Bulk Operations - Task1
* @Return : void
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 29/11/2024
*  
* */
    
    public static void bulkInsert() {
        
        List<Training_Session__c> trainingSessionList1 = new List<Training_Session__c>{
            new Training_Session__c(Name = 'Math Session1', Session_Date__c = System.Today().addDays(5), Session_Type__c = 'Webinar'),
                new Training_Session__c(Name = 'Science Session2', Session_Date__c = System.Today().addDays(5), Session_Type__c = 'Webinar')    
                };
                    
                    Database.SaveResult[] insertResults = Database.insert(trainingSessionList1, false);
        for (Database.SaveResult ir : insertResults) {
            if (ir.isSuccess()) {
                System.debug('Successfully inserted record with ID: ' + ir.getId());
            } else {
                System.debug('I was unsuccessful during insertion of record: ' + ir.getId() + ' Beacuse of following errors');
                
                for (Database.Error err : ir.getErrors()) {
                    System.debug('Error during insert: ' + err.getStatusCode() + ' ' + err.getMessage());
                    //System.debug('Field affected by insertion are : ' + err.getField);
                    
                }
            }
        }
    }
    
    /**
* Description : Method to Implement bulk Update using Database.insert.
Scenario: Bulk Operations - Task1
* @Return : void
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 29/11/2024
*  
* */
    public static void bulkUpdate() {
        List<Training_Session__c> sessionList = [SELECT Id, Name FROM Training_Session__c WHERE Name LIKE 'Test%'];
        for(Training_Session__c sess: sessionList){
            sess.Name = 'Updated' + sess.Name;
        }
        Database.SaveResult[] updateResults = Database.update(sessionList, false);
        for (Database.SaveResult ur : updateResults) {
            if (ur.isSuccess()) {
                System.debug('Successfully updated record with ID: ' + ur.getId());
            } else {
                System.debug('I was unsuccessful during update of record: ' + ur.getId() + ' Beacuse of following errors');
                for (Database.Error err : ur.getErrors()) {
                    System.debug('Error during update: ' + err.getMessage());
                }
            }
        }
    }
    
    /**
* Description : Method to Implement bulk delete using Database.insert.
Scenario: Bulk Operations - Task1
* @Return : void
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 29/11/2024
*  
* */    
    public static void bulkDelete() {
        
        Database.DeleteResult[] deleteResults = Database.delete([SELECT Id, Name FROM Training_Session__c WHERE Name LIKE '%Test%'], false);
        for (Database.DeleteResult dr : deleteResults) {
            if (dr.isSuccess()) {
                System.debug('Successfully deleted record with ID: ' + dr.getId());
            } else {
                System.debug('I was unsuccessful during update of record: ' + dr.getId() + ' Beacuse of following errors');
                for (Database.Error err : dr.getErrors()) {
                    System.debug('Error during delete: ' + err.getMessage());
                }
            }
        }
    }
    
    
}