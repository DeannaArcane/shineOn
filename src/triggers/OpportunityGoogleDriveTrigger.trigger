trigger OpportunityGoogleDriveTrigger on Opportunity (after insert) {
    // Delegate to an Apex class
    OpportunityGoogleDriveTriggerHandler handler = new OpportunityGoogleDriveTriggerHandler();
    handler.execute(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
}