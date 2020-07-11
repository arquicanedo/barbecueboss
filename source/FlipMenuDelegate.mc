using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class FlipMenuDelegate extends WatchUi.MenuInputDelegate {

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
    	var id = item;
    	var flips = 2;
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		
        if(id == :flipMenu2) {
			flips = 2;
	    }
	    else if(id == :flipMenu4) {
			flips = 4;
	    }
	    else if(id == :flipMenu6) {
			flips = 6;
	    }
	    else if(id == :flipMenu8) {
			flips = 8;
	    }
		
		
		// After we've set the total time (previous screen) and the # of flips is known, we can set the timeout *per flip*
		// The flip is unbounded to allow random flips. The timer will be stopped by checking the ETA against now. Regardless of the number of flips
		var secsPerFlip = selectedSteak.getTotalTime() / flips;
		selectedSteak.setTimePerFlip(secsPerFlip);
		selectedSteak.setTimeout(selectedSteak.getTimePerFlip());
		selectedSteak.setCurrentFlip(1);
		
		app.controller.decideSelection();
    }
    
}
