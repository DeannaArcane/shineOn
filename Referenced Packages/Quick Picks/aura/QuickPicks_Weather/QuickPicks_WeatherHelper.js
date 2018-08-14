({    
    updateWeatherData: function(component, helper, searchText, sObjectName, recordId) {
        var updateWeatherAction = component.get("c.updateWeatherData");
        updateWeatherAction.setParams({
            "searchText": searchText,
            "sObjectName": sObjectName,
            "recordId": recordId
        });
        updateWeatherAction.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {    
                var spinner = component.find('spinner');
                $A.util.addClass(spinner, "slds-hide");
                helper.handleResult(component, response.getReturnValue());
            }
        });
        $A.enqueueAction(updateWeatherAction);    
    },
    handleResult: function(component, result) {   
        var weatherData;
        var currentDate;
        var sunRise, sunSet, location;
        var timeOfDay;
        var weather;
             
        try {
            weatherData = JSON.parse(result);
        } catch(err) {
            weatherData = "";
        }

        if(weatherData != null && weatherData.query != null && weatherData.query.results != null && weatherData.query.results.channel != null) {
            currentDate = new Date();
            timeOfDay = "d";
            weather = (weatherData.query.results.channel);

            if(weather && weather instanceof Array) {
                weather = weather[0];
            }

            if(weather != null && weather.astronomy != null && weather.location != null && weather.item != null && weather.units != null) {
                sunRise = new Date(currentDate.toDateString()+' '+weather.astronomy.sunrise);
                sunSet = new Date(currentDate.toDateString()+' '+weather.astronomy.sunset);
                if(currentDate > sunRise && currentDate < sunSet) {
                    timeOfDay = "d";
                } else {
                    timeOfDay = "n";
                }
                    
                location = weather.location.city;
                if(weather.location.region){
                    location += ', ' + weather.location.region;
                } else {
                    location += ', ' + weather.location.country;
                }
                component.set("v.location", location);
                component.set("v.image", 'http://l.yimg.com/a/i/us/nws/weather/gr/'+ weather.item.condition.code + timeOfDay + '.png');
                component.set("v.temperature", weather.item.condition.temp);
                component.set("v.units", weather.units.temperature);
                component.set("v.condition", weather.item.condition.text);
            }
        } else {
            component.set("v.location", null);
            component.set("v.image", null);
            component.set("v.temperature", null);
            component.set("v.units", null);
            component.set("v.condition", 'Weather details not available.');            
        }        
    }
})