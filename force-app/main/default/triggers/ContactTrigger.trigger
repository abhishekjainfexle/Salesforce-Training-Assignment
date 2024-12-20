/**
* Prupose : Trigger to handle Operation for Contact Object
* 
* Created Date : 05-12-2024
* 
* Created By : Abhishek Jain
* 
* Revision Logs : V_1.0 - Created
* 
* */

trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
           new ContactTriggerHandler().run();

    
}