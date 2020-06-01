using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class MenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
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
    	
    	System.println("Selected timer menu item: " + id.toString());

        if(id == :item_1) {
			timeout = 1;
	    }
	    else if(id == :item_2) {
			timeout = 2;
	    }
	    else if(id == :item_3) {
			timeout = 3;
	    }
	    else if(id == :item_4) {
			timeout = 4;
	    }
	    else if(id == :item_5) {
			timeout = 5;
	    } else if(id == :item_custom) {
	    	timeout = -1;
	    }

		//custom timeout, show the picker
		if(timeout == -1) {
			//Application.getApp().setProperty("duration", true);
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onPickerSelected);
			WatchUi.pushView(new DurationPicker(), pickerDelegate, WatchUi.SLIDE_UP);
		}
		else {
			WatchUi.switchToView(new SteakMenuView(), new SteakMenuDelegate(), WatchUi.SLIDE_UP);
			//WatchUi.pushView(new TimerView(timeout * 60), new TimerDelegate(), WatchUi.SLIDE_UP);
		}
    }
    
    
    function timerCooking() {
		Toybox.System.println("Cooking timer....");
	}
	
	function onPickerSelected(values){
		System.println("here");
		
		var timeout = ((values[0] * 60) + values[2]);
		//WatchUi.pushView(new TimerView(timeout), new TimerDelegate(), WatchUi.SLIDE_UP);
		WatchUi.switchToView(new SteakMenuView(), new SteakMenuDelegate(), WatchUi.SLIDE_UP);
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