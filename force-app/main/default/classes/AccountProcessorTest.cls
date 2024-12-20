/**
* Prupose : Test Class for AccountProcessor Class
* 
* Created Date : 13-12-2024
* 
* Created By : Abhishek Jain
* 
* Revision Logs : V_1.0 - Created
* 
* */
@isTest
public without sharing class AccountProcessorTest {
   
    /**
     * Description : Created a Test Setup method to add Some Test Data for Account and contact Object.
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
    static void setupTestData() {
        // Create 3 Account with number of contact field zero
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 1', Number_Of_Contact__c = 0),
            new Account(Name = 'Test Account 2', Number_Of_Contact__c = 0)
        };
        
        insert accounts;
        
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 1; i <= 9; i++) {
            contacts.add(new Contact(LastName = 'Test Contact ' + i, AccountId = (Math.mod(i, 2) == 0) ? accounts[0].Id : accounts[1].Id
            ));
        }
        insert contacts;
    }


    /**
     * Description : Created a Test  method to Positive check countContacts method of AccountProcessor Class.
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
    static void afterInsertPositiveAndNegativeTesting() {

        List<Account> setUpAccountsList = [SELECT Id, Number_Of_Contact__c FROM Account];
        
        Test.startTest();
        //Call the future method
        AccountProcessor.countContacts(new List<Id>{setUpAccountsList[0].Id, setUpAccountsList[1].Id});
        Test.stopTest();
        
        List<Account> accountsList = [SELECT Id, Number_Of_Contact__c FROM Account];

        System.AssertEquals(4, accountsList[0].Number_Of_Contact__c, 'Test Account 1 should have 4 contacts.');
        System.AssertEquals(5, accountsList[1].Number_Of_Contact__c, 'Test Account 2 should have 5 contacts.');

       
    }

    /**
     * Description : Created a Test  method to negative check countContacts method of AccountProcessor Class.
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
    static void testCountContactsWithNull() {
        // Test for null account ID list
        Test.startTest();
        AccountProcessor.countContacts(null);
        Test.stopTest();

        // No exception should be thrown and no update should occur
    }
}