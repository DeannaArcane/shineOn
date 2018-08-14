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
          const isTemplatesPermitted = options[`${namespaceUnderscored}TemplatesFeature__c`];
          component.set('v.namespaceUnderscored', namespaceUnderscored);
          component.set('v.isTemplatesPermitted', isTemplatesPermitted);

          helper.asyncHandler(component, 'c.checkIfLoggedIn', isLoggedIn => {
            component.set('v.isLoggedIn', isLoggedIn);
            component.set('v.isAuthChecked', true);
            component.set('v.isAuthAndPermissionsChecked', true);

            if (isLoggedIn) {
              if (isTemplatesPermitted) component.set('v.isTemplatesPermittedAndLoggedIn', true);
              helper.getDocuments(component, () => component.set(`v.edit-document-tab-inited`, true));
              helper.asyncHandler(
                component,
                'c.getDaDaDocsUrl',
                daDaDocsUrl => component.set('v.daDaDocsUrl', `${daDaDocsUrl}#tab=edit`)
              );

              const featuresOptions = component.get('v.documentActionOptions');
              const isS2SEnabled = options[`${namespaceUnderscored}Send2SignFeature__c`];
              const isL2FEnabled = options[`${namespaceUnderscored}Link2FillFeature__c`];
              if (isS2SEnabled) featuresOptions.push('SendToSign');
              if (isL2FEnabled) featuresOptions.push('LinkToFill');

              if (isS2SEnabled || isL2FEnabled) component.set('v.documentActionOptions', featuresOptions);
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

  onEvtRefreshClick: function (component, event, helper) {
    switch (event.getParam('dropdownName')) {
      case 'edDocument':
        helper.getDocuments(component);
        break;
      case 'utTemplate':
        helper.getTemplates(component);
        break;
    }
  },

  onEvtTabClick: function (component, event, helper) {
    const clickedTab = event.getParam('clickedTab');
    component.set('v.activeTab', event.getParam('clickedTab'));
    const isInited = component.get(`v.${clickedTab}-tab-inited`);
    if (!isInited) {
      switch (clickedTab) {
        case 'edit-document':
          if (
            component.get('v.isAuthChecked') &&
            component.get('v.isLoggedIn')
          ) {
            helper.getDocuments(component, () => component.set(`v.${clickedTab}-tab-inited`, true));
          }
          break;
        case 'use-template':
          if (
            component.get('v.isAuthAndPermissionsChecked') &&
            component.get('v.isTemplatesPermitted') &&
            component.get('v.isLoggedIn')
          ) {
            helper.getTemplates(component, () => component.set(`v.${clickedTab}-tab-inited`, true));
          }
          break;
      }
    }
  },

  onEvtRadioButtonChange: function (component, event, helper) {
    component.set(`v.${event.getParam('dropdownName')}Value`, event.getParam('value'));
    $A.get('e.pdffiller_sf:evtDropdownIsClosed').fire({
      tabName: event.getParam('tabName'),
      dropdownIndex: event.getParam('dropdownIndex')
    });
  },

  onEvtSubmitButtonClick: function (component, event, helper) {
    component.set('v.isLoading', true);
    let documentActionValue;

    switch (component.get('v.activeTab')) {
      case 'edit-document':
        const objectId = component.get('v.edDocumentValue');
        documentActionValue = helper.getActionString(component.get('v.edDocumentActionValue'));
        helper.uploadDocument(component, objectId, documentActionValue);

        break;
      case 'use-template':
        const parentId = component.get('v.recordId');
        const templateId = component.get('v.utTemplateValue');
        const deliveryOptionValue = helper.getActionString(component.get('v.utDeliveryOptionValue'));
        documentActionValue = helper.getActionString(component.get('v.utDocumentActionValue'));

        if (!templateId) {
          helper.showAlert(component, {alertIcon: 'fail', alertText: 'Please select a template.'});
          component.set('v.isLoading', false);
          return;
        }

        const useTemplateAction = component.get('c.useTemplate');
        useTemplateAction.setParams({parentId, templateId, pdfAction: deliveryOptionValue});
        useTemplateAction.setCallback(this, response => {
          const status = response.getState();
          if (status === 'SUCCESS') {
            const responseValue = response.getReturnValue();
            if (responseValue.status === 'success') {
              helper.uploadDocument(component, responseValue.message, documentActionValue);
            } else {
              helper.showAlert(component, {
                alertIcon: 'fail',
                alertHeading: responseValue.message ? '' : 'Unknown problem',
                alertText: responseValue.message ? responseValue.message : 'Please try again later'
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
        $A.enqueueAction(useTemplateAction);
        break;
    }
  }
});