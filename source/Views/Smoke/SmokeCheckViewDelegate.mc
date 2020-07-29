using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

(:smoke)
class SmokeCheckViewDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    	WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
    
   	function onSelect() {
   		WatchUi.popView(WatchUi.SLIDE_DOWN);
		return true;
	}
	
   	function onBack() {
   		WatchUi.popView(WatchUi.SLIDE_DOWN);
   		return true;
   	}
}