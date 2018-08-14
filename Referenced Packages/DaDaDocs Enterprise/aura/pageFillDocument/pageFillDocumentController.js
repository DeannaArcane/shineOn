({
    handleCanvasEvent: function (component, event, helper) {
        helper.callProcessEvent(component, event.getParam('detail'));
    }
});