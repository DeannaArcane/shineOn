({
    fetchWeatherData: function(component, event, helper) {   
        var searchText = component.get("v.searchText");
        var sObjectName = component.get("v.sObjectName");
        var recordId = component.get("v.recordId");     
        var spinner = component.find("spinner");

        $A.util.removeClass(spinner, "slds-hide");

        if(searchText != null || (sObjectName != null && recordId != null)) {
            helper.updateWeatherData(component, helper, searchText, sObjectName, recordId);
        } else {
            $A.util.addClass(spinner, "slds-hide");
        }
    },
    refreshWeatherData: function(component, event, helper) {
        var searchText = component.get("v.searchText");
        var sObjectName = component.get("v.sObjectName");
        var recordId = component.get("v.recordId");     
        var spinner = component.find("spinner");
        
        if(sObjectName === 'Contact' || sObjectName === 'Account' || sObjectName === 'Lead') {
            $A.util.removeClass(spinner, "slds-hide");

            if(searchText !== null || (sObjectName !== null && recordId !== null)) {
                helper.updateWeatherData(component, helper, searchText, sObjectName, recordId);
            } else {
                $A.util.addClass(spinner, "slds-hide");
            }
        }
    }
})