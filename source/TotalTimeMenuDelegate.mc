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
		

		if(id == :timerMenuStop) {
			// Reset steakEntry
			selectedSteak.setTotalTime(0);
			selectedSteak.setStatus(Controller.INIT);	
			return;
		}
				
        if(id == :totalTimeMenu1) {
			totalTime = 1;
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
	    else if(id == :timerMenuCustom) {
	    	totalTime = -1;
	    }

		//custom timeout, show the picker
		if(totalTime == -1) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onPickerSelected);
			WatchUi.pushView(new DurationPicker(), pickerDelegate, WatchUi.SLIDE_UP);
		}
		else {
			selectedSteak.setTotalTime(totalTime * 60);
			WatchUi.popView(WatchUi.SLIDE_DOWN);
			WatchUi.pushView(new FlipMenu(), new FlipMenuDelegate(), WatchUi.SLIDE_UP);
		}
		
		
		
    }
    
	function onPickerSelected(values){
		System.println(values);		
		var totalTime = ((values[0] * 60) + values[2]);
		var steak_i = app.controller.getSelectedSteak();
		var steaks = app.controller.getSteaks(); 
		steaks[steak_i].setTotalTime(totalTime);
		app.controller.decideSelection();
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
	

	
}
