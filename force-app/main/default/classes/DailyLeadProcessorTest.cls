/**
    * Prupose : Test Class for dailyleadProcessor schedule Class
    * 
    * Created Date : 17-12-2024
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */
@isTest
public class DailyLeadProcessorTest {
	

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
    static void setup(){
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
     * Description : Created a Test  method to Positive check testScheduleClassDailyLeadProcessor method of dailyLeadProcessor Class.
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
    static void testScheduleClassDailyLeadProcessor()
    {
        String cronExpression = '0 5 12 * * ?';
        Test.startTest();
        String jobId = System.schedule('ScheduleLeadPrecessor', cronExpression , new DailyLeadProcessor());
        List<Lead> UpdatedLeadList = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = null LIMIT 200];
        Assert.areEqual(200, UpdatedLeadList.size(), 'Message');
        Test.stopTest();
    }
    
   
    
}