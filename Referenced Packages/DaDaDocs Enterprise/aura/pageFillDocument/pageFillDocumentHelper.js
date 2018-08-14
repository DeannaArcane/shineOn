({
    callProcessEvent: function (component, eventJson) {
        var loadingState = this.loadingState;
        var redirectToParent = this.redirectToParent;


        var action = component.get('c.processEvent');

        const params = {
            parentId: component.get('v.parentId'),
            objectId: component.get('v.objectId'),
            pdfAction: component.get('v.pdfAction'),
            eventJson: eventJson,
            objectType: component.get('v.objectType')
        };

        action.setParams(params);

        action.setCallback(this, this.responseHandler(component, {
            onSuccess: function (response) {
                var msg = response.getReturnValue();

                var redirectParams = {};
                redirectParams[msg.status] = msg.message;

                redirectToParent(component, redirectParams);

                loadingState(component, false);
            }
        }));

        loadingState(component, true);

        $A.enqueueAction(action);
    },
    redirectToParent: function (component, params) {
        var PARAM_PREFIX = 'DaDaDocs_';
        var url = '/one/one.app#/sObject/' + component.get('v.parentId') + '/view';

        if (params) {
            var query = Object.keys(params).map(function (param) {
                return PARAM_PREFIX + param + '=' + params[param];
            });

            url += '?' + query.join('&');
        }

        sforce.one.navigateToURL(url);
    },
    loadingState: function (component, state) {
        component.set('v.showLoader', state);
    },
    responseHandler: function (component, handlers) {
        handlers = handlers || {};

        var redirectToParent = this.redirectToParent;
        var loadingState = this.loadingState;

        var callbacks = {
            SUCCESS: handlers.onSuccess,
            ERROR: function (response) {
                var errors = response.getError();
                var error = errors[0] && errors[0].message ? ' ' + errors[0].message : '';

                loadingState(component, false);

                redirectToParent(component, {
                    error: component.get('v.labelDefaultErrorMessage') + error
                });
            },
            INCOMPLETE: function () {
                loadingState(component, false);

                redirectToParent(component, {
                    warning: component.get('v.labelIncompleteMessage')
                });
            }
        };

        return function (response) {
            var callback = callbacks[response.getState()];
            callback && callback(response);
        }
    }
});