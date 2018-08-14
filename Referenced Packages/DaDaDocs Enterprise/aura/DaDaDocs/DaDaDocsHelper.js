({
  handleApexAction: function (component, actionName, callback, params) {
    const action = component.get(`c.${actionName}`);
    for (const parameterName in params) {
      action.setParam(parameterName, params[parameterName]);
    }
    action.setCallback(this, callback);
    $A.getCallback(function() {
      $A.enqueueAction(action);
    })();
  },

  iframeLoaded: function(component) {
    component.set('v.isIframeLoaded', true);
  },

  openPreview: function (component, params) {
    const documentId = params.documentId;
    if (params.documentType === 'chatter') {
      $A.get('e.lightning:openFiles').fire({
        recordIds: [documentId]
      });
    } else {
      window.open(`/servlet/servlet.FileDownload?file=${documentId}`, '_blank');
    }
  },

  capitalizeFirstLetter: function (string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  },

  toggleUploadsVisibility: function (component, params) {
    params.uploads.forEach(element => {
      component.set('v.is' + this.capitalizeFirstLetter(element.name) + 'UploadVisible', element.isVisible);
    });
  },

  openUrlInIframe: function (component, params) {
    component.set('v.isOverlayOpened', true);
    component.set('v.overlayIframeSrc', params.url);
    component.set('v.overlayTitle', params.title);
    component.set('v.overlayIframeStyle', params.iframeStyle);
    component.set('v.overlayWindowStyle', params.windowStyle);
  },

  openUrl: function (component, params) {
    $A.get('e.force:navigateToURL').fire({url: params.url})
  },

  getUrlParam: function (prop) {
    const params = {};
    const search = decodeURIComponent(window.location.search.replace('?', ''));
    const definitions = search.split('&');

    definitions.forEach((val) => {
      const parts = val.split('=', 2);
      params[parts[0]] = parts[1];
    });

    return (prop && prop in params) ? params[prop] : null;
  }
});