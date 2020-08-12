using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class CookingMenuDelegate extends WatchUi.MenuInputDelegate {

	hidden var _app;
	
    function initialize(app) {
        MenuInputDelegate.initialize();
        _app = app;
    }

	function onMenuItem(item){
		self.onSelect(item);
	}

    function onSelect(item) {

        if(item == :cookingMenuSearing) {
			WatchUi.popView(WatchUi.SLIDE_DOWN);
			WatchUi.pushView(createUnboundedTimeMenu(), new UnboundedTimeSelectionMenuDelegate(self._app), WatchUi.SLIDE_UP);
	    }
	    else if(item == :cookingMenuTotalTime) {
			WatchUi.popView(WatchUi.SLIDE_DOWN);
			WatchUi.pushView(createTotalTimeMenu(), new TotalTimeMenuDelegate(self._app), WatchUi.SLIDE_UP);
	    }		
    }
    
    function createTotalTimeMenu() {
    	var default_timeouts = ["4", "8", "10", "12"];
		var default_timeouts_secs = ["240", "480", "600", "720"];
		var default_symbols = [:totalTimeMenu4, :totalTimeMenu8, :totalTimeMenu10, :totalTimeMenu12];
    	var menu = new WatchUi.Menu();
    	
    	menu.setTitle("Duration?");

		// Quickmenu for total time
		var lastTotalTime = _app.controller.getLastTotalTime(_app.controller.getSelectedSteak());
		var lastFlips = _app.controller.getLastFlips(_app.controller.getSelectedSteak());
		if (lastTotalTime != null && lastFlips != null) {
			menu.addItem(Lang.format("$1$:$2$ min $3$ flips", [(lastTotalTime / 60).format("%02d"), (lastTotalTime % 60).format("%02d"), lastFlips]), :totalTimeMenuLast);
		}
		
		for (var i = 0; i<default_timeouts.size(); i+=1) {
			menu.addItem(Lang.format("$1$ $2$", [default_timeouts[i], "min"]), default_symbols[i]);
		}
		menu.addItem(Rez.Strings.menu_label_custom, :totalTimeMenuCustom);
    
    	return menu;
    
    }
    
    function seconds2minutes(seconds) {
		var min = seconds / 60;
		var sec = seconds % 60;
		// Is there a cleaner way to format the time?
		if (sec < 10) {
			sec = "0"+sec;
		}

		return [min, sec];
	}
    
    function createUnboundedTimeMenu() {
	    var default_timeouts = ["2", "3", "5"];
		var default_timeouts_secs = ["120", "180", "300"];
		var default_symbols = [:timerMenu2, :timerMenu3, :timerMenu5];
		var menu = new WatchUi.Menu();
		
		menu.setTitle(WatchUi.loadResource(Rez.Strings.menu_timer_title));
		
		// The Stop button should be visible only when the steak is running.
		var selectedSteak = (_app.controller.getSteaks())[_app.controller.getSelectedSteak()];
		var lastTimeout = _app.controller.getLastTimeout(_app.controller.getSelectedSteak());
		if (selectedSteak.getStatus() != Controller.INIT) {
			menu.addItem(Rez.Strings.menu_label_stop, :timerMenuStop);
		}
		
		var found = -1;
		
		if (lastTimeout == null) {
			for (var i = 0; i<default_timeouts.size(); i+=1) {
				menu.addItem(Lang.format("$1$:$2$", [default_timeouts[i], "00"]), default_symbols[i]);
			}				
		} 
		else {
			// Add (last) timeout plus all the defaults avoiding duplicates
			var min = self.seconds2minutes(lastTimeout.toNumber());
		
			menu.addItem(Lang.format("$1$:$2$ (last)", [min[0], min[1]]), :timerMenuLast);

			// Avoid duplicates
			found = default_timeouts_secs.indexOf(lastTimeout.toString());
			for (var i = 0; i<default_timeouts.size(); i+=1) {
				if (i != found) {
					menu.addItem(Lang.format("$1$:$2$", [default_timeouts[i], "00"]), default_symbols[i]);
				}
			}	
			
		}

		menu.addItem(Rez.Strings.menu_label_custom, :timerMenuCustom);
		
		return menu;
    }
}
