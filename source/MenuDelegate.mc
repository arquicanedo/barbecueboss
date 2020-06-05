using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class MenuDelegate extends WatchUi.MenuInputDelegate {

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
		var selectedSteak = app.controller.steak_selection;
		
    	System.println("Selected timer menu item: " + id.toString());

		if(id == :timerMenuStop) {
			app.controller.steak_timeout[selectedSteak] = 0;
			app.controller.setStatus(selectedSteak, Controller.INIT);	
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
			app.controller.steak_timeout[selectedSteak] = timeout * 60;
			app.controller.decideSelection();
		}
    }
    
    
    function timerCooking() {
		Toybox.System.println("Cooking timer....");
	}
	
	function onPickerSelected(values){
		System.println("here");
		System.println(values);
		
		var timeout = ((values[0] * 60) + values[2]);
		var steak_i = app.controller.steak_selection;
		app.controller.steak_timeout[steak_i] = timeout;
		app.controller.decideSelection();
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
		System.println("pong");
	}
}

class DurationPickerCallbackDelegate extends DurationPickerDelegate {

	public var callbackMethod;
	
	public function initialize(){
		DurationPickerDelegate.initialize();
	}
	
	public function onAccept(values) {
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
		self.callbackMethod.invoke(values);
	}
	
	public function onCancel() {
		DurationPickerDelegate.onCancel();
	}
}