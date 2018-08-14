({
  setSubtitle: function (component) {
    const dropdownType    = component.get('v.type');
    const defaultSubtitle = component.get('v.defaultSubtitle');
    const selectedItemId  = component.get('v.selectedItem');

    if (dropdownType === 'list') {
      if (selectedItemId) {
        const selectedItem = component.get('v.docItems').find(item => item.id === selectedItemId);
        component.set('v.subtitle', selectedItem.name);
      } else {
        component.set('v.subtitle', defaultSubtitle);
      }
    } else if (dropdownType === 'radio-buttons') {
      component.set('v.subtitle', selectedItemId ? selectedItemId : defaultSubtitle);
    }
  },
});