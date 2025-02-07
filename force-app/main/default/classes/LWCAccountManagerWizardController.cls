public with sharing class LWCAccountManagerWizardController {
    @AuraEnabled
    public static void updateContacts(List<Contact> contacts) {
        if (contacts != null && !contacts.isEmpty()) {
            update contacts;
        }
    }

    @AuraEnabled
    public static void createContact(String firstName, String lastName, String email, String phone, String accId, String customerstatus) {
        // Ensure the search text is not null or empty
        Contact con = new Contact(FirstName = firstName, LastName = lastName, Email = email, Phone = phone, AccountId = accId, Customer_status__c = customerstatus);
        System.debug('Contact : ' + con);
        insert con;

    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accId) {
        
        return [SELECT Id, FirstName, LastName, Email, Phone, Account.Name FROM Contact WHERE AccountId = :accId];

    }

}