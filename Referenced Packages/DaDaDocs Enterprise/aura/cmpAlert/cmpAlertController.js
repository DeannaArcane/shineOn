({
    onInit: function (component, event, helper) {
        document.onkeyup = keyupEvent => {
            if (keyupEvent.keyCode === 27) component.set('v.isShown', false);
        };
        setTimeout(() => {
            component.set('v.isShown', false);
        }, 5000);
    },

    onCloseClick: function (component, event, helper) {
        const targetClasses = event.target.classList;
        if (targetClasses.contains('alert-container') || targetClasses.contains('alert-container__close')) {
            component.set('v.isShown', false);
        }
    }
});