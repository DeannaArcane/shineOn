({
  handleFileClick: function (component, event, helper) {
    component.get('v.needDownload')
      ? helper.fireOpenFile(component.get('v.recordId'))
      : helper.firePreviewFile(component.get('v.recordId'));
  },
  handleAction: function (component, event, helper) {
    helper.fireActionEvent(component, {
      name: event.getSource().getLocalId(),
      objectId: component.get('v.recordId')
    });
  }
});