({
	updateLeadInsightsData: function(component, helper, sObjectName, recordId) {
        var leadAction = component.get("c.updateLeadInsights");
        leadAction.setParams({
            "sObjectName" : sObjectName,
            "recordId" : recordId
        });
        leadAction.setCallback(this, function(response) {
            var state = response.getState();
            var spinner = component.find("spinner");
            var responseMap;

            if(component.isValid() && state === "SUCCESS") {                    
                $A.util.addClass(spinner, "slds-hide");

                responseMap = response.getReturnValue();


                component.set("v.ageText", responseMap.AGE);
                component.set("v.qualityIndex", parseInt(responseMap.QUALITY));
                component.set("v.touchText", responseMap.TOUCH);
            }
        });
        $A.enqueueAction(leadAction);    
    }
})