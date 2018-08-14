({
    onInit: function (component, event, helper) {
        document.onkeyup = keyupEvent => {
            if (keyupEvent.keyCode === 27) component.set('v.isShown', false);
        };
    },

    onCloseClick: function (component, event, helper) {
        const targetClasses = event.target.classList;
        if (targetClasses.contains('prompt-container') || targetClasses.contains('prompt-container__close')) {
            component.set('v.isShown', false);
        }
    },

    onSubmitClick: function (component, event, helper) {
        const promptInput = component.find('promptInput').getElement();
        component
            .getEvent('evtPromptSubmit')
            .setParams({
                promptValue: promptInput.value,
                firedFrom: component.get('v.firedFrom')
            })
            .fire();
        // promptInput.value = '';
        component.set('v.isShown', false);
    }
});