using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

class UnboundedTimeSelectionMenuDelegate extends WatchUi.MenuInputDelegate {

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
    	var timeout = 1;
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		
    	//System.println("Selected timer menu item: " + id.toString());

		if(item == :timerMenuStop) {
			// Reset steakEntry
			selectedSteak.setTimeout(0);
			selectedSteak.setStatus(Controller.INIT);	
			//selectedSteak.setFoodType(SteakEntry.BEEF);
			return;
		}
		
        if(item == :timerMenu1) {
			timeout = 1;
	    }
	    else if(item == :timerMenu2) {
			timeout = 2;
	    }
	    else if(item == :timerMenu3) {
			timeout = 3;
	    }
	    else if(item == :timerMenu4) {
			timeout = 4;
	    }
	    else if(item == :timerMenu5) {
			timeout = 5;
	    } 
	    else if(item == :timerMenuLast) {
	    	var lastTimeout = app.controller.getLastTimeout(app.controller.getSelectedSteak());
			selectedSteak.setTimePerFlip(lastTimeout);
			selectedSteak.setTimeout(selectedSteak.getTimePerFlip());
			selectedSteak.setCurrentFlip(1);
			selectedSteak.setCookingMode(SteakEntry.SEARING);	
			app.controller.decideSelection();
			return;
	    }
	    else if(item == :timerMenuCustom) {
	    	timeout = -1;
	    }

		//custom timeout, show the picker
		if(timeout == -1) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onPickerSelected);
			WatchUi.pushView(new DurationPicker(DurationPicker.MMSS), pickerDelegate, WatchUi.SLIDE_UP);
		}
		else {
			selectedSteak.setTimePerFlip(timeout * 60);
			selectedSteak.setTimeout(selectedSteak.getTimePerFlip());
			selectedSteak.setCurrentFlip(1);
			selectedSteak.setCookingMode(SteakEntry.SEARING);		
			app.controller.decideSelection();
		}
    }

	
	function onPickerSelected(values){
		//System.println(values);
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		var timeout = ((values[0] * 60) + values[2]);
		selectedSteak.setTimePerFlip(timeout);
		selectedSteak.setTimeout(selectedSteak.getTimePerFlip());
		selectedSteak.setCurrentFlip(1);
		selectedSteak.setCookingMode(SteakEntry.SEARING);

		app.controller.setLastTimeout(app.controller.getSelectedSteak(), selectedSteak.getTimeout());
		app.controller.decideSelection();
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
}

