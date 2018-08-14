({
  onInit: function (component, event, helper) {
    helper.handleApexAction(component, 'receiveOrgData', response => {
      const returnValue = response.getReturnValue();
      if (returnValue.status === 'success') {
        const result = JSON.parse(returnValue.message);
        const orgUrl = `${result.urlValue.split('.')[0]}.lightning.force.com`;
        const orgNamespace = result.namespaceValue;

        const currentUrl = window.location.href;
        if (currentUrl.includes('DaDaDocs_success')) {
          component.set(
            'v.dddSuccessMessage',
            '&DaDaDocs_success=action_complete'
          );
        } else if (currentUrl.includes('DaDaDocs_error')) {
          component.set(
            'v.dddSuccessMessage',
            '&DaDaDocs_error=error'
          );
        }

        component.set('v.orgUrl', orgUrl);
        component.set('v.orgNamespace', orgNamespace);
        component.set('v.isOrgDataSet', true);
      } else {
        console.error(returnValue.message);
      }

    });

    document.body.onclick = () => {
      const origin = component.get('v.origin');
      if (origin) {
        const iframe = component.find('iframe').getElement().contentWindow;
        iframe.postMessage({type: 'hideModals'}, origin);
      }
    };

    const onMessage = e => {
      const eventType = e.data.type;
      const action = e.data.action;
      const params = e.data.params;
      const origin = e.origin;

      if (eventType === 'requestToApex') {
        component.set('v.origin', origin);
        helper.handleApexAction(component, action, response => {
          const iframe = component.find('iframe').getElement().contentWindow;
          iframe.postMessage({
              type: 'response',
              requestId: e.data.requestId,
              responseStatus: response.getState(),
              responseValue: response.getReturnValue()
            },
            component.get('v.origin')
          );
        }, params);
      }

      if (eventType === 'requestToLightning') {
        component.set('v.origin', origin);
        helper[action](component, params);
      }
    };

    window.removeEventListener('message', onMessage);
    window.addEventListener('message', onMessage, false);
  },

  onEvtRefreshClick: function (component, event, helper) {
    if (event.getParam('dropdownName') === 'edDocument') {
      const origin = component.get('v.origin');
      if (origin) {
        const iframe = component.find('iframe').getElement().contentWindow;
        iframe.postMessage({type: 'fetchDocuments'}, origin);
      }
    }
  },

  closeIframeOverlay: function (component, event, helper) {
    component.set('v.isOverlayOpened', false);
    component.set('v.overlayIframeSrc', '');
    component.set('v.overlayTitle', '');
    component.set('v.overlayIframeStyle', '');
    component.set('v.overlayWindowStyle', '');
  },

  handleUploadFinished: function (component, event, helper) {
    const iframe = component.find('iframe').getElement().contentWindow;
    iframe.postMessage({type: 'uploadFinished', files: JSON.stringify(event.getParam("files"))}, component.get('v.origin'));
  }
});