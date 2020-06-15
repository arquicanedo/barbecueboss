using Toybox;

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
		var lastTimeout = app.controller.storageGetValue("lastSteakTimeout");
		
		// The Stop button should be visible only when the steak is running.
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		if (selectedSteak.getStatus() != Controller.INIT) {
			self.addItem(Rez.Strings.menu_label_stop, :timerMenuStop);
		}
		
		if (lastTimeout == null) {
			lastTimeout = default_timeouts_secs[0];	
		}
		var found = default_timeouts_secs.indexOf(lastTimeout.toString());	
		
		System.println("************************ comparing " + lastTimeout + " " + default_timeouts_secs + " = " + found);
		var min = self.seconds2minutes(lastTimeout.toNumber());
		
		self.addItem(Lang.format("$1$:$2$ (last)", [min[0], min[1]]), :timerMenuLast);
		for (var i = 0; i<default_timeouts.size(); i+=1) {
			if (i != found) {
				self.addItem(default_timeouts[i], default_symbols[i]);
			}
		}			
		
		self.addItem(Rez.Strings.menu_label_custom, :timerMenuCustom);		
	}
}