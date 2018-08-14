({
    onInit : function(component, event, helper) {
        var orgSettings = component.get('v.orgSettings');
        var services = component.get('v.services');
        helper.setSettingsAndServices(component, orgSettings, services);
    },
    load : function (component, event, helper) {
        var orgSettings = event.getParams().arguments.orgSettings;
        var services = event.getParams().arguments.services;
        helper.setSettingsAndServices(component, orgSettings, services);
    },
    save : function(component) {
        var isStandard = component.get('v.isStandard');
        var scheduledDdp = isStandard ? component.get("v.standardScheduledDdp") : component.get("v.businessScheduledDdp");
        var workflowDdp = component.get("v.workflowDdp");
        var componentLibrary = component.get("v.componentLibrary");
        var massDdp = component.get("v.massDdp");
        
        var action = component.get("c.saveServices");
        action.setParams({
            "isStandard" : isStandard,
            "scheduledDdp" : scheduledDdp,
            "workflowDdp" : workflowDdp,
            "componentLibrary" : componentLibrary,
            "massDdp" : massDdp,
            "domain": component.get("v.loopUrl")
        });
        action.setCallback(this, function(response) {
            var moveToNextStep = component.getEvent("moveToNextStep");
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    moveToNextStep.setParams({success: true}).fire();
                    component.getEvent('updateIsStandard').setParams({
                        isStandard: isStandard
                    }).fire();
                }
                else {
                    moveToNextStep.setParams({success: false}).fire();
                    component.getEvent('showError').setParams({
                        message: parsedResponse.errorMessage
                    }).fire();
                }
            } else {
                moveToNextStep.setParams({success: false}).fire();
                var error = response.getError();
                var message = 'There was a problem saving changes.';
                if (error && error[0] && error[0].message) {
					message = response.getError()[0].message;
                }
                component.getEvent('showError').setParams({
                    message: message
                }).fire();
            }
        });
        $A.enqueueAction(action);
    },
    toggleServiceLevel : function(component, event, helper) {
        var isStandard = component.get("v.isStandard");
        helper.clearServices(component);
        component.set("v.isStandard", !isStandard);
    },
    redirectPage : function(component, event) {
        var redirectEvent = component.getEvent("redirectPage");
        redirectEvent.setParams({
            'buttonName' : 'purchaseForm'
        });
        redirectEvent.fire();
    },
    handleActionEvent : function(component, event, helper) {
        var action = event.getParam('action');
        var params = event.getParam('params');

        switch (action) {
            case 'oAuthStatusUpdate':
            case 'oAuthInitDoneLoading':
                params = JSON.parse(params);
                component.set('v.isAuthorized', params.isAuthorized);

                var actionEvent = component.getEvent('actionEvent');
                actionEvent.setParams({
                    action: 'doneLoading'
                });
                actionEvent.fire();
                break;
            default:
                break;
        }
    },
    startOAuthFlow : function(component, event) {
        var authorizeLoopServices = component.find('authorizeLoopServices');
        authorizeLoopServices.startOAuthFlow();
    }
})