/**
    * Prupose : Class to show the use of Asynchronous apex schedulableable Class.
    * 
    * Created Date : 17-12-2024
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */
global without sharing class DailyLeadProcessor implements schedulable {
    
    global void execute(schedulableContext bc)
    {
        List<Lead> leadsToUpdateList = new List<Lead>();
        
        for(Lead lead : [SELECT Id, LeadSource FROM LEAD WHERE LeadSource = null LIMIT 200])
        {
            lead.LeadSource = 'Dreamforce';
            leadsToUpdateList.add(lead);
        }
        update leadsToUpdateList;
    } 

}