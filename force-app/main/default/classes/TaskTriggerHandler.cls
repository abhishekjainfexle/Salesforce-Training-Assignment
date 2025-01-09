public without sharing class TaskTriggerHandler {
    
    public static void countTaskonAccount(List<Task> newTaskList, Map<Id, Task> oldTaskMap){
        
        Map<Id, Account> countTotalTaskMap = new Map<Id, Account>();
        
        for(Task tsk : newTaskList != null ? newTaskList : oldTaskMap.values()){
            
            Task oldTask = oldTaskMap != null ? (Task)oldTaskMap.get(tsk.Id) : null;
            
            if(tsk.WhatId != null && 
               (oldTaskMap == null || newTaskList == null || 
                (tsk.WhatId != oldTask.WhatId))){
                    
                    if(tsk.WhatId != null){
                        
                        countTotalTaskMap.put(tsk.WhatId, 
                                              new Account(Id = tsk.WhatId, Total_Activities__c = 0, Total_Closed_Activities__c = 0, Total_Open_Activities__c = 0));
                    }
                    if(oldTaskMap != null && oldTask.WhatId != null && tsk.WhatId != oldTask.WhatId){
                        
                        countTotalTaskMap.put(oldTask.WhatId, 
                                              new Account(Id = oldTask.WhatId, Total_Activities__c = 0, Total_Closed_Activities__c= 0, Total_Open_Activities__c = 0));
                    }
                }
            }
        
        if(!countTotalTaskMap.isEmpty()){
            
            Integer totalTask = 0;
            for(AggregateResult result : [SELECT WhatId, Count(Id) countIds
                                          FROM Task 
                                          WHERE WhatId IN :countTotalTaskMap.keySet() Group By WhatId])
            {
                Id accountId = (Id)result.get('WhatId');
                totalTask = (Integer)result.get('countIds');

                
                if (countTotalTaskMap.containsKey(accountId)) 
                {
                    countTotalTaskMap.get(accountId).Total_Activities__c = totalTask;
                }

            }   
            
			for(AggregateResult result : [SELECT WhatId, Count(Id) countIds
                                          FROM Event 
                                          WHERE WhatId IN :countTotalTaskMap.keySet() Group By WhatId])
            {
                Id accountId = (Id)result.get('WhatId');
                Integer totalEvent = (Integer)result.get('countIds');
                Integer totalTaskAndEvent = totalEvent + totalTask;
                
                countTotalTaskMap.put(accountId, 
                                      new Account(Id = accountId, Total_Activities__c = totalTaskAndEvent));
            } 
            update countTotalTaskMap.values();

        }
            
        }
        
    }