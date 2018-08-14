({
	fetchAccountInsights: function(component, event, helper) {
        var sObjectName = component.get("v.sObjectName");
        var recordId = component.get("v.recordId");     
        var spinner = component.find("spinner");
        
        $A.util.removeClass(spinner, "slds-hide");	

        helper.updateAccountInsightsData(component, helper, sObjectName, recordId);
	}
})