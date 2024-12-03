/**
 * Prupose : Class to have the logic to update Map With Employee List as value and their Department as key.
 * 
 * Created Date : 25-11-2024
 * 
 * Created By : Abhishek Jain
 * 
 * Revision Logs : V_1.0 - Created
 * 
 * */

public without sharing class DepartmentWithEmployeeData {
    
    public static void departmentEmployeeList() {
        
        Map<String, List<String>> listOfEmployeeToDepartmentMap = new Map<String, List<String>>();
        // Adding data into Map One by one
        listOfEmployeeToDepartmentMap.put('Salesforce', new List<String>{'Abhishek Jain', 'Aman jain', 'Ashutosh Jain'});
        listOfEmployeeToDepartmentMap.put('DSA', new List<String>{'Shubham', 'Rujul', 'Mayank'});
        listOfEmployeeToDepartmentMap.put('Full Stack', new List<String>{'Enna', 'meena'});
        listOfEmployeeToDepartmentMap.put('Mulesoft', new List<String>{'Sallu bhai', 'Akki bhai'});
        
        // Method - 2
        // Directly adding data into map
        /*Map<String, List<String>> listOfEmployeeToDepartmentMap = new Map<String, List<String>>{
           'Salesforce' => new List<String>{'Abhishek Jain', 'Aman jain', 'Ashutosh Jain'},
           'DSA' => new List<String>{'Shubham', 'Rujul', 'Mayank'},
           'Full Stack' => new List<String>{'Enna', 'meena'},
           'Mulesoft' => new List<String>{'Sallu bhai', 'Akki bhai'}};
           System.debug(listOfAccountToStringMap);*/
        
        for (String department : listOfEmployeeToDepartmentMap.keySet()) {
            //System.debug('Department: ' + department);
            //System.debug('Employees: ' + departmentEmployeeMap.get(department));
            //System.debug(department + ' : ' + departmentEmployeeMap.get(department));
            System.debug(department  + '  :  ' + String.join(listOfEmployeeToDepartmentMap.get(department), ', '));
            
        }
    }
}