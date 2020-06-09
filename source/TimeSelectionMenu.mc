using Toybox;

class TimeSelectionMenu extends Toybox.WatchUi.Menu {

	hidden var app;
	hidden var default_timeouts = ["2", "3", "4"];
	hidden var default_symbols = [:timerMenu2, :timerMenu3, :timerMenu4];
	
	function seconds2minutes(seconds) {
		var min = seconds / 60;
		var sec = seconds % 60;
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
			var found = default_timeouts.indexOf(lastTimeout);
			var min = self.seconds2minutes(lastTimeout);
			if (found == -1) {
				self.addItem(min[0] + ":" + min[1] + " (last)", :timerMenuLast);
				for (var i = 0; i<default_timeouts.size(); i+=1) {
					self.addItem(default_timeouts[i], default_symbols[i]);
				}
			}
			else {
				for (var i = 0; i<default_timeouts.size(); i+=1) {
					if (i != found) {
						self.addItem(default_timeouts[i], default_symbols[i]);
					}
				}
			}
			self.addItem(Rez.Strings.menu_label_custom, :timerMenuCustom);		
		}
		
		
	}
}