public class AccountTriggerHandler {
    
    public static void countContactRecord(List<contact> newconts, List<Contact> oldConts){
        Set<Id> accountIds = new Set<Id>();
        for(Contact con: newconts){
            if(con.AccountId != null){
                accountIds.add(con.AccountId);
            }
        }
        for(Contact con: oldConts){
            if(con.AccountId != null){
                accountIds.add(con.AccountId);
            }
        }
        
        Map<Id, Integer> AccountCountContactMap = new Map<Id, Integer>();
        
        List<AggregateResult> countContacts = [SELECT AccountId, Count(Id) FROM Contact WHERE AccountId IN :accountIds GROUP BY AccountId]; 
        
        for(AggregateResult ar : countContacts){
            Id accountId= (Id) ar.get('AccountId');
            Integer count = (Integer) ar.get('expr0');
            AccountCountContactMap.put(accountId, count);
           
        }
        List<Account> updatedaccount = new List<Account>();
        for(Id accountId :accountIds){
            Account acc = new Account();
            acc.Id = accountId;
            acc.Count_Contact__c = AccountCountContactMap.containsKey(accountId) ? AccountCountContactMap.get(accountId) : 0;
            updatedaccount.add(acc);
        }
        
         if (!updatedaccount.isEmpty()) {
                update updatedaccount;
            }
        
    } 
    
}