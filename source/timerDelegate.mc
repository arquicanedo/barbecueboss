using Toybox.WatchUi;
using Toybox.System;

class timerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        System.println("barbecue_timerDelegate.initialize()");
        BehaviorDelegate.initialize();
    }

    function onMenu() {
		System.println("timerDelegate.onMenu pressed");
        return true;
    }
    
   	function onSelect() {
		System.println("barbecue_timerDelegate.onSelect Menu behavior triggered");
		return true;
	}
	
	// Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        return true;
    }

}