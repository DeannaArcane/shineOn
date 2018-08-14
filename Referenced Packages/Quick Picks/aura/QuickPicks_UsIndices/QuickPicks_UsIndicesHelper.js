({
    updateUsIndicesData: function(component) {
        var updateUsIndicesAction = component.get("c.fetchUsIndicesData");

        updateUsIndicesAction.setCallback(this, function(response) {
            var state = response.getState();
            var details;
            var spinner;

            if(component.isValid() && state === "SUCCESS") {
                spinner = component.find("spinner");

                $A.util.addClass(spinner, "slds-hide");
                                
                details = response.getReturnValue();
        
                component.set("v.DJI_change", details.DJI_change);
                component.set("v.DJI_index", details.DJI_index);
                component.set("v.DJI_percent", '(' + details.DJI_percent + '%)');
                
                component.set("v.GSPC_change", details.GSPC_change);
                component.set("v.GSPC_index", details.GSPC_index);
                component.set("v.GSPC_percent", '(' + details.GSPC_percent + '%)');
                
                component.set("v.IXIC_change", details.IXIC_change);
                component.set("v.IXIC_index", details.IXIC_index);
                component.set("v.IXIC_percent", '(' + details.IXIC_percent + '%)');
            }
        });
        $A.enqueueAction(updateUsIndicesAction);
    }
})