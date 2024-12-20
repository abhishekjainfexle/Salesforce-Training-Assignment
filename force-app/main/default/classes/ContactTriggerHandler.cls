/**
 * 
 * Prupose : Class to perform Some demo Operation on Contact object.
 * 
 * Created Date : 27-11-2024
 * 
 * Created By : Abhishek Jain
 * 
 * Revision Logs : V_1.0 - Created
 * 				   V_2.0 - Modified (Updated Trigger using FrameWork logic)
 * 
 * */


public without sharing class ContactTriggerHandler extends TriggerHandler{
   
   /**
   * Description : Validates that the email domain of a Contact matches the domain name
    * of the related parent Account during the 'before insert' trigger event.
    * Throws an error if the domains do not match.
    * 
    * @Return : void
    * 
    * @Arguments : 
    * 
    * CreatedBy : Abhishek Jain
    * 
    * Created Date : 27/11/2024
    * 
    * Modified Date : 11-12-2024 by Abhishek Jain
    * */    
    
    public override void beforeInsert() {
        
        // Map to hold Account IDs linked to the Contacts being inserted
        Map<Id, Account> mapOfAccountAndId = new Map<Id, Account>();
        
        // Collect Account IDs for Contacts that have AccountId and Email values
        for (Contact newCon : (List<Contact>) Trigger.new) {
            
            if (newCon.AccountId != null && newCon.Email != null) 
            {
                mapOfAccountAndId.put(newCon.AccountId, new Account()); // Use null initially; values will be populated later
            } 
            else 
            {
                System.debug('Skipping Contact: ' + newCon.Id + '. AccountId or Email is null.');
            }
        }
        
        // Delegate the main logic to a separate method
        handleContactBeforeLogicMainMethod(mapOfAccountAndId);
    }

    /**
   * Description : Validates that the email domain of a Contact matches the domain name
    * of the related parent Account during the 'before update' trigger event.
    * Throws an error if the domains do not match.
    * 
    * @Return : void
    * 
    * @Arguments : 

    * CreatedBy : Abhishek Jain
    * 
    * Created Date : 27/11/2024
    * 
    * Modified Date : 11-12-2024 by Abhishek Jain
    * */    
    
    public override void beforeUpdate() {
        
        // Map to hold Account IDs (key) for Contacts where validation is required
        Map<Id, Account> mapOfAccountAndId = new Map<Id, Account>();
        
        // Old values of Contacts before the update
        Map<Id, Contact> oldConMap = (Map<Id, Contact>) Trigger.oldMap;
        
        // Iterate through the new list of Contacts
        for (Contact newCon : (List<Contact>) Trigger.new) {
            
            // Check if AccountId and Email are not null and have been changed
            if (newCon.AccountId != null && newCon.Email != null && (newCon.AccountId != oldConMap.get(newCon.Id).AccountId || 
                 newCon.Email != oldConMap.get(newCon.Id).Email)) 
            {
                // Add the AccountId to the map for validation
                mapOfAccountAndId.put(newCon.AccountId, new Account());
            } 
            else 
            {
                // Log debug message for Contacts not requiring validation
                System.debug('Skipping Contact: ' + newCon.Id + 
                             '. AccountId or Email is null, or there is no relevant change.');
            }
        }
        
        // Delegate the validation logic to the common method
        handleContactBeforeLogicMainMethod(mapOfAccountAndId);
        
    }

    /**
   * Description : Main Logic to run in both Insert and update methods
    * 
    * @Return : void
    * 
    * @Arguments : 
    * 
    * CreatedBy : Abhishek Jain
    * 
    * Created Date : 27/11/2024
    * 
    * Modified Date : 11-12-2024 by Abhishek Jain
    * */    
    
        
    public static void handleContactBeforeLogicMainMethod(Map<Id, Account> mapOfId_Account) {
        
        // Initialize a map to store the queried Account records by their Id.
        Map<Id, Account> mapOfQueryAccountAndId = new Map<Id, Account>();
        
        // Check if the input map of Account Ids is not empty.
        if (!mapOfId_Account.isEmpty()) {
            
            // Query Account records for the given Account Ids and populate the map.
            for (Account acc : [SELECT Id, Domain_Name__c FROM Account WHERE Id IN :mapOfId_Account.keySet()]) 
            {
                mapOfQueryAccountAndId.put(acc.Id, acc);
            }
                        
            // Iterate through the new Contact records in the trigger context.
            for (Contact newCon : (List<Contact>) Trigger.new) {
                
                // Validate if the Contact has an AccountId and an Email, and if the Account exists in the queried map.
                if (newCon.AccountId != null && newCon.Email != null && mapOfQueryAccountAndId.containsKey(newCon.AccountId)) 
                {
                    
                    // Extract the email domain and compare it with the parent Account's Domain_Name__c field.
                    String emailDomain = newCon.Email.substringAfter('@').toLowerCase();
                    String accountDomain = mapOfQueryAccountAndId.get(newCon.AccountId).Domain_Name__c;
                    
                    // Add an error if the email domain does not match the Account's domain.
                    if (emailDomain != accountDomain) 
                    {
                        newCon.addError('The email domain ' + emailDomain +
                                        ' you are entering does not match the parent Account domain name ' +
                                        accountDomain + '.');
                    }
                }
                else 
                {
                    // Log skipped validation for Contacts that do not meet the criteria.
                    System.debug('Skipped validation for Contact: ' + newCon.Id +
                                 ' Either AccountId or Email is null, or AccountId not found in the map.');
                }
            }
        }
    }
    }