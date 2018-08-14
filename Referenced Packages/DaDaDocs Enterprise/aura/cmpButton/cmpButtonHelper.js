({
  fireOnClick: function (component) {
    var event = component.getEvent('onClick');
    event && event.fire();
  }
});