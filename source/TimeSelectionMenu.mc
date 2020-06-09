using Toybox;

class TimeSelectionMenu extends Toybox.WatchUi.Menu {

	hidden var app;
	hidden var default_timeouts = ["2", "3", "5"];
	hidden var default_timeouts_secs = ["120", "180", "300"];
	hidden var default_symbols = [:timerMenu2, :timerMenu3, :timerMenu4];
	
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
	    self.app = Application.getApp();
		Toybox.WatchUi.Menu.initialize();
		
		var lastTimeout = app.controller.storageGetValue("lastSteakTimeout");
		
		if (lastTimeout == null) {
			self.addItem(Rez.Strings.menu_label_stop, :timerMenuStop);
			for (var i = 0; i<default_timeouts.size(); i+=1) {
				self.addItem(default_timeouts[i], default_symbols[i]);
			}
			self.addItem(Rez.Strings.menu_label_custom, :timerMenuCustom);
		}
		else {

			self.addItem(Rez.Strings.menu_label_stop, :timerMenuStop);
			var found = default_timeouts_secs.indexOf(lastTimeout.toString());
			System.println("************************ comparing " + lastTimeout + " " + default_timeouts_secs + " = " + found);
			var min = self.seconds2minutes(lastTimeout);
			
			self.addItem(Lang.format("$1$:$2$ (last)", [min[0], min[1]]), :timerMenuLast);
			for (var i = 0; i<default_timeouts.size(); i+=1) {
				if (i != found) {
					self.addItem(default_timeouts[i], default_symbols[i]);
				}
			}			
			
			self.addItem(Rez.Strings.menu_label_custom, :timerMenuCustom);		
		}
		
		
	}
}