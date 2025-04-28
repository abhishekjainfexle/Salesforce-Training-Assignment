/**
    * Prupose : Class to show the Count Open cases using batch class.
    * 
    * Created Date : 17-01-2025
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */
global without sharing Class AccountSupportScoreBatch implements Database.Batchable<sObject>, Database.stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Status, Priority, AccountId, ClosedDate, CreatedDate FROM Case WHERE Status != \'Closed\'');
    }
    
    global void execute(Database.BatchableContext bc, List<Case> casesList){
        Map<Id, List<Case>> mapOfAccountIdWithCase = new Map<Id, List<Case>>();
        Map<Id, Account> mapOfIdWithAccount = new Map<Id, Account>();
        Integer count = 0;  
        
        for(Case cases : casesList)
        {
            if(cases.AccountId != null && String.isNotBlank(cases.Priority)){
                if(mapOfIdWithAccount.containsKey(cases.AccountId))
                {
                    
                    switch on cases.Priority {
                        when 'High' {		
                            count = 3;
                        }	
                        when 'Medium' {		// when block 2
                            count = 2;
                        }
                        when 'Low' {		// when block 3
                            count = 1;
                        }
                    }
                    Date createdDay = cases.CreatedDate.date();
                    Date today = Date.Today();
                    Integer difference = createdDay.daysBetween(today);
                    if(difference <= 30){
                        count += 1;
                    }
                    if(difference > 60){
                        count -= 1;
                    }
                    mapOfIdWithAccount.get(cases.AccountId).Support_Score__c = mapOfIdWithAccount.get(cases.AccountId).Support_Score__c + count;
                    
                }
                mapOfIdWithAccount.put(cases.AccountId, new Account(Id = cases.AccountId, Support_Score__c = count ));
            }
        }
        
        if(!mapOfIdWithAccount.isEmpty()){
            update mapOfIdWithAccount.values();
        }
        
        
    }
    
    public void finish(Database.BatchableContext bc)
    {
        //gfhfd
    }
    
    
}