/*
 * Test Class for ContactTriggerHandler
 */
@isTest(seeAllData=false)
public class ContactTriggerHandlerTest {
    
     /**
     * Description : Created a Test Setup method to Insert Demo Account Records so that i can query and use it anywhere.
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
        // Create an Account with a specific domain
        List<Account> accountList = TestFactory.createTestAccountWithDomainName('Test Account', 'fexle.com', 3); 
    }
    
    
     /**
     * Description : Created a Test method to check before Insert Trigger for Contact and inserting valid email address.
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
    static void beforeInsertValidEmailDomainTest() {
        // Fetch the Account created in the setup method
        Account acc = [SELECT Id, Domain_Name__c FROM Account WHERE Domain_Name__c = '1fexle.com' LIMIT 1];

        // Create a Contact with a matching email domain
        Contact validContact = TestFactory.createTestContact('TestFirstName', 'TestLastName', 'abhishekjain@1fexle.com', acc.Id ); 

        // Test insert
        Test.startTest();
        insert validContact;
        // Assert no errors on insert
        Contact insertedContact = [SELECT Id, Email FROM Contact WHERE Id = :validContact.Id];
        System.assertEquals('abhishekjain@1fexle.com', insertedContact.Email, 'Valid email domain should allow the insert.');
        
        Test.stopTest();

    }
    
    
     /**
     * Description : Created a Test method to check before Insert Trigger for Contact and inserting Invalid email address(Negative Testing).
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
    static void beforeInsertInvalidEmailDomainTest() {
        // Fetch the Account created in the setup method
        Account acc = [SELECT Id, Domain_Name__c FROM Account WHERE Domain_Name__c = '1fexle.com' LIMIT 1];

        // Create a Contact with a mismatching email domain
        Contact invalidContact = TestFactory.createTestContact('TestFirstName', 'TestLastName', 'abhishekjain@wrongdomain.com', acc.Id ); 


        // Test insert
        Test.startTest();
        try {
            insert invalidContact;
            System.assert(false, 'Expected DMLException on insert but did not receive one.');
        } catch (DmlException e) {
            // Verify the error message
            System.assert(e.getMessage().contains('The email domain wrongdomain.com you are entering does not match the parent Account domain name 1fexle.com.'), 
                                                  'Unexpected error message on update: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
     /**
     * Description : Created a Test method to check before Update Trigger for Contact and inserting Valid email address(Positive Testing).
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
    static void beforeUpdateValidEmailDomainTest() {
        // Fetch the Accounts created in the setup method
        Account acc1 = [SELECT Id, Domain_Name__c FROM Account WHERE Domain_Name__c = '1fexle.com' LIMIT 1];
        Account acc2 = [SELECT Id, Domain_Name__c FROM Account WHERE Domain_Name__c = '2fexle.com' LIMIT 1];
        
        // Create and insert a Contact
        Contact contactToUpdate = TestFactory.createTestContact('TestFirstName', 'TestLastName', 'abhishekjain@1fexle.com', acc1.Id ); 
        System.assertEquals('abhishekjain@1fexle.com', contactToUpdate.Email, 'Valid email domain should allow to insert.');

        // Update the Contact with a valid domain
        contactToUpdate.Email = 'updatedabhishek@2fexle.com';
        contactToUpdate.AccountId = acc2.Id;
        insert contactToUpdate;
        
        Test.startTest();
        update contactToUpdate;
        
        // Assert no errors on update
        Contact updatedContact = [SELECT Email FROM Contact WHERE Id = :contactToUpdate.Id];
        System.assertEquals('updatedabhishek@2fexle.com', contactToUpdate.Email, 'Valid email domain should allow the update.');
        
        Test.stopTest();
    }
    
     /**
     * Description : Created a Test method to check before Update Trigger for Contact and inserting Valid email address(Negative Testing).
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
    static void beforeUpdateInvalidEmailDomainTest() {
        // Fetch the Account created in the setup method
        Account acc = [SELECT Id, Domain_Name__c FROM Account WHERE Domain_Name__c = '1fexle.com' LIMIT 1];

        // Create and insert a Contact
        Contact contactToUpdate = TestFactory.createTestContact('TestFirstName', 'TestLastName', 'abhishekjain@1fexle.com', acc.Id ); 
		insert contactToUpdate;

        // Update the Contact with an invalid domain
        contactToUpdate.Email = 'abhishek@myntra.com';

        Test.startTest();
        try {
            update contactToUpdate;
            System.assert(false, 'Expected DMLException on update but did not receive one.');
        } catch (DmlException e) {
            // Verify the error message
            System.assert(e.getMessage().contains('The email domain myntra.com you are entering does not match the parent Account domain name 1fexle.com.') , 
                                                  'Unexpected error message on update: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    
     /**
     * Description : Created a Test method to check before Insert Trigger for Contact and inserting null value either for Email or for AccountId(Negative Testing).
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
    static void beforeInsertNoAccountOrEmailTest() {
        // Create a Contact without AccountId and Email
        List<Contact> contactWithoutAccountOrEmail = TestFactory.createContactWithoutAccountOrEmail('TestLastName', 1); 

        // Test insert
        Test.startTest();
        // Assert no errors on insert
        List<Contact> insertedContact = [SELECT Id FROM Contact WHERE Id = :contactWithoutAccountOrEmail[0].Id];
        Assert.areEqual(1, insertedContact.size(), 'Contact without AccountId or Email should allow the insert.');    
        Test.stopTest();

       
    }
    
    
     /**
     * Description : Created a positive Test method to check UseOfDynamicApex method from Contact Trigger Handler Class.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 02/01/2025
     * 
     * Modified : 
     * 
     */ 
    
