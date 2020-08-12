using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class TotalTimeMenuDelegate extends WatchUi.MenuInputDelegate {

	hidden var app;

    function initialize(app) {
        MenuInputDelegate.initialize();
        self.app = app;
    }

	//onMenuItem is for MenuDelegate
	function onMenuItem(item){
		self.onSelect(item);
	}

	//this is the new method for Menu2Delegate which can't be supported until there's some kind of #ifdef available for the build
	//or a dynamic way of determining at runtime if it's supported without blowing up or failing to compile
    function onSelect(item) {
    	var totalTime = 0;
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		
		
		// Quickmenu
		if(item == :totalTimeMenuLast) {
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
				
        if(item == :totalTimeMenu4) {
			totalTime = 4;
	    }
        if(item == :totalTimeMenu8) {
			totalTime = 8;
	    }
	    else if(item == :totalTimeMenu10) {
			totalTime = 10;
	    }
	    else if(item == :totalTimeMenu12) {
			totalTime = 12;
	    }
	    else if(item == :totalTimeMenuCustom) {
	    	totalTime = -1;
	    }

		//custom timeout, show the picker
		if(totalTime == -1) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onPickerSelected);

			// This is a weird behavior. I could not find a valid combination with popView, pushView. This seems to be the way to do it.
			WatchUi.switchToView(createFlipMenu(), new FlipMenuDelegate(self.app), WatchUi.SLIDE_UP);
			WatchUi.pushView(new DurationPicker(DurationPicker.MMSS), pickerDelegate, WatchUi.SLIDE_UP);

		}
		else {
			selectedSteak.setTotalTime(totalTime * 60);
			app.controller.setLastTotalTime(app.controller.getSelectedSteak(), totalTime*60);
			WatchUi.popView(WatchUi.SLIDE_DOWN);
			WatchUi.pushView(createFlipMenu(), new FlipMenuDelegate(), WatchUi.SLIDE_UP);
		}
    }
    
    function createFlipMenu() {
    
    	var default_flips = ["2", "4", "6", "8"];
		var default_symbols = [:flipMenu2, :flipMenu4, :flipMenu6, :flipMenu8];
		
    	var menu = new WatchUi.Menu();
    	menu.setTitle("Flips?");
		
		for (var i = 0; i<default_flips.size(); i+=1) {
			menu.addItem(Lang.format("$1$", [default_flips[i]]), default_symbols[i]);
		}
		
		return menu;
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
