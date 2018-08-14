({
	updateOpportunityInsightsData: function(component, helper, sObjectName, recordId) {
        var oppAction = component.get("c.updateOpportunityInsights");
        oppAction.setParams({
            "sObjectName" : sObjectName,
            "recordId" : recordId
        });
        oppAction.setCallback(this, function(response) {
            var state = response.getState();
            var spinner = component.find("spinner");
            var responseMap;

            if(component.isValid() && state === "SUCCESS") {                    
                $A.util.addClass(spinner, "slds-hide");

                responseMap = response.getReturnValue();

                if(responseMap.CLOSE_COUNT < 0) {
                    component.set("v.isDue", true);
                    responseMap.CLOSE_COUNT = Math.abs(responseMap.CLOSE_COUNT);
                } else {
                    component.set("v.isDue", false);
                }

                component.set("v.fiscalText", responseMap.FISCAL);
                component.set("v.age", responseMap.AGE);
                component.set("v.closeDateCount", responseMap.CLOSE_COUNT);
                component.set("v.percentText", responseMap.PERCENT);
                component.set("v.pushCount", responseMap.PUSH_COUNT);
            }
        });
        $A.enqueueAction(oppAction);    
    }
})