    @isTest
    static void negativeTestshowPickListNamesAndObjectNameUsingDynamicApex() {
        // Create a valid Contact with a valid RecordId__c (Account Id)
        Account acc = [SELECT Id, Domain_Name__c FROM Account WHERE Domain_Name__c = '1fexle.com' LIMIT 1];

        // Create a Contact List with an invalid RecordId__c
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 1; i<5; i++){
            Contact invalidContact = new Contact(
                LastName = 'Invalid Contact' + i,
                RecordId__c = 'sdfsdvdv'
            );
            contactList.add(invalidContact);    
        }

        // Insert the contacts to trigger before insert logic
        Test.startTest();
        insert contactList;
        System.debug('@@@@@@22'+contactList);
        
        // Retrieve the contacts to validate the outcomes
        List<Contact> insertedContacts = [SELECT Id, Object_Name__c, Picklist_Field__c 
                                          FROM Contact
                                         ];
        // Assertions
        System.assertEquals(null, insertedContacts[0].Object_Name__c, 'The object name should not be set for an invalid RecordId__c.');
        Test.stopTest();
    }

    
    /**
     * Description : Created a positive Test method to check UseOfDynamicApex method from Contact Trigger Handler Class.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 02/01/2025
     * 
     * Modified : 
     * 
     */ 
    
    @isTest
    static void positiveTestshowPickListNamesAndObjectNameUsingDynamicApex() {
        // Create a valid Contact with a valid RecordId__c (Account Id)
        Account acc = [SELECT Id, Domain_Name__c FROM Account WHERE Domain_Name__c = '1fexle.com' LIMIT 1];

        // Create a Contact List with an valid RecordId__c
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 1; i<5; i++){
            Contact validContact = new Contact(
                LastName = 'valid Contact' + i,
                RecordId__c = acc.Id
            );
            contactList.add(validContact);    
        }

        // Insert the contacts to trigger before insert logic
        Test.startTest();
        insert contactList;
        
        // Retrieve the contacts to validate the outcomes
        List<Contact> insertedContacts = [
                                            SELECT Id, RecordId__c, LastName, Object_Name__c, Picklist_Field__c 
                                            FROM Contact
                                        ];
        
        // Assertions
        System.assertEquals('Account', insertedContacts[0].Object_Name__c, 'The object name should be Account.');
        System.assertNotEquals(null, insertedContacts[0].Picklist_Field__c, 'Picklist fields should be populated.');
        System.assertEquals('Account', insertedContacts[3].Object_Name__c, 'The object name should be Account.');
        System.assertNotEquals(null, insertedContacts[3].Picklist_Field__c, 'Picklist fields should be populated.');
        Test.stopTest();
    }
    
   
}