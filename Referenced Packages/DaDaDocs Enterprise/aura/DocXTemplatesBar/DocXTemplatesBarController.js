({
    onInit: function (component, event, helper) {
        const queryParams = helper.getUrlParameters();
        if (queryParams['DaDaDocs_error']) {
            helper.showAlert(component, {
                alertIcon: 'fail',
                alertText: decodeURIComponent(queryParams['DaDaDocs_error'])
            });
        } else if (queryParams['DaDaDocs_success']) {
            helper.showAlert(component, {
                alertIcon: 'success',
                alertText: decodeURIComponent(queryParams['DaDaDocs_success'])
            });
        }
        helper.asyncHandler(component, 'c.getDaDaDocsOptions', options => {
            component.set('v.daDaDocsOptions', options);
            const getNamespaceUnderscoredAction = component.get('c.getNamespaceUnderscored');
            getNamespaceUnderscoredAction.setCallback(this, response => {
                const status = response.getState();
                if (status === 'SUCCESS') {
                    const namespaceUnderscored = response.getReturnValue();
                    component.set('v.namespaceUnderscored', namespaceUnderscored);
                    const isPermitted = options[`${namespaceUnderscored}DocxTemplatesFeature__c`];
                    component.set('v.isPermitted', isPermitted);

                    if (isPermitted) {

                        helper.asyncHandler(component, 'c.checkIfLoggedIn', isLoggedIn => {
                            component.set('v.isLoggedIn', isLoggedIn);
                            component.set('v.isAuthAndPermissionsChecked', true);

                            if (isLoggedIn) {
                                component.set('v.isPermittedAndLoggedIn', true);

                                helper.getDocXTemplates(component);
                                helper.asyncHandler(
                                    component,
                                    'c.getDaDaDocsUrl',
                                    daDaDocsUrl => component.set('v.daDaDocsUrl', `${daDaDocsUrl}#tab=fileTemplates`)
                                );

                                const featuresOptions = component.get('v.DocXTemplateDocumentActionOptions');
                                const isS2SEnabled = options[`${namespaceUnderscored}Send2SignFeature__c`];
                                const isL2FEnabled = options[`${namespaceUnderscored}Link2FillFeature__c`];

                                if (isS2SEnabled) featuresOptions.push('SendToSign');
                                if (isL2FEnabled) featuresOptions.push('LinkToFill');
                                if (isS2SEnabled || isL2FEnabled) component.set('v.DocXTemplateDocumentActionOptions', featuresOptions);
                            }
                        }, false, true);
                        // window.addEventListener('message', event => {
                        //   console.log('postMessage', event);
                        //   if (event.data === 'doneIsClicked') {
                        //     setTimeout(() => {
                        //       component.set('v.iframeOverlaySrc', '');
                        //       component.set('v.isIframeOverlayShown', false);
                        //     }, 1000);
                        //   }
                        // }, false);
                    } else {
                        component.set('v.isAuthAndPermissionsChecked', true);
                    }
                } else if (status === 'ERROR') {
                    helper.showAlert(component, {
                        alertIcon: 'fail',
                        alertText: response.getError()
                    });
                } else {
                    console.log(`Status: ${status}`);
                    console.log('Response', response);
                    helper.showAlert(component, {
                        alertIcon: 'fail',
                        alertHeading: 'Unknown problem',
                        alertText: 'Please try again later'
                    });
                }
            });
            $A.enqueueAction(getNamespaceUnderscoredAction);
        }, true);
    },

    onEvtRadioButtonChange: function (component, event, helper) {
        component.set(`v.${event.getParam('dropdownName')}Value`, event.getParam('value'));
        $A.get('e.pdffiller_sf:evtDropdownIsClosed').fire({
            tabName: event.getParam('tabName'),
            dropdownIndex: event.getParam('dropdownIndex')
        });
    },

    onEvtRefreshClick: function (component, event, helper) {
        if (event.getParam('dropdownName') === 'DocXTemplate') {
            helper.getDocXTemplates(component);
        }
    },

    onEvtSubmitButtonClick: function (component, event, helper) {
        component.set('v.isLoading', true);
        const parentId = component.get('v.recordId');
        const templateId = component.get('v.DocXTemplateValue');
        if (!templateId) {
            helper.showAlert(component, {alertIcon: 'fail', alertText: 'Please select a template.'});
            component.set('v.isLoading', false);
            return;
        }
        const objectType = helper.getObjectTypeFromDeliveryOption(component.get('v.DocXTemplateDeliveryOptionValue'));
        const pdfAction = helper.getActionString(component.get('v.DocXTemplateDocumentActionValue'));

        const useDocXTemplateAction = component.get('c.useDocXTemplate');
        useDocXTemplateAction.setParams({parentId, templateId, pdfAction, objectType});

        useDocXTemplateAction.setCallback(this, response => {
            const status = response.getState();
            if (status === 'SUCCESS') {
                const responseValue = response.getReturnValue();
                if (responseValue.status === 'success') {
                    helper.uploadDocument(component, responseValue.message, pdfAction);
                } else {
                    console.log(`Status: ${responseValue.status}`);
                    console.log(responseValue);
                    helper.showAlert(component, {
                        alertIcon: 'fail',
                        alertHeading: 'Unknown problem',
                        alertText: 'Please try again later'
                    });
                }
            } else if (status === 'ERROR') {
                helper.showAlert(component, {
                    alertIcon: 'fail',
                    alertText: response.getError()
                });
            } else {
                console.log(`Status: ${status}`);
                console.log('Response', response);
                helper.showAlert(component, {
                    alertIcon: 'fail',
                    alertHeading: 'Unknown problem',
                    alertText: 'Please try again later'
                });
            }
            component.set('v.isLoading', false);
        });
        $A.enqueueAction(useDocXTemplateAction);
    }
});