using Toybox.WatchUi;
using Toybox.System;

class SettingsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        return true;
    }
    
   	function onSelect() {
		return true;
	}
	

   	function onBack() {
   		WatchUi.popView(WatchUi.SLIDE_DOWN);
   		return true;
   	}
    

}