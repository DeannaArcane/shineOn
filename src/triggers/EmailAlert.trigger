trigger EmailAlert on Opportunity (after insert, after update) {
 /*
 if(Utility.isFutureUpdate != true)
 {
    Opportunity[] Opps = trigger.new;
    EmailStageAlerts.EmailAlert(Opps);
 }*/
	if (TriggerHandler__c.getValues('EmailAlert') != null && TriggerHandler__c.getValues('EmailAlert').isActive__c)
		if (Trigger.isInsert && Utility.isFutureUpdate != true) {
	        Opportunity[] Opps = trigger.new;
	        EmailStageAlerts.EmailAlert(Opps);
		} else if (Trigger.isUpdate && Utility.isFutureUpdate != true) {
	        Opportunity[] Opps = trigger.new;
	        MAP<Id,Opportunity> oldOpps = New Map<Id, Opportunity>(trigger.old);
	        EmailStageAlerts.EmailAlertForUpdate(Opps,oldOpps);
		}
}