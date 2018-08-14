({
    getPDFfillerTemplates: function (component) {
        component.set('v.isLoading', true);
        this.asyncHandler(component, 'c.getPDFfillerFiles', templates => {
            component.set('v.PDFfillerTemplates', templates);
            component.set('v.PDFfillerTemplateValue', '');
            component.set('v.isLoading', false);
            $A.get('e.pdffiller_sf:evtDocItemsUpdate').fire({dropdownName: 'PDFfillerTemplate'});
        }, true);
    },

    getUrlParameters: function () {
        const hash = window.location.hash;
        return hash.substring(hash.indexOf('?') + 1).split('&').map(function (n) {
            return n = n.split('='), this[n[0]] = n[1], this
        }.bind({}))[0];
    },

    showAlert: function (component, params) {
        if (params['alertIcon']) component.set('v.alertIcon', params['alertIcon']);
        if (params['alertHeading']) component.set('v.alertHeading', params['alertHeading']);
        if (params['alertText']) component.set('v.alertText', params['alertText']);
        component.set('v.isAlertShown', true);
        setTimeout(() => {
            component.set('v.isAlertShown', false);
        }, 5000)
    },

    asyncHandler: function (component, methodName, callback, isJSON, ignoreErrors) {
        // if undefined - set false
        isJSON = !!isJSON;
        ignoreErrors = !!ignoreErrors;

        const action = component.get(methodName);
        action.setParam('parentId', component.get('v.recordId'));
        action.setCallback(this, response => {
            const status = response.getState();
            if (status === 'SUCCESS') {
                const returnValue = response.getReturnValue();
                const message = returnValue.message;
                if (returnValue.status === 'success') {
                  callback(isJSON ? JSON.parse(message) : message);
                } else {
                  if (ignoreErrors) callback(false);
                }
            } else if (status === 'ERROR') {
                if (ignoreErrors) callback(false);
                console.error(response.getError());
            } else {
                // TODO: error handler
                console.log('Unknown issue.');
                console.log(`Status: ${status}`);
                console.log('Response', response);
            }
        });
        $A.enqueueAction(action);
    },

    getActionString: function (title) {
        const map = {
            'Edit': 'fill',
            'SendToSign': 'send2sign',
            'LinkToFill': 'link2fill',
            'Import To Documents': 'importToDocuments',
        };

        return map[title];
    }
});