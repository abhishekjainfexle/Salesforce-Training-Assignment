trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    
    AccountTriggerHandler.countContactRecord(Trigger.new, Trigger.old);
    
}