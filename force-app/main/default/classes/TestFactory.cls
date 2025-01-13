public class TestFactory {
   
    public static List<Account> createTestAccountWithDomainName(String name, String domainName, Integer numberOfAccount) {
        List<Account> accList = new List<Account>();
        for(Integer i = 1; i <= numberOfAccount; i++)
        {
            Account testAccount = new Account(
            Name = (name != null ? name : 'Test Account') + i,
            Domain_Name__c = i + (domainName != null ? domainName : '')
        );
        accList.add(testAccount);

        }
        insert accList;
        return accList;
    }

    
    public static Contact createTestContact(String firstName, String lastName, String email, Id accountId) {
        Contact testContact = new Contact(
            FirstName = firstName != null ? firstName : 'TestFirstName',
            LastName = lastName != null ? lastName : 'TestLastName',
            Email = email,
            AccountId = accountId
        );
        return testContact;
    }

    // Create test Contact   
    public static List<Contact> createContactWithoutAccountOrEmail(String lastName, Integer numberOfContact) {
    List<Contact> contacts = new List<Contact>();
    for (Integer i = 1; i <= numberOfContact; i++) {
        contacts.add(new Contact(LastName =  lastName + i));
    }
    insert contacts;
    return contacts;
}


    // Create test Training Sessions
    public static List<Training_Session__c> createTrainingSession(String name, String sessionType, Integer numberOfSession) {
    List<Training_Session__c> sessions = new List<Training_Session__c>();
    for (Integer i = 1; i <= numberOfSession; i++) {
        sessions.add(new Training_Session__c(Name = name + i, Session_Date__c = System.Today().addYears(i), Session_Type__c = sessionType));
    }
    insert sessions;
    return sessions;
}
    
    // Create test Attendees
    public static List<Attendee__c> createAttendeeRecords(List<Contact> contactList, List<Training_Session__c> sessionList, Integer numberOfAttendee) {
    List<Attendee__c> attendees = new List<Attendee__c>();
    for (Integer i = 0; i < numberOfAttendee; i++) {
        attendees.add(new Attendee__c(
            Contact__c = contactList != null ? contactList[i].Id : null,
            Training_Session__c = sessionList[0].Id
        ));
    }
    insert attendees;
    return attendees;
}

}