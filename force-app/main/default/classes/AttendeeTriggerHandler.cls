/**
* Prupose : Class to handle methods for AttendeeTrigger Trigger
* 
* Created Date : 06-12-2024
* 
* Created By : Abhishek Jain
* 
* Revision Logs : V_1.0 - Created
* 
* */

public without sharing class AttendeeTriggerHandler extends TriggerHandler{
    
    
    /**
     * Description : Create a method to add newly inserted Attendee records related Contact Id in a map.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     *  
     * Created Date : 06/12/2024
     * 
     * Modified : 11-12-2024 Abhishek Jain
     * 
     */

    public override void afterInsert() {
        
        // Initialize a map to store Contact details with Contact Id as the key.
        Map<Id, Contact> mapOfContactDetails = new Map<Id, Contact>();
        
        // Iterate over the newly inserted Attendee records from the trigger context.
        for (Attendee__c att : (List<Attendee__c>) Trigger.new) {
            
            // Check if the Attendee record has a related Training Session and Contact.
            if (att.Training_Session__c != null && att.Contact__c != null) {
                
                // Add the Contact Id to the map with a default Enrolled_Sessions__c value of 0.
                mapOfContactDetails.put(att.Contact__c, new Contact(Id = att.Contact__c, Enrolled_Sessions__c = 0));
            }
        }
        
        // Call a method to process the map and count attendees for each Contact.
        countAttendeeforContact(mapOfContactDetails);
    }

    
   /**
     * Description : Create a method to add updated Attendee records' new and old Contact Ids in a Map.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 06/12/2024
     * 
     * Modified : 11-12-2024 Abhishek Jain
     * 
     */ 
    
    public override void afterUpdate() {
        
        // Initialize a map to store Contact details with Contact Id as the key.
        Map<Id, Contact> mapOfContactDetails = new Map<Id, Contact>();
        
        // Retrieve the old Attendee records from the trigger context.
        Map<Id, Attendee__c> oldAttendeeMap = (Map<Id, Attendee__c>) Trigger.oldMap;
        
        // Iterate over the updated Attendee records from the trigger context.
        for (Attendee__c att : (List<Attendee__c>) Trigger.new) {
            
            // Check if the Training Session or Contact has changed between the old and new records.
            if (att.Training_Session__c != null && att.Contact__c != null &&
                (att.Training_Session__c != oldAttendeeMap.get(att.Id).Training_Session__c ||
                 att.Contact__c != oldAttendeeMap.get(att.Id).Contact__c)) {
                     
                     // Add the new Contact Id to the map if it exists.
                     if (att.Contact__c != null) 
                     {
                         mapOfContactDetails.put(att.Contact__c, new Contact(Id = att.Contact__c, Enrolled_Sessions__c = 0));
                     }
                     
                     // Add the old Contact Id to the map if it exists and differs from the new Contact Id.
                     if (Trigger.new != null && oldAttendeeMap.get(att.Id).Contact__c != null &&
                         att.Contact__c != oldAttendeeMap.get(att.Id).Contact__c) 
                     {
                         mapOfContactDetails.put(oldAttendeeMap.get(att.Id).Contact__c, 
                                                 new Contact(Id = oldAttendeeMap.get(att.Id).Contact__c, Enrolled_Sessions__c = 0));
                     }
                 }
        }
        
        // Call a method to process the map and count attendees for each Contact.
        countAttendeeforContact(mapOfContactDetails);
    }
    
    
   /**
     * Description : Create a method to add deleted Attendee records' Contact Ids in a Map.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 06/12/2024
     * 
     * Modified : 11-12-2024 Abhishek Jain
     * 
     */ 

    public override void afterDelete() {
        
        // Initialize a map to store Contact details with Contact Id as the key.
        Map<Id, Contact> mapOfContactDetails = new Map<Id, Contact>();
        
        // Iterate over the deleted Attendee records from the trigger context.
        for (Attendee__c att : (List<Attendee__c>) Trigger.old) {
            
            // Check if the Attendee record has a related Training Session and Contact.
            if (att.Training_Session__c != null && att.Contact__c != null) {
                
                // Add the Contact Id to the map with a default Enrolled_Sessions__c value of 0.
                mapOfContactDetails.put(att.Contact__c, new Contact(Id = att.Contact__c, Enrolled_Sessions__c = 0));
            }
        }
        
        // Call a method to process the map and count attendees for each Contact.
        countAttendeeforContact(mapOfContactDetails);
    }
    
   /**
     * Description : Create a method to update the Contact record's count on DML operations like insert, update, and delete.
     * 
     * @Return : Void
     * 
     * Created By : Abhishek Jain
     * 
     * Created Date : 06/12/2024
     * 
     * Modified : 11-12-2024 Abhishek Jain
     * 
     */ 

    public static void countAttendeeforContact(Map<Id, Contact> mapOfIdAndContact) {
        
        // Check if the input map is not empty.
        if (!mapOfIdAndContact.isEmpty()) {
            
            // Perform an aggregate query to count distinct Attendee records grouped by Contact Id.
            for (AggregateResult result : [SELECT COUNT_DISTINCT(Id) totalAttendee, Contact__c
                                           FROM Attendee__c
                                           WHERE Contact__c IN : mapOfIdAndContact.keySet()
                                           AND Training_Session__c != null
                                           GROUP BY Contact__c]) {
                                               
                                               // Retrieve the Contact Id and total attendee count from the query result.
                                               Id contactId = (Id) result.get('Contact__c');
                                               Integer enrolledCount = (Integer) result.get('totalAttendee');
                                               
                                               // Update the attendee count directly in the map passed to the method.
                                               if (mapOfIdAndContact.containsKey(contactId)) {
                                                   mapOfIdAndContact.get(contactId).Enrolled_Sessions__c = enrolledCount;
                                               }
                                           }
            
            // Update the Contact records with the new attendee counts.
            update mapOfIdAndContact.values();
        }
    }
}