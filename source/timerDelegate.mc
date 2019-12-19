using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;


// https://forums.garmin.com/developer/connect-iq/f/discussion/535/appropriate-way-to-handling-exiting-onback-in-an-app/2371#2371

class timerDelegate extends WatchUi.BehaviorDelegate {

	hidden var app;
	
    function initialize() {
        System.println("barbecue_timerDelegate.initialize()");
        app = Application.getApp();
        BehaviorDelegate.initialize();
        app.controller.recordingStart();
    }

    function onMenu() {
		System.println("timerDelegate.onMenu pressed");
        return true;
    }
    
   	function onSelect() {
		System.println("barbecue_timerDelegate.onSelect Menu behavior triggered");
		app.controller.decideSelection();
		return true;
	}
	
	// Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        return true;
    }
    
    // Detect Back button input
    function onBack() {
    	System.println("Back button input received");
    	app.controller.decideCancellation();
    	return true;
    }

}