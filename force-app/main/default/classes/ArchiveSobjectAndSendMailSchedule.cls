public without sharing class ArchiveSobjectAndSendMailSchedule implements schedulable {

    public void  execute(schedulableContext bc){
        try {
            // Fetch the Archive_Config__mdt instance for 'Account'
            Archive_Config__mdt mc = Archive_Config__mdt.getInstance('Account');
            
            // Check if the metadata is null, throw an exception if not found
            if (mc == null) {
                throw new CustomException('Archive_Config__mdt record for Account not found.');
            }

            String objName = mc.DeveloperName;
            Decimal duration = mc.Duration_In_Month__c;
            String filter = mc.Filter__c;

            // Retrieve all field names of the Account object
            List<String> fieldNames = new List<String>();
            Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Account.fields.getMap();
            
            // Extract field names as strings
            for (Schema.SObjectField fieldObj : fieldsMap.values()) {
                fieldNames.add(fieldObj.getDescribe().getName());
            }
            
            // Execute the batch job
            Database.executeBatch(new ArchiveSobjectAndSendMailBatch(objName, duration, filter, fieldNames));
            
        } catch (Exception e) {
            // Log the error for debugging purposes
            System.debug('Error in ArchiveSobjectAndSendMailSchedule.execute: ' + e.getMessage());
            // Optionally, you can also email the admin or take other actions based on the failure
            // Add custom handling or alert as needed
        }
    }

    // Custom Exception Class (Optional)
    public class CustomException extends Exception {}
}