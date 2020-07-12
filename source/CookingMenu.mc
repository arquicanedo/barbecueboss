using Toybox;

class CookingMenu extends Toybox.WatchUi.Menu {
	function initialize() {
		Toybox.WatchUi.Menu.initialize();		
		self.setTitle("Grill Mode");
		self.addItem("Searing (Flip)", :cookingMenuSearing);
		self.addItem("Total Time", :cookingMenuTotalTime);
	}
}