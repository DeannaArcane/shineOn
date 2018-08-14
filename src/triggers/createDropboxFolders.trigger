trigger createDropboxFolders on Opportunity (after insert, after update, after delete) {
    if(TriggerHandler__c.getValues('createDropboxFolders') <> null && TriggerHandler__c.getValues('createDropboxFolders').IsActive__c && TriggerHandler__c.getValues('createDropboxFolders').isAfter__c){
        if(Trigger.isInsert && TriggerHandler__c.getValues('createDropboxFolders').isInsert__c){
            set<string> oppState = new set<string>();
            for(Opportunity op : Trigger.New){
                oppState.add(op.BillingState__c); 
            }
            List<Opportunity> oppRecords = [select id, Name, Account.BillingState, BillingState__c, Job_Num__c, Job__c from Opportunity where BillingState__c In: oppState Order By CreatedDate desc, Job__c desc];
            system.debug('Hello Kumar *****'+oppRecords);
            Map<string,Integer> oppStateMap = new Map<string,Integer>();
            for(Opportunity op : oppRecords){                     
               if(!oppStateMap.containsKey(op.BillingState__c) && op.Job_Num__c != null){
                     if(op.Job_Num__c.contains(op.BillingState__c)){
                         String[] st = op.Job_Num__c.split('-'); 
                         oppStateMap.put(op.BillingState__c, Integer.valueOf(st[1])); 
                     }
               }
            }
            system.debug('Hello Kumar Map Values'+oppStateMap);
            List<Opportunity> oppToInsert = new List<Opportunity>();
            for(Opportunity op : Trigger.New){
               if(oppStateMap.containsKey(op.BillingState__c)){
                  system.debug('Hello Kumar Map*****'+oppRecords);
                  Integer count = oppStateMap.get(op.BillingState__c)+1;
                  oppStateMap.remove(op.BillingState__c);
                  oppStateMap.put(op.BillingState__c, count);
               }
               else{
                  oppStateMap.put(op.BillingState__c, 11000);
               }
               system.debug('Hello Kumar ***** Job Number:::'+op.BillingState__c+'-'+(oppStateMap.get(op.BillingState__c)));
               oppToInsert.add(new Opportunity(Id = op.Id, Job_Num__c = op.BillingState__c+'-'+(oppStateMap.get(op.BillingState__c)))); 
               DropboxController.AccessToken(op.Id, op.BillingState__c+'-'+(oppStateMap.get(op.BillingState__c)), op.BillingState__c);
            } 
            set<String> oppJobNum = new set<String>();
            for(Opportunity op: oppToInsert){
            	oppJobNum.add(op.Job_Num__c);
            }
            /*Map<Id, Opportunity> opptyRecords = new Map<Id, Opportunity>([select id, Job_Num__c from Opportunity where Job_Num__c In: oppJobNum]);
            
        	Integer cnt = 0;
        	for(Opportunity op : Trigger.New){
        		cnt++;
        		if(opptyRecords.containsKey(op.Id)) {
        		   op.AddError('Duplicate Job number');
        		   oppToInsert.remove(cnt);
        		}  
        	}*/
            update oppToInsert;
        }
        if(Trigger.isDelete && TriggerHandler__c.getValues('createDropboxFolders').isDelete__c){ 
            for(Opportunity op : Trigger.Old){
               if(op.Job_Num__c != null)DropboxController.deleteDropBoxFolder(op.Id, op.BillingState__c, op.Job_Num__c); 
            }
        } 
        if(Trigger.isUpdate && TriggerHandler__c.getValues('createDropboxFolders').isUpdate__c){ 
            for(Opportunity op : Trigger.New){                
                 DropboxController.AccessToken((string)op.Id, op.Job_Num__c, op.BillingState__c);
            }  
        }
    } 
}