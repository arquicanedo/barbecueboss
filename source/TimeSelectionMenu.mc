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

