using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;


// https://forums.garmin.com/developer/connect-iq/f/discussion/535/appropriate-way-to-handling-exiting-onback-in-an-app/2371#2371

class SteakMenuDelegate extends WatchUi.BehaviorDelegate {

	hidden var app;
	hidden var isTouchScreen = false;
	hidden var screenShape = System.SCREEN_SHAPE_SEMI_ROUND;

    function initialize() {
        app = Application.getApp();
        BehaviorDelegate.initialize();
        
        var deviceSettings = System.getDeviceSettings();
        self.isTouchScreen = deviceSettings.isTouchScreen;
        self.screenShape = deviceSettings.screenShape;
    }

    function onMenu() {
		//System.println("SteakMenuDelegate.onMenu pressed");
        return true;
    }
    
   	function onSelect() {
		//System.println("SteakMenuDelegate.onSelect pressed");

		// The Food Type menu should be visible only when the timer is not initialized.
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		if (selectedSteak.getStatus() != Controller.INIT) {
			WatchUi.pushView(new TimeSelectionMenu(), new TimeSelectionMenuDelegate(), WatchUi.SLIDE_UP);	
			//WatchUi.pushView(new TotalTimeMenu(), new TotalTimeMenuDelegate(), WatchUi.SLIDE_UP);	
		}
		else {
			// We need a way to reuse these food types
			/* I tried this but doesn't work. Monkey-C is weird. foodIcons[selection] returns null */
			//moved this var from being a class member to here to reduce general memory useage - this array
			//will only be created when something is selected for editing so its memory footprint only applies when
			//the user is changing items in the list
			var foodIcons = self.getFoodIconsForDevice();	
			var typeOfSteak = app.controller.getLastFoodType(app.controller.getSelectedSteak());
			var bp = new BitmapPicker(foodIcons, typeOfSteak);
			var bpd = new BitmapPickerCallbackDelegate(bp);
			bpd.callbackMethod = method(:onBitmapPickerSelected);
			WatchUi.pushView(bp, bpd, WatchUi.SLIDE_UP);
		}
		
		return true;
	}
	
	
	function getFoodIconsForDevice() {
		var size = WatchUi.loadResource(Rez.Strings.bitmap_picker_icon_size);
		
		switch(size) {
			case "SMALL":
				return [
					Rez.Drawables.BurgerIconSmall,
					Rez.Drawables.BakeIconSmall,
					Rez.Drawables.ChickenIconSmall,
					Rez.Drawables.CornIconSmall,
					Rez.Drawables.FishIconSmall,
					Rez.Drawables.BeefIconSmall,
					Rez.Drawables.DrinkIconSmall,
					Rez.Drawables.SmokeIconSmall
					];
			
				break;
				
			case "MEDIUM":
				return [
					Rez.Drawables.BurgerIconMedium,
					Rez.Drawables.BakeIconMedium,
					Rez.Drawables.ChickenIconMedium,
					Rez.Drawables.CornIconMedium,
					Rez.Drawables.FishIconMedium,
					Rez.Drawables.BeefIconMedium,
					Rez.Drawables.DrinkIconMedium,
					Rez.Drawables.SmokeIconMedium
					];
			
				break;
				
			case "LARGE":
				return [
						Rez.Drawables.BurgerIconLarge,
						Rez.Drawables.BakeIconLarge,
						Rez.Drawables.ChickenIconLarge,
						Rez.Drawables.CornIconLarge,
						Rez.Drawables.FishIconLarge,
						Rez.Drawables.BeefIconLarge,
						Rez.Drawables.DrinkIconLarge,
						Rez.Drawables.SmokeIconLarge
						];
			
				break;
			
			case "EXTRA_LARGE":
				return [
						Rez.Drawables.BurgerIconExtraLarge,
						Rez.Drawables.BakeIconExtraLarge,
						Rez.Drawables.ChickenIconExtraLarge,
						Rez.Drawables.CornIconExtraLarge,
						Rez.Drawables.FishIconExtraLarge,
						Rez.Drawables.BeefIconExtraLarge,
						Rez.Drawables.DrinkIconExtraLarge,
						Rez.Drawables.SmokeIconExtraLarge
					   ];			
				break;		
		}
		
		return [
				Rez.Drawables.BurgerIconLarge,
				Rez.Drawables.BakeIconLarge,
				Rez.Drawables.ChickenIconLarge,
				Rez.Drawables.CornIconLarge,
				Rez.Drawables.FishIconLarge,
				Rez.Drawables.BeefIconLarge,
				Rez.Drawables.DrinkIconLarge,
				Rez.Drawables.SmokeIconLarge
				];
		
	}
	
	function onBitmapPickerSelected(selection) {
		// Hack. I can't get the item but only the bitmap.
		var typeOfSteak = app.controller.lastSelectedFoodType;

		//System.println("******************************************************************" + foodIcons + " " + selection + " " + typeOfSteak);
		
		// Change steak properties to update it on the SteakMenu
		var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
		selectedSteak.setFoodType(typeOfSteak);
		app.controller.setLastFoodType(app.controller.getSelectedSteak(), typeOfSteak);

		WatchUi.popView(WatchUi.SLIDE_DOWN);
        
        //WatchUi.pushView(new TimeSelectionMenu(), new TimeSelectionMenuDelegate(), WatchUi.SLIDE_UP);		
		//WatchUi.pushView(new TotalTimeMenu(), new TotalTimeMenuDelegate(), WatchUi.SLIDE_UP);	
		WatchUi.pushView(new CookingMenu(), new CookingMenuDelegate(), WatchUi.SLIDE_UP);	
	}
	
	
	// Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7        
        return true;
    }
    
    function onNextPage() {
    
    	//round face watch devices with touch screens don't send swipe events, they use key events
    	//these keypresses are reversed from the kind of scroll/selection we are doing
    	
    	if(self.isTouchScreen && self.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
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
    
    	if(self.isTouchScreen && self.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
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


/* class StringPickerCallbackDelegate extends StringPickerDelegate {

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
} */


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
		WatchUi.popView(WatchUi.SLIDE_DOWN);
	}
}


class BitmapPickerDelegate extends WatchUi.PickerDelegate {
    hidden var mPicker;

    function initialize(picker) {
        PickerDelegate.initialize();
        mPicker = picker;
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onAccept(values) {
        if(!mPicker.isDone(values[0])) {
            return false;
        }
        
        return true;
    }
}
