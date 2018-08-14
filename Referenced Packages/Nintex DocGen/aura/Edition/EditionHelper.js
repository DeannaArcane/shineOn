({
    setSettingsAndServices : function (component, orgSettings, services) {
        if (orgSettings && services) {
            component.set('v.isTrial', orgSettings.isTrial);
            component.set('v.isSandbox', orgSettings.isSandbox);
            component.set('v.hasContract', orgSettings.hasContract);
            component.set('v.connectedAppsEnabled', orgSettings.isConnectedAppsEnabled);

            this.clearServices(component);
            component.set('v.isStandard', services.isStandard);

            if (services.isStandard) {
                component.set('v.standardScheduledDdp', services.scheduledDdp);
            } else {
                component.set('v.businessScheduledDdp', services.scheduledDdp);
                component.set('v.workflowDdp', services.workflowApexDdp);
                component.set('v.componentLibrary', services.componentLibrary);
                component.set('v.massDdp', services.massDdp);
            }

            if (orgSettings.hasContract && !orgSettings.isSandbox) {
                this.disableAll(component);
            }

            var actionEvent = component.getEvent('actionEvent');
            actionEvent.setParams({
                action: 'doneLoading'
            });
            actionEvent.fire();
        }
    },
    clearServices : function(component) {
        component.set("v.standardScheduledDdp", false);
        component.set("v.businessScheduledDdp", false);
        component.set("v.workflowDdp", false);
        component.set("v.componentLibrary", false);
        component.set("v.massDdp", false);
    },
    parseQueryString : function(qstr) {
        var query = {};
        qstr = qstr[0] === '?' ? qstr.substr(1) : qstr
        var a = qstr.split('&');
        for (var i = 0; i < a.length; i++) {
            var b = a[i].split('=');
            query[decodeURIComponent(b[0])] = decodeURIComponent(b[1] || '');
        }
        return query;
    },
    disableAll : function(component) {
        component.set("v.disableAll", true);
        component.getEvent("disableSave").fire();
    },
    fireErrorEvent : function(component, message) {
        component.getEvent('showError').setParams({
            message: message
        }).fire();
    }
})