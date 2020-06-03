using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;


// https://forums.garmin.com/developer/connect-iq/f/discussion/535/appropriate-way-to-handling-exiting-onback-in-an-app/2371#2371

class SteakMenuDelegate extends WatchUi.BehaviorDelegate {

	hidden var app;
	hidden var deviceSettings;
	
    function initialize() {
        app = Application.getApp();
        BehaviorDelegate.initialize();
        
        self.deviceSettings = System.getDeviceSettings();
    }

    function onMenu() {
		System.println("SteakMenuDelegate.onMenu pressed");
        return true;
    }
    
   	function onSelect() {
		System.println("SteakMenuDelegate.onSelect pressed");
		WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuDelegate(), WatchUi.SLIDE_UP);
		return true;
	}
	
	// Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        return true;
    }
    

    function onNextPage() {
    
    	//round face watch devices with touch screens don't send swipe events, they use key events
    	//these keypresses are reversed from the kind of scroll/selection we are doing
    	
    	if(self.deviceSettings.isTouchScreen && self.deviceSettings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
    		app.controller.previousSteak();
    	}
    	else {
			app.controller.nextSteak();
		}
		
		Toybox.WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {

    	//round face watch devices with touch screens don't send swipe events, they use key events
    	//these keypresses are reversed from the kind of scroll/selection we are doing
    
    	if(self.deviceSettings.isTouchScreen && self.deviceSettings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
    		app.controller.nextSteak();
    	}
    	else {
    		app.controller.previousSteak();
    	}
    	
		Toybox.WatchUi.requestUpdate();
		return true;
    }
    
    // Detect Back button input
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
		return true;
    }

    function onSwipe(swipeEvent){
    
    	var dir = swipeEvent.getDirection();
    	
    	if(dir == WatchUi.SWIPE_DOWN) {
    		app.controller.nextSteak();
    	} 
    	else if(dir == WatchUi.SWIPE_UP) {
    		app.controller.previousSteak();
    	}
    }
    
}
