public without sharing class EventTriggerHandler {
    
    public static void countEventonAccount(List<Event> newEventList, Map<Id, Event> oldEventMap){
        
        Map<Id, Account> countTotalEventMap = new Map<Id, Account>();
        
        for(Event evnt : newEventList != null ? newEventList : oldEventMap.values()){
            
            Event oldEvent = oldEventMap != null ? (Event)oldEventMap.get(evnt.Id) : null;
            
            if(evnt.WhatId != null && 
               (oldEventMap == null || newEventList == null || 
                (evnt.WhatId != oldEvent.WhatId))){
                    
                    if(evnt.WhatId != null){
                        
                        countTotalEventMap.put(evnt.WhatId, 
                                              new Account(Id = evnt.WhatId, Total_Activities__c = 0, Total_Closed_Activities__c = 0, Total_Open_Activities__c = 0));
                    }
                    if(oldEventMap != null && oldEvent.WhatId != null && evnt.WhatId != oldEvent.WhatId){
                        
                        countTotalEventMap.put(oldEvent.WhatId, 
                                              new Account(Id = oldEvent.WhatId, Total_Activities__c = 0, Total_Closed_Activities__c= 0, Total_Open_Activities__c = 0));
                    }
                }
            }
        
        if(!countTotalEventMap.isEmpty()){
            
            Integer totalTask = 0;
            for(AggregateResult result : [SELECT WhatId, Count(Id) countIds
                                          FROM Task 
                                          WHERE WhatId IN :countTotalEventMap.keySet() Group By WhatId])
            {
                Id accountId = (Id)result.get('WhatId');
                totalTask = (Integer)result.get('countIds');

                
                if (countTotalEventMap.containsKey(accountId)) 
                {
                    countTotalEventMap.get(accountId).Total_Activities__c = totalTask;
                }

            }   
            
			for(AggregateResult result : [SELECT WhatId, Count(Id) countIds, Count(Status_1__c) countOpenEvent
                                          FROM Event 
                                          WHERE WhatId IN :countTotalEventMap.keySet() Group By WhatId])
            {
                Id accountId = (Id)result.get('WhatId');
                Integer totalEvent = (Integer)result.get('countIds');
                Integer totalTaskAndEvent = totalEvent + totalTask;
                
                countTotalEventMap.put(accountId, 
                                      new Account(Id = accountId, Total_Activities__c = totalTaskAndEvent));
            } 
            update countTotalEventMap.values();

        }
            
        }
        
    }