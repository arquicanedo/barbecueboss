using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class FlipMenuDelegate extends WatchUi.MenuInputDelegate {

	hidden var app;

    function initialize(app) {
        MenuInputDelegate.initialize();
        self.app = app;
    }

	//onMenuItem is for MenuDelegate
	function onMenuItem(item){

    	var flips = 2;
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		
        if(item == :flipMenu2) {
			flips = 2;
	    }
	    else if(item == :flipMenu4) {
			flips = 4;
	    }
	    else if(item == :flipMenu6) {
			flips = 6;
	    }
	    else if(item == :flipMenu8) {
			flips = 8;
	    }
		
		
		// After we've set the total time (previous screen) and the # of flips is known, we can set the timeout *per flip*
		// The flip is unbounded to allow random flips. The timer will be stopped by checking the ETA against now. Regardless of the number of flips
		var secsPerFlip = selectedSteak.getTotalTime() / flips;
		selectedSteak.setTimePerFlip(secsPerFlip);
		selectedSteak.setTimeout(selectedSteak.getTimePerFlip());
		selectedSteak.setCurrentFlip(1);
		selectedSteak.setCookingMode(selectedSteak.TOTAL_TIME);
		app.controller.setLastFlips(app.controller.getSelectedSteak(), flips);
		
		app.controller.decideSelection();
    }
}
