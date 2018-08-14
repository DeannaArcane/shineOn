({
    onInit: function (component, event, helper) {
        const currentUrl = window.location.href;
        if (currentUrl.includes('DaDaDocs_success')) {
          helper.showAlert(component, {
            alertIcon: 'success',
            alertText: 'Action complete'
          });
        } else if (currentUrl.includes('DaDaDocs_error')) {
          helper.showAlert(component, {
            alertIcon: 'fail',
            alertText: 'Something went wrong'
          });
        }

        helper.asyncHandler(component, 'c.getDaDaDocsOptions', options => {
            component.set('v.daDaDocsOptions', options);
            const getNamespaceUnderscoredAction = component.get('c.getNamespaceUnderscored');
            getNamespaceUnderscoredAction.setCallback(this, response => {
                const status = response.getState();
                if (status === 'SUCCESS') {
                    const namespaceUnderscored = response.getReturnValue();
                    const isPermitted = options[`${namespaceUnderscored}PDFfillerFiles__c`];
                    component.set('v.isPermitted', isPermitted);
                    if (isPermitted) {
                        // component is permitted
                        component.set('v.namespaceUnderscored', namespaceUnderscored);

                        helper.asyncHandler(component, 'c.checkIfLoggedIn', isLoggedIn => {
                            component.set('v.isLoggedIn', isLoggedIn);
                            component.set('v.isAuthAndPermissionsChecked', true);

                            if (isLoggedIn) {
                                component.set('v.isPermittedAndLoggedIn', true);
                                helper.getPDFfillerTemplates(component);
                                helper.asyncHandler(
                                    component,
                                    'c.getDaDaDocsUrl',
                                    daDaDocsUrl => component.set('v.daDaDocsUrl', `${daDaDocsUrl}#tab=pdffiller`)
                                );
                                const featuresOptions = component.get('v.PDFfillerTemplateDocumentActionOptions');
                                const isS2SEnabled = options[`${namespaceUnderscored}Send2SignFeature__c`];
                                const isL2FEnabled = options[`${namespaceUnderscored}Link2FillFeature__c`];
                                if (isL2FEnabled) featuresOptions.splice(1, 0, 'LinkToFill');
                                if (isS2SEnabled) featuresOptions.splice(1, 0, 'SendToSign');
                                if (isS2SEnabled || isL2FEnabled) component.set('v.PDFfillerTemplateDocumentActionOptions', featuresOptions);
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
        if (event.getParam('dropdownName') === 'PDFfillerTemplate') {
            helper.getPDFfillerTemplates(component);
        }
    },

    onEvtPromptSubmit: function (component, event, helper) {
        component.set('v.promptValue', event.getParam('promptValue'));
        $A.get('e.pdffiller_sf:evtPromptValueChanged').fire({firedFrom: event.getParam('firedFrom')});
        component.set('v.isLoading', true);
    },

    onEvtPromptValueChanged: function (component, event, helper) {
        if (event.getParam('firedFrom') === 'importToDocuments') {
            const importPDFfillerFileToDocumentsAction = component.get('c.importPDFfillerFileToDocuments');
            importPDFfillerFileToDocumentsAction.setParams({
                documentId: component.get('v.PDFfillerTemplateValue'),
                documentName: component.get('v.promptValue'),
                parentId: component.get('v.recordId')
            });
            importPDFfillerFileToDocumentsAction.setCallback(this, response => {
                component.set('v.isLoading', false);
                helper.showAlert(component, {
                    alertIcon: 'success',
                    alertText: 'Complete'
                });
                $A.get('e.pdffiller_sf:evtRefreshClick').fire({
                    tabName: 'edit-document',
                    dropdownName: 'edDocument'
                });
            });
            $A.enqueueAction(importPDFfillerFileToDocumentsAction);
        }
    },

    onEvtSubmitButtonClick: function (component, event, helper) {
        component.set('v.isLoading', true);
        const parentId = component.get('v.recordId');
        const objectId = component.get('v.PDFfillerTemplateValue');
        if (!objectId) {
            helper.showAlert(component, {alertIcon: 'fail', alertText: 'Please select a document.'});
            component.set('v.isLoading', false);
            return;
        }
        const pdfAction = helper.getActionString(component.get('v.PDFfillerTemplateDocumentActionValue'));
        switch (pdfAction) {
            case 'fill': // edit
            case 'send2sign':
            case 'link2fill':
                const query = [
                    `pdfAction=${pdfAction}`,
                    `objectId=${objectId}`,
                    'objectType=pdffiller',
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
                component.set('v.promptValue', '');
                component.set('v.promptHeading', '');
                component.set('v.promptText', '');
                component.set('v.promptFiredFrom', '');
                component.set('v.isPromptShown', false);
                component.set('v.isAlertShown', false);
                component.set('v.PDFfillerTemplateValue', '');
                component.set('v.PDFfillerTemplateDocumentActionValue', 'Edit');
                break;
            case 'importToDocuments':
                const templates = component.get('v.PDFfillerTemplates');
                let selectedTemplateName = '';
                for (const templateKey in templates) {
                    if (templates.hasOwnProperty(templateKey)) {
                        const template = templates[templateKey];
                        if (template.id == component.get('v.PDFfillerTemplateValue')) {
                            selectedTemplateName = template.name;
                            break;
                        }
                    }
                }

                component.set('v.promptHeading', 'Clone Document');
                component.set('v.promptText', 'Save document as:');
                component.set('v.promptFiredFrom', 'importToDocuments');
                component.set('v.promptValue', selectedTemplateName);
                component.set('v.isPromptShown', true);
                break;
            default:
                break;
        }
        component.set('v.isLoading', false);
    }
});