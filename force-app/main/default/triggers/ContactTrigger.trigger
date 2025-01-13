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
           
    /*if(trigger.isBefore && trigger.isInsert){
        ContactTriggerHandlerAmanSirAssignment.duplicateCheckOnContact(trigger.new);
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate || trigger.isDelete){
            
           //ContactTriggerHandlerAmanSirAssignment.countContactwithEmailWithoutEmail(trigger.new, trigger.old, trigger.oldMap);
            
        }
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
    ContactTriggerHandlerAmanSirAssignment.duplicateCheckOnContact(trigger.newMap);
    }}*/
    
}