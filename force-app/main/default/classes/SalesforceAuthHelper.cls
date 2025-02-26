@RestResource(urlMapping='/Account/*')
global without sharing class SalesforceAuthHelper {
    
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            Map<String, String> params = req.params;
            if (params.containsKey('accountId')) {
                String idOfAccount = params.get('accountId');
                Account account = [SELECT Id, Name, Website FROM Account WHERE Id = :idOfAccount];
                
                if (account != null) {
                    Map<String, Object> responseMap = new Map<String, Object>{
                        'AccountId' => account.Id,
                            'Name' => account.Name,
                            'Website' => account.Website
                            };
                                
                                res.statusCode = 200;
                    res.responseBody = Blob.valueOf(JSON.serialize(responseMap));
                    res.addHeader('Content-Type', 'application/json');
                } else {
                    res.statusCode = 404; // Not Found
                    res.responseBody = Blob.valueOf('{"message": "Account not found"}');
                    res.addHeader('Content-Type', 'application/json');
                }
            } else {
                res.statusCode = 400; // Bad Request
                res.responseBody = Blob.valueOf('{"message": "Missing accountId parameter"}');
                res.addHeader('Content-Type', 'application/json');
            }
        } catch (Exception ex) {
            res.statusCode = 500; // Internal Server Error
            res.responseBody = Blob.valueOf('{"message": "Error processing request: ' + ex.getMessage() + '"}');
            res.addHeader('Content-Type', 'application/json');
        }
    }
    
    public class SmartyAddressWrapper {
        public String accountId;
    }
    
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            String body = req.requestBody.toString();
            Map<String, Object> inputData = (Map<String, Object>) JSON.deserializeUntyped(body);
            
            // Extract input values
            String accountName = (String) inputData.get('AccountName');
            String firstName = (String) inputData.get('FirstName');
            String lastName = (String) inputData.get('LastName');
            String email = (String) inputData.get('Email');
            
            // Check if contact with same email exists
            List<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email = :email];
            
            if (!existingContacts.isEmpty()) {
                res.statusCode = 400; // Bad Request
                res.responseBody = Blob.valueOf('{"message": "Contact with this email already exists"}');
                res.addHeader('Content-Type', 'application/json');
                return;
            }
            
            // Create account
            Account newAccount = new Account(Name = accountName);
            insert newAccount;
            
            // Create contact
            Contact newContact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email
            );
            insert newContact;
            
            // Prepare response
            Map<String, Object> responseMap = new Map<String, Object>{
                'AccountId' => newAccount.Id,
                    'ContactId' => newContact.Id
                    };
                        
                        res.statusCode = 201; // Created
            res.responseBody = Blob.valueOf(JSON.serialize(responseMap));
            res.addHeader('Content-Type', 'application/json');
        } catch (DmlException ex) {
            res.statusCode = 500; // Internal Server Error
            res.responseBody = Blob.valueOf('{"message": "Error creating records: ' + ex.getMessage() + '"}');
            res.addHeader('Content-Type', 'application/json');
        } catch (Exception ex) {
            res.statusCode = 500; // Internal Server Error
            res.responseBody = Blob.valueOf('{"message": "Error processing request: ' + ex.getMessage() + '"}');
            res.addHeader('Content-Type', 'application/json');
        }
    }
    
    
    
}