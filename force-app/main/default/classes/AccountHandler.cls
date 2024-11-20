public with sharing class AccountHandler {
    public void handleAccount() {
    	System.debug('Handling account');
	}
 
	public void updateAccount(Account acc) {
        System.debug('Updating account: ' + acc.Name);
	}
 
	public void addContact(Contact con) {
        System.debug('Adding contact: ' + con.LastName);
	}
}