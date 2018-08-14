({
  fireOnSaveEvent: function (component, detail) {
    component.getEvent('onSave').fire(detail);
  }
});