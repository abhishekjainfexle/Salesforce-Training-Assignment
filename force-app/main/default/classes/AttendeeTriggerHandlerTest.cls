/**
* Prupose : Test Class for AttendeeTriggerHandler
* 
* Created Date : 13-12-2024
* 
* Created By : Abhishek Jain
* 
* Revision Logs : V_1.0 - Created
* 
* */
 
@isTest(seeAllData=false)
public class AttendeeTriggerHandlerTest {
    
    /**
     * Description : Created a Test Setup method to add Some Test Data for Attendee, Training Session and Contact Object.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 13/12/2024
     * 
     * Modified : 
     * 
     */    
    @TestSetup
    static void setupTestData(){
        // Create test Contacts
        List<Contact> contactsList = TestFactory.createContactWithoutAccountOrEmail('TestLastName', 3);
        
        // Create test Training Sessions
        List<Training_Session__c> sessionList = TestFactory.createTrainingSession('Session', 'Webinar', 2);
        
        // Create test Attendees
        List<Attendee__c> attendeesList = TestFactory.createAttendeeRecords(contactsList, sessionList, 3);
    }
    
    /**
     * Description : Created a Test method to check after Insert positive scenerio while inserting Attendee Records .
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 13/12/2024
     * 
     * Modified : 
     * 
     */        
    
    @isTest
    static void afterInsertPositiveTesting() {
        
        // Fetching Contact amd session new rcords to insert attendee record 
        List<Contact> conList = [SELECT Id, Enrolled_Sessions__c FROM Contact LIMIT 3];
        List<Training_Session__c> sessionList = [SELECT Id FROM Training_Session__c LIMIT 2];
        
        System.assertEquals(1, conList[0].Enrolled_Sessions__c, 'Contact have one enrolled session.');
        
        Test.startTest();
        
        List<Attendee__c> attendeesList = TestFactory.createAttendeeRecords(conList, sessionList, 3);//inserting attendee records

        //Fetching updated contact records
        List<Contact> updatedConList = [SELECT Id, Enrolled_Sessions__c FROM Contact WHERE Id IN : conList LIMIT 3];
        
        // Verify the Contact records were updated
        System.assertEquals(2, updatedConList[0].Enrolled_Sessions__c, 'Contact should have 2 enrolled session.');
        System.assertEquals(2, updatedConList[1].Enrolled_Sessions__c, 'Contact should have 2 enrolled session.');
        System.assertEquals(2, updatedConList[2].Enrolled_Sessions__c, 'Contact should have 2 enrolled session.');

        Test.stopTest();
    }


    /**
     * Description : Created a Test method to check after Insert negative scenerio while inserting Attendee Records .
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 13/12/2024
     * 
     * Modified : 
     * 
     */     

    @isTest
    static void afterInsertNegativeTesting() {
        
        // Fetching session new rcords to insert attendee record 
        List<Training_Session__c> sessionList = [SELECT Id FROM Training_Session__c LIMIT 2];
        
        //inserting attendee records
        List<Attendee__c> attendeesList = TestFactory.createAttendeeRecords(null, sessionList, 3);
                    
        Test.startTest();
       
		//Fetching Not updated contact record
        List<Contact> notUpdatedContact = [SELECT Enrolled_Sessions__c FROM Contact LIMIT 3];

        System.assertEquals(1, notUpdatedContact[0].Enrolled_Sessions__c, 'Contact should have not updated with enrolled session.');
        System.assertEquals(1, notUpdatedContact[1].Enrolled_Sessions__c, 'Contact should have not updated with enrolled session.');
        System.assertEquals(1, notUpdatedContact[2].Enrolled_Sessions__c, 'Contact should have not updated with enrolled session.');
        
        Test.stopTest();
    }
    
    
    /**
     * Description : Created a Test method to check after Update positive o while updating Attendee Records .
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 13/12/2024
     * 
     * Modified : 
     * 
     */    

