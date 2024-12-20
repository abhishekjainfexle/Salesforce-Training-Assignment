/**
    * Prupose : Test Class for AddPrimaryContact Queueable Class
    * 
    * Created Date : 18-12-2024
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */
@isTest
public class AddPrimaryContactTest {


    /**
     * Description : Created a Test Setup method to add Some Test Data for Account Object.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 18/12/2024
     * 
     * Modified : 
     * 
     */    
    @testSetup
    static void setupData(){
        
        List<Account> newAccListtoInsert = new List<Account>();
        for(Integer i = 1; i <= 100; i++)
        {
            if(i <= 50)
            {
            newAccListtoInsert.add(new Account(Name = 'Test Account' + i, Billingstate = 'NY'));    
            }
            else
            {
            newAccListtoInsert.add(new Account(Name = 'Test Account' + i, Billingstate = 'CA'));    
            }
        }
        insert newAccListtoInsert;
        
    }
    
    /**
     * Description : Created a Test  method to Positive check AddPrimaryContactClass method of AddPrimaryContact Class.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 18/12/2024
     * 
     * Modified : 
     * 
     */       
    @isTest
    static void testAddPrimaryContactClass()
    {
    	Contact con = new Contact(LastName = 'LastName');  
        
        AddPrimaryContact apc = new AddPrimaryContact(con, 'CA');
        
        Test.startTest();
        system.enqueueJob(apc);
        Test.stopTest();
        
        Assert.areEqual(50, [SELECT Count() FROM Contact], 'Contact count must be 50 only');
    }
}