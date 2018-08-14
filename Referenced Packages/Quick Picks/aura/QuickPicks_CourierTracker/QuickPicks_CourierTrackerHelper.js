({
	showCourierWindow : function(component, event, helper) {
        var trackingId = component.get("v.trackingId");
        var courierUrl = component.get("v.courierService");

        var newWindow;

        newWindow = window.open(courierUrl + trackingId, "mywindow", "status=0, toolbar=0, location=0, menubar=0, directories=0, resizable=0, scrollbars=1, height=600, width=1035");
	}
})