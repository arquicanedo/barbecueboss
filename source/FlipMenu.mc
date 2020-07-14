using Toybox;

class FlipMenu extends Toybox.WatchUi.Menu {

	hidden var app;
	hidden var default_flips = ["2", "4", "6", "8"];
	hidden var default_symbols = [:flipMenu2, :flipMenu4, :flipMenu6, :flipMenu8];
	

	function initialize() {
		Toybox.WatchUi.Menu.initialize();
		self.app = Application.getApp();
		
		self.setTitle("Flips?");
		
		for (var i = 0; i<default_flips.size(); i+=1) {
			self.addItem(Lang.format("$1$", [default_flips[i]]), default_symbols[i]);
		}
		//self.addItem(Rez.Strings.menu_label_custom, :flipMenuCustom);
		
	}
}