using Toybox;


class TimeSelectionMenu extends Toybox.WatchUi.Menu {

	hidden var app;


	function initialize() {
		Toybox.WatchUi.Menu.initialize();
		
		self.setTitle("Steak Timer");
		self.app = Application.getApp();
		
		// The Stop button should be visible only when the steak is running.
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		if (selectedSteak.getStatus() != Controller.INIT) {
			// Order matters. I think flip may be more common if you are using a total time
			self.addItem("Flip", :timerMenuFlip);
			self.addItem(Rez.Strings.menu_label_stop, :timerMenuStop);
		}
	}
}

/*
class TimeSelectionMenu extends Toybox.WatchUi.Menu {

	hidden var app;
	hidden var default_timeouts = ["2", "3", "5"];
	hidden var default_timeouts_secs = ["120", "180", "300"];
	hidden var default_symbols = [:timerMenu2, :timerMenu3, :timerMenu5];
	
	function seconds2minutes(seconds) {
		var min = seconds / 60;
		var sec = seconds % 60;
		// Is there a cleaner way to format the time?
		if (sec < 10) {
			sec = "0"+sec;
		}

		return [min, sec];
	}

	function initialize() {
		Toybox.WatchUi.Menu.initialize();
		
		self.setTitle(WatchUi.loadResource(Rez.Strings.menu_timer_title));
		self.app = Application.getApp();
		
		// The Stop button should be visible only when the steak is running.
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		var lastTimeout = app.controller.getLastTimeout(app.controller.getSelectedSteak());
		if (selectedSteak.getStatus() != Controller.INIT) {
			self.addItem(Rez.Strings.menu_label_stop, :timerMenuStop);
		}
		
		var found = -1;
		
		if (lastTimeout == null) {
			for (var i = 0; i<default_timeouts.size(); i+=1) {
				self.addItem(Lang.format("$1$:$2$", [default_timeouts[i], "00"]), default_symbols[i]);
			}				
		} 
		else {
			// Add (last) timeout plus all the defaults avoiding duplicates
			var min = self.seconds2minutes(lastTimeout.toNumber());
		
			self.addItem(Lang.format("$1$:$2$ (last)", [min[0], min[1]]), :timerMenuLast);

			// Avoid duplicates
			found = default_timeouts_secs.indexOf(lastTimeout.toString());
			for (var i = 0; i<default_timeouts.size(); i+=1) {
				if (i != found) {
					self.addItem(Lang.format("$1$:$2$", [default_timeouts[i], "00"]), default_symbols[i]);
				}
			}	
			
		}

		self.addItem(Rez.Strings.menu_label_custom, :timerMenuCustom);
	}
}
*/