/**
    * Description : Batch classgeneric batch class that archives data, sends an email with the CSV attached, 
    * 				and deletes the records based on the specified object and period:.
    * 
    * @Return : 
    * 
    * @Arguments : List<Contact> newContactList
    * 
    * CreatedBy : Abhishek Jain
    * 
    * Created Date : 27/12/2024
    * 
    * Modified Date : 03/01/2025
    * */   
public without sharing class ArchiveSobjectAndSendMailBatch implements Database.Batchable<sObject>, Database.stateful{
    
   public final String objName;
   public final Decimal duration;
   public final String Filter;
   public final List<String> fieldNames;
    
   // Use a List to store CSV data for attachments
   private List<String> csvDataList = new List<String>();
   private List<sObject> recordsToDelete = new List<sObject>();

    
   //private List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
   //Constructor
    public ArchiveSobjectAndSendMailBatch(String objName, Decimal duration, String filter, List<String> fieldNames){
      this.objName = objName; 
      this.duration = duration; 
      this.Filter = filter;
      this.fieldNames = fieldNames;

   }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Ensure fieldNames are joined correctly and end properly
        String fieldsQuery = String.join(fieldNames, ', ');
        
        // Validate if objName and filter are properly provided
    if (String.isBlank(objName) || String.isBlank(filter)) {
        System.debug('Validation failed: objName or filter is blank.');
        throw new IllegalArgumentException('Object name or filter cannot be blank.');
    }
        
        // Construct the SOQL query dynamically
        String query = 'SELECT ' + fieldsQuery + 
            ' FROM ' + objName + 
            ' WHERE ' + filter + 
            ' AND CreatedDate = LAST_N_DAYS:' + duration;
        
        // Return the query locator
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope){
        recordsToDelete.addAll(scope);
        // Build CSV header dynamically
        String csvHeader = String.join(fieldNames, ',') + '\n';
        String csvData = csvHeader;
        
        // Iterate through the scope to build CSV rows
        for (SObject sObj : scope) {
            List<String> fieldValues = new List<String>();
            
            for (String fieldName : fieldNames) {
                // Retrieve the value dynamically and handle nulls
                Object value = sObj.get(fieldName);
                fieldValues.add(value != null ? String.valueOf(value) : '');
            }
            
            // Append the field values as a CSV row
            csvData += String.join(fieldValues, ',') + '\n';
        }
        
        // Add CSV data to the list so that we can use it in finish method
        csvDataList.add(csvData);
        System.debug('CSV Data in Execute: ' + csvData);
    }
    
    public void finish(Database.BatchableContext bc){
        
        //Blob.valueOf(finalCsvData) Casts the specified String to a Blob . that's why we are converting it in string
        String finalCsvData = '';
        for(String csvdata : csvDataList){
            finalCsvData += csvdata;
        }
        
        // Attach the CSV data
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(objName + '.csv');
        attachment.setBody(Blob.valueOf(finalCsvData));//Blob.valueOf(finalCsvData) Casts the specified String to a Blob 
        attachment.setContentType('text/csv');
        // Send the email with the CSV attachment
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{'abhishekjain11495@gmail.com'});
        email.setSubject('Exported '+ objName + 'Data');
        email.setPlainTextBody('Please find attached the exported account data.');
        email.setFileAttachments(new List<Messaging.EmailFileAttachment>{ attachment });
		
         try {
        Messaging.sendEmail(new List<Messaging.Email>{email});
        System.debug('Email sent successfully.');

        // Perform deletion of the archived records
        delete recordsToDelete;
    } catch (Exception ex) {
        System.debug('Email sending failed: ' + ex.getMessage());
    }
   
    }

}