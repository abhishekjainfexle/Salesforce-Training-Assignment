/**
    * Prupose : Class to show the use of Asynchronous apex future method.
    * 
    * Created Date : 13-12-2024
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */

public without sharing class AccountProcessor {

        /**
        * Description : Method to show how to implement future method
        * @Return : void
        * @Arguments : 
        * CreatedBy : Abhishek Jain
        * Created Date : 13-12-2024
        *  
        * */

    @future
    public static void countContacts(List<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return; // Exit if the list is null or empty
        }

        // Create a set of account IDs
        Set<Id> setOfAccIds = new Set<Id>(accountIds);

        // Check if the set is not empty
        if (!setOfAccIds.isEmpty()) {
            // Map to store the count of contacts for each account
            Map<Id, Account> accountContactCountMap = new Map<Id, Account>();

            // Populate the map with the account id and account record with updated Number of Contact field count
            for (AggregateResult result : [SELECT AccountId, COUNT(Id) contactCount 
                                           FROM Contact 
                                           WHERE AccountId IN :setOfAccIds 
                                           GROUP BY AccountId]) {
                Id accountId = (Id) result.get('AccountId');
                Integer contactCount = (Integer) result.get('contactCount');
                accountContactCountMap.put(accountId, new Account(Id = accountId, Number_Of_Contact__c = contactCount));
            }

            // Perform the update
            if (!accountContactCountMap.isEmpty()) {
                update accountContactCountMap.values();
            }
        }
    }
}