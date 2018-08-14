({
    fetchIndicesData: function(component, event, helper) {
        var spinner = component.find("spinner");

        $A.util.removeClass(spinner, "slds-hide");
        helper.updateUsIndicesData(component);
    }
})