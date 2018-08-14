({
  getDocuments: function (component, callback) {
    component.set('v.isLoading', true);
    this.asyncHandler(component, 'c.getDocumentsAndProjects', documents => {
      component.set('v.documents', documents);
      component.set('v.edDocumentValue', '');
      component.set('v.isLoading', false);
      $A.get('e.pdffiller_sf:evtDocItemsUpdate').fire({dropdownName: 'edDocument'});
      if (callback) callback();
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

  getTemplates: function (component, callback) {
    component.set('v.isLoading', true);
    this.asyncHandler(component, 'c.getTemplates', templates => {
      let index = 0;
      for (const item of templates) {
        item['lastModifiedDate'] = item.updatedDate;
        index++;
      }
      component.set('v.templates', templates);
      component.set('v.utTemplateValue', '');
      component.set('v.isLoading', false);
      $A.get('e.pdffiller_sf:evtDocItemsUpdate').fire({dropdownName: 'utTemplate'});
      if (callback) callback();
    }, true);
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

  uploadDocument: function (component, objectId, documentActionValue) {
    if (!objectId) {
      this.showAlert(component, {alertIcon: 'fail', alertText: 'Please select a document.'});
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
            `pdfAction=${documentActionValue}`,
            `objectId=${objectId}`,
            `parentId=${parentId}`
          ];

          if (component.get('v.activeTab') === 'edit-document' && documentActionValue === 'fill') {
              query[0] = 'pdfAction=editDocument';
          }

          $A.get('e.force:navigateToURL').fire({
            url: `/apex/${component.get('v.namespaceUnderscored')}LightningFillDocument?${query.join('&')}`
          });

          // reset
          component.set('v.alertIcon', 'none');
          component.set('v.alertHeading', '');
          component.set('v.alertText', '');
          component.set('v.isAlertShown', false);
          component.set('v.activeTab', 'edit-document');
          component.set('v.edit-document-tab-inited', false);
          component.set('v.edDocumentValue', '');
          component.set('v.edDocumentActionValue', 'Edit');
          component.set('v.use-template-tab-inited', false);
          component.set('v.utTemplateValue', '');
          component.set('v.utDeliveryOptionValue', 'Save To Attachments');
          component.set('v.utDocumentActionValue', 'Edit');

          // component.set('v.iframeOverlaySrc', `/apex/${component.get('v.namespaceUnderscored')}LightningFillDocument?${query.join('&')}`);
          // component.set('v.isIframeOverlayShown', true);
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

  getActionString: function (title) {
    const map = {
      'Edit': 'fill',
      'SendToSign': 'send2sign',
      'LinkToFill': 'link2fill',
      'Save To Attachments': 'saveTemplateToAttachments',
      'Save To Files': 'saveTemplateToFiles'
    };

    return map[title];
  }
});