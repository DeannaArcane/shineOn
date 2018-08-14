({
	updateAccountInsightsData: function(component, helper, sObjectName, recordId) {
        var accAction = component.get("c.updateAccountInsights");
        accAction.setParams({
            "sObjectName" : sObjectName,
            "recordId" : recordId
        });
        accAction.setCallback(this, function(response) {
            var state = response.getState();
            var spinner = component.find("spinner");
            var responseMap;

            if(component.isValid() && state === "SUCCESS") {                    
                $A.util.addClass(spinner, "slds-hide");

                responseMap = response.getReturnValue();


                component.set("v.ageText", responseMap.AGE);

                component.set("v.openCount", responseMap.OPEN_COUNT);
                component.set("v.openAmount", responseMap.OPEN_AMOUNT);

                component.set("v.wonCount", responseMap.WON_COUNT);
                component.set("v.wonAmount", responseMap.WON_AMOUNT);

                component.set("v.lostCount", responseMap.LOST_COUNT);
                component.set("v.lostAmount", responseMap.LOST_AMOUNT);
            }
        });
        $A.enqueueAction(accAction);    
    }
})