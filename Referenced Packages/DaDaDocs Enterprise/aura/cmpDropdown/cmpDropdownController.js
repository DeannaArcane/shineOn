({
    onInit: function (component, event, helper) {
        helper.setSubtitle(component);
    },

    onToggleClick: function (component, event, helper) {
        component.set('v.isActive', !component.get('v.isActive'));
        $A.get('e.pdffiller_sf:evtDropdownClick').fire({
            tabName: component.get('v.tabName'),
            dropdownName: component.get('v.appName')
        });
    },

    onRadioClick: function (component, event, helper) {
        const radioButtonChangeAction = component.getEvent('evtRadioButtonChange');
        radioButtonChangeAction.setParams({
            tabName: component.get('v.tabName'),
            dropdownName: component.get('v.appName'),
            dropdownIndex: component.get('v.index'),
            value: event.currentTarget.value
        });
        radioButtonChangeAction.fire();
        helper.setSubtitle(component);
    },

    onLabelClick: function (component, event, helper) {
        event.currentTarget.previousSibling.click();
    },

    onRefreshClick: function (component, event, helper) {
        event.preventDefault();
        event.stopPropagation();
        $A.get('e.pdffiller_sf:evtRefreshClick').fire({
            tabName: component.get('v.tabName'),
            dropdownName: component.get('v.appName')
        });
    },

    onPreviewClick: function (component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        const dataset = event.currentTarget.dataset;
        if (dataset.type === 'chatter') {
            setTimeout(() => {
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [dataset.id]
                });
            }, 100);
        } else {
            window.open(`/servlet/servlet.FileDownload?file=${dataset.id}`, '_blank');
        }
    },

    onEvtDropdownClick: function (component, event, helper) {
        if (component.get('v.appName') !== event.getParam('dropdownName') && component.get('v.tabName') === event.getParam('tabName')) {
            component.set('v.isActive', false);
        }
    },

    onEvtDocItemsUpdate: function (component, event, helper) {
        if (component.get('v.appName') === event.getParam('dropdownName')) helper.setSubtitle(component);
    },

    onEvtDropdownIsClosed: function (component, event, helper) {
        const eventDropdownIndex = event.getParam('dropdownIndex');
        const componentDropdownIndex = component.get('v.index');

        if (event.getParam('tabName') === component.get('v.tabName')) { // work only in current tab
            if (eventDropdownIndex === componentDropdownIndex) component.set('v.isActive', false); // close current dropdown
            if (componentDropdownIndex === eventDropdownIndex + 1) component.set('v.isActive', true); // open the next dropdown
        }
    },

    onEvtRefreshClick: function (component, event, helper) {
        if (event.getParam('tabName') === component.get('v.tabName')) { // work only in current tab
            if (component.get('v.index') > 0) {
                component.set('v.isActive', false);
            } else {
                component.set('v.isActive', true);
            }
        }
    },
});