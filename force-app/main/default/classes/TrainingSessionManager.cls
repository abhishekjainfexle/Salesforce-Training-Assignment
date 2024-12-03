/**
* Prupose : Class to perform Some demo Operation on Training_session__c object.
* 
* Created Date : 27-11-2024
* 
* Created By : Abhishek Jain
* 
* Revision Logs : V_1.0 - Created
* 
* */


public with sharing class TrainingSessionManager {
    public TrainingSessionManager() {
        
    }
    
    /**
* Description : Method to Create Training_Session__c records
Scenario: Training Session Manager - Task1
* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    
    public static void createTrainingSessionRecord(){
        
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
    }
    
    /**
* Description : Method to Read all Training_Session__c records
Scenario: Training Session Manager - Task1
* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    public static void readTrainingSessionRecord(){
        //Quering Training_Session__c
        for(Training_Session__c session : [SELECT Id,Name,  Session_Date__c, Session_Type__c FROM Training_Session__c]){
            System.debug('Session Name: ' + session.Name);
            System.debug('Session_Date__c: ' + session.Session_Date__c);
            System.debug('Session_Type__c: ' + session.Session_Type__c);
        }
    }
    
    /**
* Description : Method-1 to Update Training_Session__c records
Scenario: Training Session Manager - Task1

* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    public static void updateTrainingSessionRecord(){
        List<Training_Session__c> updateSessionList = [SELECT Id FROM Training_Session__c WHERE Name LIKE 'Demo%' LIMIT 3];
        Integer i = 1;
        for(Training_Session__c session : updateSessionList){
            session.Name = 'Update Demo Test '+ i;
            i++;
        }
        
        if(updateSessionList.size()>0){
            update updateSessionList;
        }
        System.debug('Successfully Updated' + updateSessionList.size() + 'Training Session Records');
        
    }
    
    /**
* Description : Method-2 to Update Training_Session__c records
Scenario: Training Session Manager - Task1

* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    /* public static void updateTrainingSessionRecord(){
List<Training_Session__c> updateSessionList = [SELECT Id FROM Training_Session__c WHERE Name LIKE 'Demo%' LIMIT 3];
public Integer i = 1;
for(Training_Session__c session : updateSessionList){
session.Name = 'Update Demo Test '+ i;
i++;
}

if(updateSessionList.size()>0){
UPDATE updateSessionList;
}
System.debug('Successfully Updated' + updateSessionList.size() + 'Training Session Records');

}*/
    
    
    
    /**
* Description : Method to Delete Training_Session__c records
Scenario: Training Session Manager - Task1

* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    public static void deleteTrainingSessionRecord(){
        DELETE [SELECT Id FROM Training_Session__c WHERE Name LIKE 'Demo%' LIMIT 5];
        
    } 
    
    
    
    /**
* Description : Method to Insert attendee records using set To make sure each attendee is only added once  .
Scenario: Training Session Manager - Task2

* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 28/11/2024
*  
* */
    
    public static void InsertAttendeeRecordsRelatedToTrainingSessionRecord(){
        Set<Attendee__c> setOfAttendees = new Set<Attendee__c>();
        for(Training_Session__c session : [SELECT Id, Name FROM Training_Session__c LIMIT 1]){
            
            setOfAttendees.add(new Attendee__c(Name = 'Trainee 1' + session.Name, Training_Session__c =  session.Id ));
            setOfAttendees.add(new Attendee__c(Name = 'Trainee 1' + session.Name, Training_Session__c =  session.Id ));
            
        }
        if(!setOfAttendees.isEmpty()){
            List<Attendee__c> newAttendeeListToInsert = new List<Attendee__c>();
            newAttendeeListToInsert.addAll(setOfAttendees);
            
            insert newAttendeeListToInsert;
        }
        //System.debug('Successfully Inserted Unique' + newAttendeeListToInsert.size() + 'Attendee child records to a Training Session Records');
        
        
    }
    
    
    /**
* Description : Method to Use Enum
Scenario: Training Session Manager - Task3
* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 29/11/2024
*  
* */
    public enum SessionType {
        WEBINAR,
            WORKSHOP,
            SEMINAR
            }
    
    public static void trainingSessionRecordUsingEnum() {
        // Convert enum value to a string to match the picklist value
        // Create the Training Session record
        Training_Session__c trainingSession = new Training_Session__c(
            Name = 'xyz',
            Session_Type__c = TrainingSessionManager.SessionType.WEBINAR.Name(),
            Session_Date__c = System.Today().addDays(1)
        );
        
        try {
            // Insert the record
            insert trainingSession;
        } catch (DmlException e) {
            // Handle exceptions
            System.debug('Error creating Training Session record: ' + e.getMessage());
        }
    }
    
    /**
* Description : Method to Implement Safe navigation While fetching Related attendee Records From Training_Session__c Object
Scenario: Data Safety- Task1
* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    public static void safeNavigationCheckOnTrainingSessionRelatedListAttendee(){
        List<Attendee__c> AttendeeList;
        for(Training_Session__c session : [SELECT Id, (SELECT Id, Training_Session__r.Webinar_Link__c FROM Attendees__r) FROM Training_Session__c LIMIT 1]){
            String abcc = session.Attendees__r[0].Training_Session__r.Webinar_Link__c;
            AttendeeList = session.Attendees__r; //!= null ? session.Attendees__r : new List<Attendee__c>();
            System.debug('AttendeeList: '+ AttendeeList[0].Training_Session__r.Webinar_Link__c);
            System.debug('abcc '+abcc);
        }
        
    }
    
    /**
* Description : Method to Query Training Session Record and their related attendee Records.
Scenario: DML Operations and SOQL Queries - Task1
* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    public static void queryTraineeSessionAndRelatedAttendeeRecord(){
        //Quering Training session record with related attendees records
        for(Training_Session__c session : [SELECT Id, Name, (SELECT Id, Training_Session__r.Webinar_Link__c FROM Attendees__r) 
                                           FROM Training_Session__c WHERE Name LIKE '%Demo%']){
        System.debug('TrainingSession Records Name : ' + session.Name + ' With Related attendee Record List ' + session.Attendees__r.size());
                                           }
    }
    
    
    /**
* Description : Method to insert records Training_session__c and Handle exceptions gracefully 
Scenario: DML Operations and SOQL Queries - Task2

* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    public static void createTrainingSessionRecordWithExceptionHandling(){
      
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
        try {
            if (newSessionList.size() > 0) {
                insert newSessionList;
                System.debug('Successfully inserted ' + newSessionList.size() + ' training sessions.');
            }
        } catch (DmlException e) {
            // Handling DML exceptions
            System.debug('Error occurred while inserting training sessions: ' + e.getMessage());
        }
    }
    
    /**
* Description : Method to Update records Training_session__c and Handle exceptions gracefully. 
Scenario: DML Operations and SOQL Queries - Task2

* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    
    public static void updateTrainingSessionRecordWithExceptionHandling(){
        List<Training_Session__c> updateSessionList = [SELECT Id FROM Training_Session__c WHERE Name LIKE 'Demo%' LIMIT 3];
        Integer i = 1;
        for(Training_Session__c session : updateSessionList){
            session.Name = 'Update Demo Exception handling '+ i;
            i++;
        }
        try{
            if(updateSessionList.size()>0){
                update updateSessionList;
                System.debug('Successfully UPDATED ' + updateSessionList.size() + ' training sessions.');
                
            }
        } catch (DmlException e) {
            // Handling DML exceptions
            System.debug('Error occurred while Updating training sessions: ' + e.getMessage());
        }
    }
    
    /**
* Description : Method to Delete Training_Session__c records and Handle exceptions gracefully.
Scenario: DML Operations and SOQL Queries - Task2

* @Return : 
* @Arguments : 
* CreatedBy : Abhishek Jain
* Created Date : 27/11/2024
*  
* */
    
    public void deleteTrainingSessionRecordWithExceptionHandling() {
        
            // Attempt to delete the Training_Session__c record
            List<Training_Session__c> sessionsToDelete = [SELECT Id FROM Training_Session__c WHERE Name = 'Demo Test' LIMIT 1];
            try {
                if (sessionsToDelete.size() > 0) {
                delete sessionsToDelete;
                System.debug('Successfully deleted the Training_Session__c record with Name = Demo Test.');
            }
        } catch (DmlException e) {
            // Handle any DML exceptions during the delete operation
            System.debug('Error occurred while deleting Training_Session__c record: ' + e.getMessage());
        }
    }
    
}