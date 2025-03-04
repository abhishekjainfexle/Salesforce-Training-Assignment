public without sharing class Assessment04MarchLWCController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        List<Account> accountList = [SELECT Id, Name, Phone, AccountNumber From Account ORDER BY CreatedDate DESC];
        return accountList;
    }
    
    @AuraEnabled()
    public static String createAccount(String accName, String accountNumber, String phone) {
        
        Account acc = new Account();
        acc.Name = accName;
        acc.AccountNumber = accountNumber;
        acc.Phone = phone;
        try{
            insert acc;
            return acc.Id;
        } catch (Exception e) {
            // Log the error and rethrow as a AuraHandledException.
            System.debug('Error creating Account: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void createContact(String firstName, String lastName, String email, String phone, String accId) {
        try {
            LWCAccountManagerWizardServiceClass.createContactRecords(firstName, lastName, email, phone, accId, 'Active');
        } catch (Exception e) {
            // Log the error and rethrow as a AuraHandledException.
            System.debug('Error creating contact: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    
}