using Toybox;

class TotalTimeMenu extends Toybox.WatchUi.Menu {

	hidden var app;
	hidden var default_timeouts = ["4", "8", "10", "12"];
	hidden var default_timeouts_secs = ["240", "480", "600", "720"];
	hidden var default_symbols = [:totalTimeMenu4, :totalTimeMenu8, :totalTimeMenu10, :totalTimeMenu12];
	

	function initialize() {
		Toybox.WatchUi.Menu.initialize();
		self.app = Application.getApp();
		
		self.setTitle("Duration?");

		// Quickmenu for total time
		var lastTotalTime = app.controller.getLastTotalTime(app.controller.getSelectedSteak());
		var lastFlips = app.controller.getLastFlips(app.controller.getSelectedSteak());
		if (lastTotalTime != null && lastFlips != null) {
			self.addItem(Lang.format("$1$:$2$ min $3$ flips", [(lastTotalTime / 60).format("%02d"), (lastTotalTime % 60).format("%02d"), lastFlips]), :totalTimeMenuLast);
		}
		
		for (var i = 0; i<default_timeouts.size(); i+=1) {
			self.addItem(Lang.format("$1$ $2$", [default_timeouts[i], "min"]), default_symbols[i]);
		}
		self.addItem(Rez.Strings.menu_label_custom, :totalTimeMenuCustom);
	}
}