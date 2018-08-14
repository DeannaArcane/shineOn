({
	loadCourierServices: function(component, event, helper) {
        var opts = [
                { class: "optionClass", label: "- Courier Service -", value: "", selected: "true" },
                { class: "optionClass", label: "DHL", value: "http://www.dhl.co.in/content/in/en/express/tracking.shtml?brand=DHL&AWB=" },
                { class: "optionClass", label: "FedEx", value: "https://www.fedex.com/fedextrack/?tracknumbers=" },
                { class: "optionClass", label: "UPS", value: "http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=" },
                { class: "optionClass", label: "US Postal Service", value: "http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=" }
            ];		    

	    component.find("courierServices").set("v.options", opts);
    },
    loadCourierService: function(component, event, helper) {
        var trackingId = component.get("v.trackingId");
        var courierUrl = component.get("v.courierService");

        if(trackingId !== '' && courierUrl !== '') { 
            helper.showCourierWindow(component, event, helper);
        }
    }
})