using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;

const DURATION_MINUTE_FORMAT = "%02d";

class DurationPicker extends WatchUi.Picker {

	hidden var fontSize = Graphics.FONT_MEDIUM;

	enum {
		MMSS = 0,
		HHMM = 1,
	}

	
    function initialize(cookingMode) {

        var factories;
        var hourFactory;
        var numberFactories;
        
        //make sure if we're adjusting the display settings with json resources that the sdk is new enough AND that it has been specified in the device-specific resources
        if(System.getDeviceSettings().monkeyVersion[0] >= 2 && Rez.JsonData has :PickerLayoutSettings ) {
        
	        var settings = WatchUi.loadResource(Rez.JsonData.PickerLayoutSettings);
	        
	        switch(settings["fontSize"]){
	        	case "Graphics.FONT_SMALL":
	        		self.fontSize = Graphics.FONT_SMALL;
	        		break;
	        	
	        	case "Graphics.FONT_MEDIUM":
	        		self.fontSize = Graphics.FONT_MEDIUM;
	        		break;
	        		
	        	case "Graphics.FONT_LARGE":
	        		self.fontSize = Graphics.FONT_LARGE;
	        		break;
	        		
	        	default:
	        		self.fontSize = Graphics.FONT_MEDIUM;
	        		break; 
	        }
        }
        

		var title = null;
        if (cookingMode == MMSS) {
			title = new WatchUi.Text(
	        	{
	        		:text=>Rez.Strings.durationPickerTitleMMSS, 
	        		:locX=>WatchUi.LAYOUT_HALIGN_CENTER, 
	        		:locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
	        		:color=>Graphics.COLOR_WHITE, 
	        		:font => self.fontSize 
	        	}
	        );
		}
		else if (cookingMode == HHMM) {
			title = new WatchUi.Text(
	        	{
	        		:text=>Rez.Strings.durationPickerTitleHHMM, 
	        		:locX=>WatchUi.LAYOUT_HALIGN_CENTER, 
	        		:locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
	        		:color=>Graphics.COLOR_WHITE, 
	        		:font => self.fontSize 
	        	}
	        );	
		}

		
        factories = new [FACTORY_COUNT_24_HOUR];
        factories[0] = new NumberFactory(0, 59, 1, 
        	{ 
        		:font => self.fontSize
        	}
        );
        
        factories[1] = new WatchUi.Text(
        	{
        		:text=>Rez.Strings.timeSeparator, 
        		:font=>self.fontSize, 
        		:locX =>WatchUi.LAYOUT_HALIGN_CENTER, 
        		:locY=>WatchUi.LAYOUT_VALIGN_CENTER, 
        		:color=>Graphics.COLOR_WHITE, 
        	}
        );
        
        factories[2] = new NumberFactory(0, 59, 1, 
        	{
        		:format => DURATION_MINUTE_FORMAT, 
        		:font => Graphics.FONT_MEDIUM 
        	}
        );

        /*var defaults = splitStoredTime(factories.size());
        if(defaults != null) {
        
            defaults[0] = factories[0].getIndex(defaults[0].toNumber());
            defaults[2] = factories[2].getIndex(defaults[2].toNumber());
        
            if(defaults.size() == FACTORY_COUNT_12_HOUR) {
                defaults[3] = factories[3].getIndex(defaults[3]);
            }
        }*/

        Picker.initialize(
        	{
        		:title=>title, 
        		:pattern=>factories 
        		/*, :defaults=>defaults*/ 
        	}
        );
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    function splitStoredTime(arraySize) {
        var storedValue = Application.getApp().getProperty("time");
        var defaults = null;
        var separatorIndex = 0;
        var spaceIndex;

        if(storedValue != null) {
            defaults = new [arraySize];
            // the Drawable does not have a default value
            defaults[1] = null;

            // HH:MIN AM|PM
            separatorIndex = storedValue.find(WatchUi.loadResource(Rez.Strings.timeSeparator));
            if(separatorIndex != null ) {
                defaults[0] = storedValue.substring(0, separatorIndex);
            }
            else {
                defaults = null;
            }
        }

        if(defaults != null) {
			defaults[2] = storedValue.substring(separatorIndex + 1, storedValue.length());
        }

        return defaults;
    }
}

class DurationPickerCallbackDelegate extends WatchUi.PickerDelegate {

	public var callbackMethod;
	
    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        //var time = values[0] + WatchUi.loadResource(Rez.Strings.timeSeparator) + values[2].format(DURATION_MINUTE_FORMAT);
        self.callbackMethod.invoke(values);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
	}
}
