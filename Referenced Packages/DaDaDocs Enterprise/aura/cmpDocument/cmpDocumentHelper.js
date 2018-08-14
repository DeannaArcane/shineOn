({
  fireActionEvent: function (component, data) {
    component.getEvent('onAction').fire(data);
  },
  firePreviewFile: function (recordId) {
    $A.get('e.lightning:openFiles').fire({
      recordIds: [ recordId ]
    });
  },
  fireOpenFile: function (recordId) {
    window.open('/servlet/servlet.FileDownload?file='+recordId, '_blank');
  }
});