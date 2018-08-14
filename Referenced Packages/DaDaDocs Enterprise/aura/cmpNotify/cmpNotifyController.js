({
  handleChangeShow: function (component, event, helper) {
    var live = component.get('v.live');
    var show = component.get('v.show');

    if (!show) return;

    live && setTimeout(function () {
      helper.close(component);
    }, live * 1000);
  },
  handleClose: function (component, event, helper) {
    helper.close(component);
  }
});