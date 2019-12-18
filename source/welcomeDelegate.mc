using Toybox.WatchUi;
using Toybox.System;

class welcomeDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        System.println("barbecue_appDelegate.initialize()");
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
   	function onSelect() {
		System.println("barbecue_appDelegate.onSelect Menu behavior triggered");
		WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuDelegate(), WatchUi.SLIDE_UP);
		return true;
	}
	
	// Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        return true;
    }
    

}