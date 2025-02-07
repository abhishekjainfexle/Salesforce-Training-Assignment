public without sharing class ContactController {
    @AuraEnabled
    public static void updateContacts(List<Contact> contacts) {
        if (contacts != null && !contacts.isEmpty()) {
            update contacts;
        }
    }
}