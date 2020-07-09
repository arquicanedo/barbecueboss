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
    	var timeout = 1;
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		

		if(id == :timerMenuStop) {
			// Reset steakEntry
			selectedSteak.setTimeout(0);
			selectedSteak.setStatus(Controller.INIT);	
			//selectedSteak.setFoodType(SteakEntry.BEEF);
			return;
		}
		
        if(id == :totalTimeMenu8) {
			timeout = 8;
	    }
	    else if(id == :totalTimeMenu10) {
			timeout = 10;
	    }
	    else if(id == :totalTimeMenu12) {
			timeout = 12;
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
			WatchUi.popView(WatchUi.SLIDE_DOWN);
			WatchUi.pushView(new FlipMenu(), new FlipMenuDelegate(), WatchUi.SLIDE_UP);
		}
		
		
		
    }
    
	
	function onPickerSelected(values){
		System.println(values);		
		var timeout = ((values[0] * 60) + values[2]);
		var steak_i = app.controller.getSelectedSteak();
		var steaks = app.controller.getSteaks(); 
		steaks[steak_i].setTimeout(timeout);
		app.controller.setLastTimeout(steak_i, steaks[steak_i].getTimeout());
		app.controller.decideSelection();
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
	

	
}
