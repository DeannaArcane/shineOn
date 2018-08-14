({
  init: function (component, event, helper) {
    component.set(
      'v.items',
      helper.generateArrayOfIndexes(component.get('v.count'))
    );
  }
});