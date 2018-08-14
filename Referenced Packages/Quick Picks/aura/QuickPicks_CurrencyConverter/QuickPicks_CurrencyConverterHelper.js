({
	getConvertedAmount: function (component, amount, fromCurrency, toCurrency) {
        var currencyAction = component.get("c.convertCurrency");
        currencyAction.setParams({
            "currencyAmount": amount,
            "currencyFrom": fromCurrency,
            "currencyTo": toCurrency
        });

        currencyAction.setCallback(this, function(response) {
            var state = response.getState();
            var spinner;

            if(component.isValid() && state === "SUCCESS") {        
                component.set("v.convertedAmount", response.getReturnValue());
            }
        });
        $A.enqueueAction(currencyAction);
	}
})