    @IsTest
    static void afterUpdatePositiveTesting() {
        // Fetching existing Attendees, Contact and session records to update the records
        List<Contact> conList = [SELECT Id FROM Contact LIMIT 3];

        List<Training_Session__c> sessionList = [SELECT Id FROM Training_Session__c WHERE Name = 'Session2' LIMIT 1];  

        List<Attendee__c> attendeeList = [SELECT Id, Training_Session__c, Contact__c FROM Attendee__c LIMIT 3];

        // Update Attendees with a new Training Session
        List<Attendee__c> updatedAttendeeList = new List<Attendee__c>();
        for(Attendee__c att : attendeeList) {
            updatedAttendeeList.add(new Attendee__c(Id = att.Id, Training_Session__c = sessionList[0].Id));

        }
        
        Test.startTest();
        update updatedAttendeeList;
       
        // Verify the Contact records were updated
        List<Contact> updatedContacts = [SELECT Id, Enrolled_Sessions__c FROM Contact LIMIT 3];
        System.assertEquals(1, updatedContacts[0].Enrolled_Sessions__c, 'Contact should have one enrolled session.');
        System.assertEquals(1, updatedContacts[1].Enrolled_Sessions__c, 'Contact should have one enrolled session.');
        System.assertEquals(1, updatedContacts[2].Enrolled_Sessions__c, 'Contact should have one enrolled session.');
            
        Test.stopTest();        
    }
    
    /**
     * Description : Created a Test method to check after Update negative scenerio while updating Attendee Records with changed Contact .
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 13/12/2024
     * 
     * Modified : 
     * 
     */    
    @IsTest
    static void afterUpdateContactChangeNegativeTesting() {
        // Fetch existing Attendees
        List<Attendee__c> attendeesList = [SELECT Id, Contact__c, Training_Session__c FROM Attendee__c 
                                           WHERE Contact__c != null LIMIT 2];
        
        List<Contact> contactListBeforeUpdate = [SELECT Id, Enrolled_Sessions__c FROM Contact LIMIT 2];
        System.assertEquals(1, contactListBeforeUpdate[0].Enrolled_Sessions__c, 'Contact should have one enrolled session.');
        System.assertEquals(1, contactListBeforeUpdate[0].Enrolled_Sessions__c, 'Contact should have one enrolled session.');
        
        Test.startTest();
        // Negative Test: Ensure no update if Contact__c is changed
        Attendee__c att = new Attendee__c(Id = attendeesList[0].Id, Contact__c = attendeesList[1].Contact__c);
        update att;
            
        Contact affectedContactWithNoAattendee = [SELECT Id, Enrolled_Sessions__c FROM Contact WHERE Id = :attendeesList[0].Contact__c];
        Contact affectedContactWithIncreaseAttendee = [SELECT Id, Enrolled_Sessions__c 
                                                       FROM Contact WHERE Id = :attendeesList[1].Contact__c];
        System.assertEquals(0, affectedContactWithNoAattendee.Enrolled_Sessions__c, 'Contact should decrease count with null Enrolled Session.');
        System.assertEquals(2, affectedContactWithIncreaseAttendee.Enrolled_Sessions__c, 
                                'Contact should Increase count with 2 Enrolled Session.');

        Test.stopTest();
    }
    
    
    /**
     * Description : Created a Test method to check after Delete positive scenerio while deketing Attendee Records .
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 13/12/2024
     * 
     * Modified : 
     * 
     */ 
    
    @isTest
    static void afterDeletePositiveTesting() {
        // Fetching existing Attendees
        List<Attendee__c> attendeesToDelete = [SELECT Id, Contact__c FROM Attendee__c WHERE Contact__c != null LIMIT 2];
        
        // Querying all Contacts records bwfoew deleting Related attendee records
        List<Contact> contactsList = [SELECT Id, Enrolled_Sessions__c FROM Contact];
        System.assertEquals(1, contactsList[0].Enrolled_Sessions__c, 'Contact should have 1 enrolled sessions after deletion.');
        System.assertEquals(1, contactsList[1].Enrolled_Sessions__c, 'Contact should have 1 enrolled sessions after deletion.');    
        
        Test.startTest();
        
        delete attendeesToDelete; // Delete Attendees records
        
        // Storing ID of all deleted records
        Set<Id> affectedContactIds = new Set<Id>();
        for (Attendee__c attendee : attendeesToDelete) 
        {
            affectedContactIds.add(attendee.Contact__c);
        }
        
        // Querying all Contacts whose child Attendee records are deleted
        List<Contact> updatedContacts = [SELECT Id, Enrolled_Sessions__c FROM Contact WHERE Id IN :affectedContactIds];
        
        System.assertEquals(0, updatedContacts[0].Enrolled_Sessions__c, 'Contact should have no enrolled sessions after deletion.');
        System.assertEquals(0, updatedContacts[1].Enrolled_Sessions__c, 'Contact should have no enrolled sessions after deletion.');       
        
        // Quering the contact record which are not associated with any deleted attendee 
        List<Contact> unrelatedContact = [SELECT Id, Enrolled_Sessions__c FROM Contact WHERE Id NOT IN :affectedContactIds LIMIT 1];
        System.assertEquals(1, unrelatedContact[0].Enrolled_Sessions__c, 'Contact should have one sessions after deletion of any attendee record.');
        Test.stopTest();
    }
    
    
    /**
     * Description : Created a Test method to check after Delete Negative scenerio while deketing Attendee Records .
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 13/12/2024
     * 
     * Modified : 
     * 
     */ 

