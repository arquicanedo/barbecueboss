using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;


// https://forums.garmin.com/developer/connect-iq/f/discussion/535/appropriate-way-to-handling-exiting-onback-in-an-app/2371#2371

class SteakMenuDelegate extends WatchUi.BehaviorDelegate {

	hidden var app;

    function initialize() {
        app = Application.getApp();
        BehaviorDelegate.initialize();
    }

    function onMenu() {
		System.println("SteakMenuDelegate.onMenu pressed");
        return true;
    }
    
   	function onSelect() {

		return true;
	}
	
	// Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        return true;
    }
    

    function onNextPage() {
		app.controller.nextSteak();
		Toybox.WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {
		app.controller.previousSteak();
		Toybox.WatchUi.requestUpdate();
		return true;
    }
    
    
    // Detect Back button input
    function onBack() {
		return true;
    }

    
    
}
