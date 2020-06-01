using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;


// https://forums.garmin.com/developer/connect-iq/f/discussion/535/appropriate-way-to-handling-exiting-onback-in-an-app/2371#2371

class SteakMenuDelegate extends WatchUi.BehaviorDelegate {

	hidden var app;

    function initialize() {
        BehaviorDelegate.initialize();

    }

    function onMenu() {
		System.println("timerDelegate.onMenu pressed");
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
		System.println("next page");
        return true;
    }
    
    function onPreviousPage() {
		System.println("previous page");
        return true;
    }
    
    
    // Detect Back button input
    function onBack() {
		return true;
    }

    
    
}
