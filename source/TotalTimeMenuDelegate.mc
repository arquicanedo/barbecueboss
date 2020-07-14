using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class TotalTimeMenuDelegate extends WatchUi.MenuInputDelegate {

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
    	var totalTime = 0;
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		
		
		// Quickmenu
		if(id == :totalTimeMenuLast) {
			var lastTotalTime = app.controller.getLastTotalTime(app.controller.getSelectedSteak());
			var lastFlips = app.controller.getLastFlips(app.controller.getSelectedSteak());
			selectedSteak.setTotalTime(lastTotalTime);
			selectedSteak.setTimePerFlip(selectedSteak.getTotalTime() / lastFlips);
			selectedSteak.setTimeout(selectedSteak.getTimePerFlip());
			selectedSteak.setCurrentFlip(1);
			selectedSteak.setCookingMode(selectedSteak.TOTAL_TIME);
			app.controller.decideSelection();
			return;
		}
				
        if(id == :totalTimeMenu4) {
			totalTime = 4;
	    }
        if(id == :totalTimeMenu8) {
			totalTime = 8;
	    }
	    else if(id == :totalTimeMenu10) {
			totalTime = 10;
	    }
	    else if(id == :totalTimeMenu12) {
			totalTime = 12;
	    }
	    else if(id == :totalTimeMenuCustom) {
	    	totalTime = -1;
	    }

		//custom timeout, show the picker
		if(totalTime == -1) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onPickerSelected);

			// This is a weird behavior. I could not find a valid combination with popView, pushView. This seems to be the way to do it.
			WatchUi.switchToView(new FlipMenu(), new FlipMenuDelegate(), WatchUi.SLIDE_UP);
			WatchUi.pushView(new DurationPicker(), pickerDelegate, WatchUi.SLIDE_UP);

		}
		else {
			selectedSteak.setTotalTime(totalTime * 60);
			app.controller.setLastTotalTime(app.controller.getSelectedSteak(), totalTime*60);
			WatchUi.popView(WatchUi.SLIDE_DOWN);
			WatchUi.pushView(new FlipMenu(), new FlipMenuDelegate(), WatchUi.SLIDE_UP);
		}
		
		
		
    }
    
	function onPickerSelected(values){
		//System.println(values);
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];		
		var totalTime = ((values[0] * 60) + values[2]);

		selectedSteak.setTotalTime(totalTime);
		app.controller.setLastTotalTime(app.controller.getSelectedSteak(), totalTime); 
			
		//WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
	

	
}
