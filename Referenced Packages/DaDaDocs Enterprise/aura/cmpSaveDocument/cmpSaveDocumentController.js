({
  handleSave: function (component, event, helper) {
    var nameInput = component.find('name');
    var nameValue = nameInput.get('v.value');

    if (!nameValue) {
      nameInput.set('v.errors', [{ message: component.get('v.labelRequiredField') }]);

      return;
    }

    nameInput.set('v.errors', null);

    helper.fireOnSaveEvent(component, {
      name: nameValue
    });
  }
});