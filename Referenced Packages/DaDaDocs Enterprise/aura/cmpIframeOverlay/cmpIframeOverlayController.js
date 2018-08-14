({
  onCloseClick: function (component, event, helper) {
    const targetClasses = event.target.classList;
    if (targetClasses.contains('iframe-container') || targetClasses.contains('iframe-container__close')) {
      component.getEvent('evtCloseIframeOverlay').fire();
    }
  }
});