    @isTest
    static void afterDeleteNegativeTesting() {
        
        //Querying one Training Session Record 
        List<Training_Session__c> sessionsList = [SELECT Id FROM Training_Session__c WHERE Name = 'Session2' LIMIT 1];
        
        List<Contact> contactsList = [SELECT Id, Enrolled_Sessions__c FROM Contact LIMIT 3]; //Querying all contact before dml
        //checking for contact record's enrolled session count to be zero
        Assert.areEqual(1, contactsList[0].Enrolled_Sessions__c, 'Contact should have 0 enrolled session');
        Assert.areEqual(1, contactsList[1].Enrolled_Sessions__c, 'Contact should have 0 enrolled session');
        Assert.areEqual(1, contactsList[2].Enrolled_Sessions__c, 'Contact should have 0 enrolled session');

        //Creating attendee record without contact to delete. 
        List<Attendee__c> attendeesList = TestFactory.createAttendeeRecords(null, sessionsList, 3);
		        
        Test.startTest();
        //Querying all Attendee Records.
        Assert.areEqual(6, [SELECT Count() From Attendee__c], 'total 6 records must show after inserting 3 new records');

        delete attendeesList;
        
        // Querying all Contacts 
        List<Contact> updatedContacts = [SELECT Id, Enrolled_Sessions__c FROM Contact LIMIT 3];
        
        Assert.areEqual(1, updatedContacts[0].Enrolled_Sessions__c, 
                            'Contact should have not affected because deleted attendee not associated with any of the contact.');
        Assert.areEqual(1, updatedContacts[1].Enrolled_Sessions__c, 
                            'Contact should have not affected because deleted attendee not associated with any of the contact.');
        Assert.areEqual(1, updatedContacts[2].Enrolled_Sessions__c, 
                            'Contact should have not affected because deleted attendee not associated with any of the contact.');             
        Test.stopTest();        
    }    
    
    
    /**
     * Description : Created a Test method to check and update enrolled count on contact object whenever a attendee record insert, 
     *               update and delete .
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 13/12/2024
     * 
     * Modified : 
     * 
     */
    
    @isTest
    public static void countAttendeeforContact() {
        
        // Fetching existing Attendees
        List<Attendee__c> attendeesList = [SELECT Id, Contact__c FROM Attendee__c LIMIT 3];
        
        // Fetching existing Attendees
        List<Contact> conList = [SELECT Id, Enrolled_Sessions__c FROM Contact LIMIT 3];
            
        // Fetching existing Training_Session__c
        List<Training_Session__c> sessionList = [SELECT Id FROM Training_Session__c LIMIT 2];
        
       // List<Attendee__c> attendeesList = TestFactory.createAttendeeRecords(contactsList, sessionList, 1);

        //Prepare a map of contacts to pass to the method
        Map<Id, Contact> mapOfContacts = new Map<Id, Contact>{
            conList[0].Id => new Contact(Id = conList[0].Id, Enrolled_Sessions__c = 0),
            conList[1].Id => new Contact(Id = conList[1].Id, Enrolled_Sessions__c = 0),
            conList[2].Id => new Contact(Id = conList[2].Id, Enrolled_Sessions__c = 0)
        };
        
        //Call the method to test
        Test.startTest();
        AttendeeTriggerHandler.countAttendeeforContact(mapOfContacts);
        
        List<Contact> updatedConList = [SELECT Id, Enrolled_Sessions__c FROM Contact];
        
        // Assert that the attendee count matches the expected values
        Assert.areEqual(1, updatedConList[0].Enrolled_Sessions__c, 'Contact on 0 index should have 2 enrolled sessions.');
        Assert.areEqual(1, updatedConList[1].Enrolled_Sessions__c, 'Contact on 1 index should have 2 enrolled sessions.');

        Test.stopTest();        
    }
       
}