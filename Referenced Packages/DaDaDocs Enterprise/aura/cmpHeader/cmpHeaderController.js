({
  openFullEditor: function (component, event, helper) {
    event.preventDefault();
    const daDaDocsUrl = component.get('v.daDaDocsUrl');
    if (daDaDocsUrl) $A.get('e.force:navigateToURL').fire({url: daDaDocsUrl});
  }
});