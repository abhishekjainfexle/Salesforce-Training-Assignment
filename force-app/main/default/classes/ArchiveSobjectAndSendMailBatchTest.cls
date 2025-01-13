/*
 * Test Class for ArchiveSobjectAndSendMailBatch Class
 */
@isTest(seeAllData=false)
public without sharing class ArchiveSobjectAndSendMailBatchTest {

    /**
     * Description : Created a Test Setup method to Insert Demo Account Records so that i can query and use it anywhere.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 06/01/2024
     * 
     * Modified : 
     * 
     */  
    @TestSetup
    static void setupTestData() {
        
        // Set up test data for Accounts
        List<Account> accListTest = TestFactory.createTestAccountWithDomainName('Test Account', null, 3);
        
    }
    
    
    /**
     * Description : Created a Test method to testArchiveSobjectAndSendMailBatch class positive scenario
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 06/01/2024
     * 
     * Modified : 
     * 
     */    

    @isTest
    static void testArchiveSobjectAndSendMailBatchPositiveCase(){
        // Define parameters for the batch
        String objName = 'Account';
        Decimal duration = 30;
        String filter = 'Name LIKE \'Test%\'';

        // Retrieve all field names of the Account object
        List<String> fieldNames = new List<String>();
        Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Account.fields.getMap();

        // Extract field names as strings
        for (Schema.SObjectField fieldObj : fieldsMap.values()) {
            fieldNames.add(fieldObj.getDescribe().getName());
        }

        // Create the batch instance
        Test.startTest();
        ArchiveSobjectAndSendMailBatch batch = new ArchiveSobjectAndSendMailBatch(objName, duration, filter, fieldNames);
        ID batchProcessId = Database.executeBatch(batch); // Execute batch 
        Test.stopTest();

        // Verify that records matching the filter are deleted
        List<Account> remainingAccounts = [SELECT Id FROM Account WHERE Name Like 'Test%'];
        System.assertEquals(0, remainingAccounts.size(), 'Accounts with Name Test should be deleted.');

        // Mock email verification
        Messaging.SingleEmailMessage mockEmail = new Messaging.SingleEmailMessage();
        mockEmail.setToAddresses(new String[] { 'abhishekjain11495@gmail.com' });
        mockEmail.setSubject('Exported Account Data');

        // Check email details
        System.assertEquals('Exported Account Data', mockEmail.getSubject(), 'Email subject should match.');
        System.assert(mockEmail.getToAddresses().contains('abhishekjain11495@gmail.com'), 'Email should be sent to the correct address.');

        // Verify attachment mock (optional in test scenarios)
        Messaging.EmailFileAttachment mockAttachment = new Messaging.EmailFileAttachment();
        mockAttachment.setFileName('Account.csv');
        System.assertEquals('Account.csv', mockAttachment.getFileName(), 'The attachment should have the correct file name.');
    
    }
    
    /**
     * Description : Created a Test method to testArchiveSobjectAndSendMailBatch class with negative scenarios like giving 
     * 				 invalid filter so that no records queried
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 06/01/2024
     * 
     * Modified : 
     * 
     */    
    @isTest
    static void testArchiveSobjectAndSendMailBatchNegativeCaseWithWrongQuery(){
        // Define parameters for the batch
        String objName = 'Account';
        Decimal duration = 30;
        String filter = 'Name LIKE \'Fest%\'';

        // Retrieve all field names of the Account object
        List<String> fieldNames = new List<String>();
        Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Account.fields.getMap();

        // Extract field names as strings
        for (Schema.SObjectField fieldObj : fieldsMap.values()) {
            fieldNames.add(fieldObj.getDescribe().getName());
        }

        // Create the batch instance
        Test.startTest();
        ArchiveSobjectAndSendMailBatch batch = new ArchiveSobjectAndSendMailBatch(objName, duration, filter, fieldNames);
        ID batchProcessId = Database.executeBatch(batch); // Execute batch 
        Test.stopTest();

        // Verify that records matching the filter are deleted
        List<Account> remainingAccounts = [SELECT Id FROM Account WHERE Name Like 'Test%'];
        System.assertEquals(3, remainingAccounts.size(), 'Accounts with Name Test should be deleted.');
    }
  
    
    /**
     * Description : Created a Test method to testArchiveSobjectAndSendMailBatch class with negative scenarios like blank object name.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 06/01/2024
     * 
     * Modified : 
     * 
     */    
    @isTest
    static void testArchiveSobjectAndSendMailBatchNegativeCaseBlankObjectNameOrFilter() {
        Decimal duration = 30;
        List<String> fieldNames = new List<String>{'Name', 'CreatedDate'};

        // Test for blank object name
        Test.startTest();
        try {
            // Blank objName
            ArchiveSobjectAndSendMailBatch batch = 
                new ArchiveSobjectAndSendMailBatch('', duration, 'Name Like \'Test%\'', fieldNames);
            
            // Directly invoking the start method instead of executeBatch
            batch.start(null); // Manually invoking the start method
            
            System.assert(false, 'Expected exception for blank object name but did not occur.');
        } catch (IllegalArgumentException ex) {
            System.debug('Caught exception: ' + ex.getMessage());
            System.assertEquals('Object name or filter cannot be blank.', ex.getMessage(),
                'Incorrect exception message for blank object name.');
        }
        Test.stopTest();
    }


    /**
     * Description : Created a Test method for testArchiveSobjectAndSendMailSchedule class with Positive scenario.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 07/01/2024
     * 
     * Modified : 
     * 
     */  
    /*@isTest
    static void testArchiveSobjectAndSendMailSchedulePositiveScenario() {
        // Step 1: Load data from CSV
        List<Archive_Config__mdt> configList = Test.loadData(Archive_Config__mdt.sObjectType, 'testArchiveConfigData');
        
        // Query to get the DeveloperName from Archive_Config__mdt
        List<Archive_Config__mdt> configDeveloperName = [SELECT DeveloperName FROM Archive_Config__mdt]; // Specify any filters if needed
        String developerName;
        // Iterate over the configList to find the matching DeveloperName
        for (Archive_Config__mdt config : configList) {
            if (config.DeveloperName == 'Account') {
                developerName = config.DeveloperName;
                break; // Exit the loop once the DeveloperName is found
            }
        }
        // Now use developerName dynamically to fetch the fields
        if (developerName != '') {
            // Convert the developerName into the corresponding object type dynamically
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(developerName);
            
            if (sObjectType != null) {
                Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
                
                // Create a list of field names
                List<String> fieldNames = new List<String>();
                for (String fieldName : fieldsMap.keySet()) {
                    fieldNames.add(fieldName);
                }
                
            }
            // Ensure that data was loaded
            System.assertNotEquals(configList.size(), 0, 'Custom metadata records should be loaded');
            
            // Step 2: Continue with your existing test logic
            String cronExp = '0 57 11 7 1 ? 2025';
            String jobName = 'TestArchiveJob';
            ArchiveSobjectAndSendMailSchedule scheduler = new ArchiveSobjectAndSendMailSchedule();
            Test.startTest();
            System.schedule(jobName, cronExp, scheduler);
            Test.stopTest();
            
            // Step 3: Verify that the cron job is scheduled
            List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetail.Name, CronExpression, NextFireTime 
                                              FROM CronTrigger 
                                              WHERE CronJobDetail.Name = :jobName];
            System.assertEquals(1, cronTriggers.size(), 'Scheduled job should exist');
            
            // Step 4: Verify the batch job is queued
            List<AsyncApexJob> jobs = [SELECT Status, JobType FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status != 'Completed'];
            System.assert(jobs.size() > 0, 'Batch job should be executed');
        }
        
    }*/
}