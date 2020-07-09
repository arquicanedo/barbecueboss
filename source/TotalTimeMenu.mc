using Toybox;

class TotalTimeMenu extends Toybox.WatchUi.Menu {

	hidden var app;
	hidden var default_timeouts = ["8", "10", "12"];
	hidden var default_timeouts_secs = ["480", "600", "720"];
	hidden var default_symbols = [:totalTimeMenu8, :totalTimeMenu10, :totalTimeMenu12];
	

	function initialize() {
		Toybox.WatchUi.Menu.initialize();
		self.app = Application.getApp();
		
		self.setTitle("Total cook time?");


		
		for (var i = 0; i<default_timeouts.size(); i+=1) {
			self.addItem(Lang.format("$1$ $2$", [default_timeouts[i], "min"]), default_symbols[i]);
		}
		self.addItem(Rez.Strings.menu_label_custom, :totalTimeMenuCustom);
		

	}
}