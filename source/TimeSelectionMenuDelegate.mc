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
    	var id = item;
    	var timeout = 1;
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		
    	//System.println("Selected timer menu item: " + id.toString());

		if(id == :timerMenuStop) {
			// Reset steakEntry
			selectedSteak.setTimeout(0);
			selectedSteak.setStatus(Controller.INIT);	
			selectedSteak.setFoodType(SteakEntry.BEEF);
			return;
		}
		
        if(id == :timerMenu1) {
			timeout = 1;
	    }
	    else if(id == :timerMenu2) {
			timeout = 2;
	    }
	    else if(id == :timerMenu3) {
			timeout = 3;
	    }
	    else if(id == :timerMenu4) {
			timeout = 4;
	    }
	    else if(id == :timerMenu5) {
			timeout = 5;
	    } 
	    else if(id == :timerMenuLast) {
	    	var lastTimeout = app.controller.storageGetValue("lastSteakTimeout");
			selectedSteak.setTimeout(lastTimeout);
			app.controller.decideSelection();
			return;
	    }
	    else if(id == :timerMenuCustom) {
	    	timeout = -1;
	    }

		//custom timeout, show the picker
		if(timeout == -1) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onPickerSelected);
			WatchUi.pushView(new DurationPicker(), pickerDelegate, WatchUi.SLIDE_UP);
		}
		else {
			selectedSteak.setTimeout(timeout * 60);
			app.controller.decideSelection();
		}
    }
    
    
    function timerCooking() {
		Toybox.System.println("Cooking timer....");
	}
	
	
	function onPickerSelected(values){
		System.println(values);		
		
		var timeout = ((values[0] * 60) + values[2]);
		var steak_i = app.controller.getSelectedSteak();
		var steaks = app.controller.getSteaks(); 
		steaks[steak_i].setTimeout(timeout);
		app.controller.storageSetValue("lastSteakTimeout", timeout);
		app.controller.decideSelection();
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
}
