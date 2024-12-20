/**
    * Prupose : Test Class for LeadProcessor Batch Class
    * 
    * Created Date : 17-12-2024
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */
@isTest
public class LeadProcessorTest {


     /**
     * Description : Created a Test Setup method to add Some Test Data for lead  Object.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 17/12/2024
     * 
     * Modified : 
     * 
     */    
    @testSetup
        static void setup()
    	{
        	List<Lead> leadsList = new List<Lead>();
            for(Integer i = 0; i < 200; i++)
            {
            leadsList.add(new Lead(
                FirstName = 'FirstName',
                LastName = 'LastName',
                Company = 'demo' + i,
                Status = 'Random Status'
            ));    
                
            }
            Insert leadsList;
        }

    /**
     * Description : Created a Test  method to Positive check testbatchClassMethods method of LeadProcessor Class.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 17/12/2024
     * 
     * Modified : 
     * 
     */        
    
    @isTest
    Static void testbatchClassMethods(){
        
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batch = Database.executeBatch(lp, 200);
        Test.stopTest();
        
        Assert.areEqual(200, [SELECT Count() FROM Lead WHERE LeadSource = 'Dreamforce']);
        }
}