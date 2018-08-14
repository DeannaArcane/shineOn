({    
    loadTime: function(component, helper) {
        var fetchTimeData = component.get("c.GetUSTime");
        
        fetchTimeData.setCallback(this, function(response) {
            var state = response.getState();
            var UsTimeData = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                var spinner = component.find("spinner");
                $A.util.addClass(spinner, "slds-hide");
                
                helper.runUSClock(component,UsTimeData,helper);
            } else {
                /*eslint no-console: "error"*/
				// custom console
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(fetchTimeData);
    },
    runUSClock: function(component, UsTimeData, helper) {
        
        var pacificTime = new Date();
        var mountainTime = new Date();
        var centralTime = new Date();
        var easternTime = new Date();
        
        pacificTime = helper.setHourMin(UsTimeData.pacific);
        mountainTime = helper.setHourMin(UsTimeData.mountain);
        centralTime = helper.setHourMin(UsTimeData.central);
        easternTime = helper.setHourMin(UsTimeData.eastern);
        
        
        window.setInterval( $A.getCallback(function() {

            pacificTime.setUTCSeconds(pacificTime.getUTCSeconds() + 1);
            mountainTime.setUTCSeconds(mountainTime.getUTCSeconds() + 1);
            centralTime.setUTCSeconds(centralTime.getUTCSeconds() + 1);
            easternTime.setUTCSeconds(easternTime.getUTCSeconds() + 1);
            
            helper.setTimeFor(component, mountainTime, "mountainTime");
            helper.setTimeFor(component, pacificTime, "pacificTime");
            helper.setTimeFor(component, centralTime, "centralTime");
            helper.setTimeFor(component, easternTime, "easternTime");
            
        }), 1000);
    },
    format: function(num) {
        if(num > 12) {
            return (num - 12);
        } 
        else if(num === 0) {
            return 12;
        } 
            else {
                return num;
            }
    },
    SetAmPm: function (hour) {
        if(hour >= 0 && hour < 12) {
            return(" AM");
        }
        else if (hour > 12 && hour <= 24) {
            return (" PM");
        }
    },
    setHourMin: function(timevaluestring) {
        var timevalue = new Date();
        
        timevalue.setUTCHours(parseInt(timevaluestring.substring(0, 2), 10));
        timevalue.setUTCMinutes(parseInt(timevaluestring.substring(3), 10));
        return timevalue;
    },
    setTimeFor: function (component, timevalue, timestring) {
        if(component.isValid())
        component.set("v."+timestring, this.format(parseInt(timevalue.getUTCHours(), 10)) +":"+timevalue.getUTCMinutes()+":"+timevalue.getUTCSeconds()+this.SetAmPm(parseInt(timevalue.getUTCHours(), 10)));
    }
    
})