({
    doinit: function(component, event, helper) {
        var spinner = component.find("spinner");
        
        $A.util.removeClass(spinner, "slds-hide");
        helper.loadTime(component, helper);
    }
})