({
    getDocXTemplates: function (component) {
        component.set('v.isLoading', true);
        this.asyncHandler(component, 'c.getDocXTemplates', templates => {
            component.set('v.DocXTemplates', templates);
            component.set('v.DocXTemplateValue', '');
            component.set('v.isLoading', false);
            $A.get('e.pdffiller_sf:evtDocItemsUpdate').fire({dropdownName: 'DocXTemplate'});
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
                callback(isJSON ? JSON.parse(response.getReturnValue()) : response.getReturnValue());
            } else if (status === 'ERROR') {
                if (ignoreErrors) {
                    callback(false);
                }
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
        return {
            'Edit': 'fill',
            'SendToSign': 'send2sign',
            'LinkToFill': 'link2fill'
        }[title];
    },

    getObjectTypeFromDeliveryOption: function (title) {
        return {
            'Save To Attachments': 'attachment',
            'Save To Files': 'chatter'
        }[title]
    },

    uploadDocument: function (component, objectId, pdfAction) {
        if (!objectId) {
            this.showAlert(component, {alertIcon: 'fail', alertText: 'Please select a template.'});
            component.set('v.isLoading', false);
            return;
        }
        const parentId = component.get('v.recordId');
        const uploadDocumentAction = component.get('c.uploadDocument');
        uploadDocumentAction.setParams({parentId, objectId});
        uploadDocumentAction.setCallback(this, response => {
            const status = response.getState();
            if (status === 'SUCCESS') {
                if (response.getReturnValue()['status'] === 'success') {
                    const query = [
                        `pdfAction=${pdfAction}`,
                        `objectId=${objectId}`,
                        `parentId=${parentId}`
                    ];

                    $A.get('e.force:navigateToURL').fire({
                        url: `/apex/${component.get('v.namespaceUnderscored')}LightningFillDocument?${query.join('&')}`
                    });

                    // component.set('v.iframeOverlaySrc', `/apex/${component.get('v.namespaceUnderscored')}LightningFillDocument?${query.join('&')}`);
                    // component.set('v.isIframeOverlayShown', true);

                    // reset
                    component.set('v.alertIcon', 'none');
                    component.set('v.alertHeading', '');
                    component.set('v.alertText', '');
                    component.set('v.isAlertShown', false);
                    component.set('v.DocXTemplateValue', '');
                    component.set('v.DocXTemplateDeliveryOptionValue', 'Save To Attachments');
                    component.set('v.DocXTemplateDocumentActionValue', 'Edit');
                } else {
                    // TODO: error handler
                }
            } else if (status === 'ERROR') {
                // TODO: error handler
                console.error(response.getError());
            } else {
                // TODO: error handler
                console.log('Unknown issue.');
                console.log(`Status: ${status}`);
                console.log('Response', response);
            }
            component.set('v.isLoading', false);
        });
        $A.enqueueAction(uploadDocumentAction);
    },
});