/**
    * Prupose : Schedule class to call the batch class AccountSupportScoreBatch .
    * 
    * Created Date : 17-01-2025
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */
public without sharing class AccountSupportScoreBatchScheduler implements schedulable{
    
    public void  execute(schedulableContext bc){
        try {
            
            // Execute the batch job
            Database.executeBatch(new AccountSupportScoreBatch(), 50);
            
        } catch (Exception e) {
            // Log the error for debugging purposes
            System.debug('Error in AccountSupportScoreBatch.execute: ' + e.getMessage());
        }
    }
    
    
}