trigger opportunityTrigger on opportunity (before insert, before update) {
        //after insert, after update, before delete, after delete, after undelete
	
	if(core.CoreSettingActive('opportunityTrigger') && 
		OpportunityUtility.TriggerIsRunning!=true){

		OpportunityUtility.TriggerIsRunning = true;
		
		system.debug('***OpportunityTrigger begin');
		
		//--- INSERT ---
		if(trigger.isInsert){
			
			if(trigger.isBefore){
				// EXECUTE BEFORE INSERT LOGIC
				//	Check AHJ_Inspection_Not_Required__c if needed
				OpportunityUtility.evaluateInspectionRequrement(trigger.new);

			}//else if(trigger.isAfter){
				// EXECUTE AFTER INSERT LOGIC

			//}

		//--- UPDATE ---
		}else if(trigger.isUpdate){

			if(trigger.isBefore){
				// EXECUTE BEFORE UPDATE LOGIC
				//	Check AHJ_Inspection_Not_Required__c if needed
				OpportunityUtility.evaluateInspectionRequrement(trigger.new);

			}//else if(trigger.isAfter){
				// EXECUTE AFTER UPDATE LOGIC
				
			//}

		//--- DELETE ---
		}//else if(trigger.isDelete){

			//if(trigger.isBefore){
				// EXECUTE BEFORE DELETE LOGIC

			//}else if(trigger.isAfter){
				// EXECUTE AFTER DELETE LOGIC

			//}

		//--- UNDELETE ---
		//}else if(trigger.isUnDelete){
			// EXECUTE AFTER UNDELETE LOGIC

		//}
		
		OpportunityUtility.TriggerIsRunning = false;
	}

}