using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class TimeSelectionMenuDelegate extends WatchUi.MenuInputDelegate {

	hidden var app;

    function initialize() {
        MenuInputDelegate.initialize();
        self.app = Application.getApp();
    }

	//onMenuItem is for MenuDelegate
	function onMenuItem(item){
		self.onSelect(item);
	}

	//this is the new method for Menu2Delegate which can't be supported until there's some kind of #ifdef available for the build
	//or a dynamic way of determining at runtime if it's supported without blowing up or failing to compile
    function onSelect(item) {
    
    	//var id = item.getId();

		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		

		if(item == :timerMenuStop) {
			selectedSteak.reset();
			return;
		}
		// Flip and set timeout to the elapsed time when the flip occurred
		if (item == :timerMenuFlip) {
			selectedSteak.setCurrentFlip(selectedSteak.getCurrentFlip()+1);
			System.println(Lang.format("The setTimeout = $1$ and the elapsedTimeout = $2$", [selectedSteak.getTimePerFlip(), selectedSteak.getTimeout()])); 
			selectedSteak.setTimePerFlip(selectedSteak.getTimeout());
		}
	}
}

