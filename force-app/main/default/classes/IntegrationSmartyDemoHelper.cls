public without sharing class IntegrationSmartyDemoHelper {
    
    /**
        * Description : Method to extract Contact Id From List of Contact.
        * 
        * @Return : void
        * 
        * @Arguments : List<Contact> newContactList
        * 
        * CreatedBy : Abhishek Jain
        * 
        * Created Date : 19/02/2025
        * 
        * Modified Date : 
    * */   
    
    public static void setOfContactId(List<Contact> newContactList){
        System.debug('getsetOfContactIdcontactIds' + newContactList);

        Set<Id> contactIds = new Set<Id>();
        
        for (Contact newCon : newContactList) {
            if (newCon.MailingStreet != null ||
                newCon.MailingCity != null ||
                newCon.MailingState != null
                ) {
                    contactIds.add(newCon.Id);
                }
        }
        // Call future method with contact Ids
        if (!contactIds.isEmpty()) {
            verifyMailingAddressWithSmartyApi(contactIds);
            System.debug('getsetOfContactIdcontactIds' + contactIds);
        }  
    }
    
    /**
        * Description : Future Method with Callout to Verify mailing Address via calling smarty api then again calling a method in same class to update contact.
        * 
        * @Return : void
        * 
        * @Arguments : Set<Id> contactIds
        * 
        * CreatedBy : Abhishek Jain
        * 
        * Created Date : 19/02/2025
        * 
        * Modified Date : 
    * */   
    
    @future(callout=true)
    public static void verifyMailingAddressWithSmartyApi(Set<Id> contactIds) {
        if (contactIds.isEmpty()) return;
        
        // Query contact record using parameter passed in method as Set of IDs.
        List<Contact> contactsToUpdate = [SELECT Id, MailingStreet, MailingCity, MailingState 
                                          FROM Contact WHERE Id IN :contactIds];
        if(!contactsToUpdate.isEmpty()){
            Map<Id, Boolean> contactVerificationResults = new Map<Id, Boolean>();
            
            for (Contact con : contactsToUpdate) {
                if(con.MailingStreet != null && con.MailingCity != null && con.MailingState != null){
                    //call the api if mailing Street, city and state value is not null.
                    Boolean isAddressMatched = ApiCall.fetchSmartyApi(con.MailingStreet, con.MailingCity, con.MailingState);
                    if (isAddressMatched != null) {
                        contactVerificationResults.put(con.Id, isAddressMatched);
                    }
                }
            }
            // Update contacts asynchronously
            if (!contactVerificationResults.isEmpty()) {
                updateContactsWithVerification(contactVerificationResults);
            }
        }
    }

    /**
        * Description : Method to update contact Record once address is verified via smarty via.
        * 
        * @Return : void
        * 
        * @Arguments : Map<Id, Boolean> contactVerificationResults
        * 
        * CreatedBy : Abhishek Jain
        * 
        * Created Date : 19/02/2025
        * 
        * Modified Date : 
    * */   
    public static void updateContactsWithVerification(Map<Id, Boolean> contactVerificationResults) {
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Id contactId : contactVerificationResults.keySet()) {
            Contact con = new Contact(Id = contactId, AddressVerifiedBySmarty__c = contactVerificationResults.get(contactId));
            contactsToUpdate.add(con);
        }

        if (!contactsToUpdate.isEmpty()) {
            try {
                update contactsToUpdate;
            } catch (Exception e) {
                System.debug('Error updating contacts: ' + e.getMessage());
            }
        }
    }
}