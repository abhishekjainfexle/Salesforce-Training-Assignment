/**
 * Prupose : Class to have the logic to perform Set operation on 2 student group data.
 * 
 * Created Date : 25-11-2024
 * 
 * Created By : Abhishek Jain
 * 
 * Revision Logs : V_1.0 - Created
 * 
 * */

public without sharing class StudentSets {
    
    public static void studentSetsOperationData(){
        
        // 2 diifrence set of data
        Set<String> studentGroupA = new Set<String>{'Abhishek', 'BHarat', 'Aman', 'Ashutosh'};
        Set<String> studentGroupB = new Set<String>{'Shubham', 'Aman', 'Abhishek', 'Mayank'};
        
            // Union of two Student list
        Set<String> setOfUnion = new Set<String>(studentGroupA);
        setOfUnion.addAll(studentGroupB);
        
             // Intersection of two Student list
        Set<String> setOfIntersectionSet = new Set<String>(studentGroupA);
        setOfIntersectionSet.retainAll(studentGroupB);
        
            // Difference of two Student list        
        Set<String> setOfDifferenceSet = new Set<String>(studentGroupA);
        setOfDifferenceSet.removeAll(studentGroupB);
        
        // Debug logs
        System.debug('Group A: ' + studentGroupA);
        System.debug('Group B: ' + studentGroupB);
        System.debug('Union of Group A and Group B: ' + setOfUnion);
        System.debug('Intersection of Group A and Group B: ' + setOfIntersectionSet);
        System.debug('Difference of Group A and Group B (A - B): ' + setOfDifferenceSet);
        
    }
    
}