public without sharing class OpportunityUtility {

	// used by the trigger to prevent recursive trigger calls
    public static boolean TriggerIsRunning = false;

	//	Called by trigger to check if Jurisdiction is either:
	//	"Bexar County (TX)" or "Gilbert (AZ)"
	//	OR if No_Permit_Required__c is checked
	//	Either case, check (AHJ_Inspection_Not_Required__c) 
	public static void evaluateInspectionRequrement(LIST<Opportunity> newOpps){
		Set<String> noInspectionJurisdictions;
		noInspectionJurisdictions = new Set<String>{
			'Bexar County (TX)',
			'Gilbert (AZ)'
		};
		for(opportunity opp: newOpps){
			if (noInspectionJurisdictions.contains(opp.Jurisdiction__c)
				||
				opp.No_Permit_Required__c==true){
				opp.AHJ_Inspection_Not_Required__c=true;
			}
		}
	}
}