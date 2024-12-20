/**
    * Prupose : Class to show the use of Asynchronous apex Queueable Class.
    * 
    * Created Date : 18-12-2024
    * 
    * Created By : Abhishek Jain
    * 
    * Revision Logs : V_1.0 - Created
    * 
    * */

    global without sharing class AddPrimaryContact implements Queueable {
        global Contact contactrecord;
        global String statename;
    
    global AddPrimaryContact(Contact con, String state) {
        this.contactrecord = con;
        this.statename = state;
    }
    
    global void execute(QueueableContext bc) {
        List<Account> acclist = [SELECT Id, BillingState FROM Account WHERE BillingState = :statename LIMIT 200]; 
        
        List<Contact> conList = new List<Contact>();

        for (Account account : acclist) {
            Contact newContact = contactrecord .clone(false, false, false, false);
            newContact.AccountId = account.Id;
            conList.add(newContact);
        }
        
        insert conList;
    }
}