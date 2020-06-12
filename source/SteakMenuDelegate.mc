using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;


// https://forums.garmin.com/developer/connect-iq/f/discussion/535/appropriate-way-to-handling-exiting-onback-in-an-app/2371#2371

class SteakMenuDelegate extends WatchUi.BehaviorDelegate {

	hidden var app;
	hidden var deviceSettings;
	
	// We need a way to reuse these food types
	/* I tried this but doesn't work. Monkey-C is weird. foodIcons[selection] returns null */
	hidden var foodIcons = [
	    	Rez.Drawables.BurgerIconLarge,
	    	Rez.Drawables.BakeIconLarge,
	    	Rez.Drawables.ChickenIconLarge,
	    	Rez.Drawables.CornIconLarge,
	    	Rez.Drawables.FishIconLarge,
	    	Rez.Drawables.BeefIconLarge,
	    	Rez.Drawables.PorkIconLarge,
	    	Rez.Drawables.LambIconLarge
	];
	
    function initialize() {
        app = Application.getApp();
        BehaviorDelegate.initialize();
        
        self.deviceSettings = System.getDeviceSettings();
    }

    function onMenu() {
		System.println("SteakMenuDelegate.onMenu pressed");
        return true;
    }
    
   	function onSelect() {
		System.println("SteakMenuDelegate.onSelect pressed");

		var bp = new BitmapPicker(self.foodIcons);
		var bpd = new BitmapPickerCallbackDelegate(bp);
		bpd.callbackMethod = method(:onBitmapPickerSelected);
		WatchUi.pushView(bp, bpd, WatchUi.SLIDE_UP);
		
		/*
		// First step is to select a custom name.
		var sp = new StringPicker();
		var stringPickerDelegate = new StringPickerCallbackDelegate(sp);
		stringPickerDelegate.callbackMethod = method(:onStringPickerSelected);
		WatchUi.pushView(sp, stringPickerDelegate, WatchUi.SLIDE_UP);
		*/
		
		// v 1.0.0 used to prompt directly to the timer selection.
		//WatchUi.pushView(new TimeSelectionMenu(), new MenuDelegate(), WatchUi.SLIDE_UP);
		return true;
	}
	
	function onBitmapPickerSelected(selection) {
		// Hack. I can't get the item but only the bitmap.
		var typeOfSteak = app.controller.lastSelectedFoodType;

		System.println("******************************************************************" + foodIcons + " " + selection + " " + typeOfSteak);
		
		// Change steak properties to update it on the SteakMenu
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		selectedSteak.setFoodType(typeOfSteak);
		selectedSteak.setFoodTypeCount(app.controller.requestFood(typeOfSteak));

		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        
        WatchUi.pushView(new TimeSelectionMenu(), new TimeSelectionMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);		
		
	}
	
	
	function onStringPickerSelected(customSteakName) {
		// Custom steak name change
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		var typeOfSteak = SteakEntry.BEEF; // This will come from the IconSelector
		
		// Assign a steak number only for new steaks. 
		if (selectedSteak.getFoodTypeCount() == 0) {
			//selectedSteak.setFoodType(typeOfSteak);	
			selectedSteak.setFoodTypeCount(app.controller.requestFood(typeOfSteak));
		}
		selectedSteak.setLabel(customSteakName);
		
		
		// Switch views for the timer selection
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.pushView(new TimeSelectionMenu(), new TimeSelectionMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);	
	}
	
	// Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7        
        return true;
    }
    

    function onNextPage() {
    
    	//round face watch devices with touch screens don't send swipe events, they use key events
    	//these keypresses are reversed from the kind of scroll/selection we are doing
    	
    	if(self.deviceSettings.isTouchScreen && self.deviceSettings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
    		app.controller.previousSteak();
    	}
    	else {
			app.controller.nextSteak();
		}
		
		Toybox.WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {

    	//round face watch devices with touch screens don't send swipe events, they use key events
    	//these keypresses are reversed from the kind of scroll/selection we are doing
    
    	if(self.deviceSettings.isTouchScreen && self.deviceSettings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
    		app.controller.nextSteak();
    	}
    	else {
    		app.controller.previousSteak();
    	}
    	
		Toybox.WatchUi.requestUpdate();
		return true;
    }
    
    // Detect Back button input
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
		return true;
    }

    function onSwipe(swipeEvent){
    
    	var dir = swipeEvent.getDirection();
    	
    	if(dir == WatchUi.SWIPE_DOWN) {
    		app.controller.nextSteak();
    	} 
    	else if(dir == WatchUi.SWIPE_UP) {
    		app.controller.previousSteak();
    	}
    }
    
}


class StringPickerCallbackDelegate extends StringPickerDelegate {

	public var callbackMethod;
	
	public function initialize(sp){
		StringPickerDelegate.initialize(sp);
	}
	
	public function onAccept(values) {
		var name_set = StringPickerDelegate.onAccept(values);
		if (name_set == true) {
			self.callbackMethod.invoke(self.getSteakName());
		}

	}
	
	function getSteakName() {
    	return mPicker.getTitle();
    }
	
	public function onCancel() {
		StringPickerDelegate.onCancel();
	}
	
	public function onBack() {
		// I'm a bit confused, is this how the switch is made?
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
}


class BitmapPickerCallbackDelegate extends BitmapPickerDelegate {

	public var callbackMethod;
	
	public function initialize(sp){
		BitmapPickerDelegate.initialize(sp);
	}
	
	public function onAccept(values) {
		self.callbackMethod.invoke(values);
	}
	
	
	public function onCancel() {
		BitmapPickerDelegate.onCancel();
	}
	
	public function onBack() {
		// I'm a bit confused, is this how the switch is made?
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
}


class BitmapPickerDelegate extends WatchUi.PickerDelegate {
    hidden var mPicker;

    function initialize(picker) {
        PickerDelegate.initialize();
        mPicker = picker;
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        if(!mPicker.isDone(values[0])) {
            return false;
        }
        else {
            if(mPicker.getTitle().length() == 0) {
                Application.getApp().deleteProperty("string");
            }
            else {
                Application.getApp().setProperty("string", mPicker.getTitle());
            }
            return true;
        }
    }
}
