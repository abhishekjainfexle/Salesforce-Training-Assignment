public without sharing class LWCAccountManagerWizardServiceClass {
    
    public static void updateContactsRecords(List<Contact> contacts) {
        if (contacts != null && !contacts.isEmpty()) {
            update contacts;
        }
    }

    public static void createContactRecords(String firstName, String lastName, String email, String phone, String accId, String customerstatus) {
        // Ensure the search text is not null or empty
        Contact con = new Contact(FirstName = firstName, LastName = lastName, Email = email, Phone = phone, AccountId = accId, Customer_status__c = customerstatus);
        System.debug('Contact : ' + con);
        insert con;

    }

}