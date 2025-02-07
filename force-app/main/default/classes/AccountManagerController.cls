public without sharing class AccountManagerController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccount() {
    List<Account> accList = [SELECT Id, Name, AccountNumber, Website, Phone, AnnualRevenue FROM Account LIMIT 5];
    return accList;
}
}