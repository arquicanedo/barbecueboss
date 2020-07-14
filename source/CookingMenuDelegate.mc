using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class CookingMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

	function onMenuItem(item){
		self.onSelect(item);
	}

    function onSelect(item) {

        if(item == :cookingMenuSearing) {
			WatchUi.popView(WatchUi.SLIDE_DOWN);
			WatchUi.pushView(new UnboundedTimeSelectionMenu(), new UnboundedTimeSelectionMenuDelegate(), WatchUi.SLIDE_UP);
	    }
	    else if(item == :cookingMenuTotalTime) {
			WatchUi.popView(WatchUi.SLIDE_DOWN);
			WatchUi.pushView(new TotalTimeMenu(), new TotalTimeMenuDelegate(), WatchUi.SLIDE_UP);
	    }		
    }
}
