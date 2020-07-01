using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

class WelcomeDelegate extends WatchUi.BehaviorDelegate {

	hidden var app;
	
    function initialize() {
        BehaviorDelegate.initialize();
        
		app = Application.getApp();
		
		// Commenting for the release. Will be used in low-n-slow
		/*
		app.controller.getTimeOfDay();
		var myTime = app.controller.storageGetValue("smokerTime");
		var currentTime = app.controller.getTimeOfDay();
	
		System.println("Current time = " + currentTime);
		if (myTime != null) {
			var diff = currentTime - myTime;
			System.println("Saved time = " + myTime);
			System.println("UNIX time diff = " + diff);
		}
		*/
    }

    function onMenu() {
    	
    	if(Toybox.WatchUi has :Menu2) {
    		var useGps = new SettingsToggleMenuItem( WatchUi.loadResource(Rez.Strings.settings_gps), 
    														null, 
    														"useGps", 
    														app.controller.getGpsEnabled(), 
    														{ 
    															:getter => app.controller.method(:getGpsEnabled), 
    															:setter => app.controller.method(:setGpsEnabled)
    														});
    														
    		var useActivity = new SettingsToggleMenuItem( WatchUi.loadResource(Rez.Strings.settings_activity), 
														  null, 
														  "useActivity", 
														  app.controller.getActivityEnabled(), 
														  {
														  	:getter => app.controller.method(:getActivityEnabled),
														  	:setter => app.controller.method(:setActivityEnabled)
														  });

    		var menu2 = new WatchUi.Menu2({:title=> WatchUi.loadResource(Rez.Strings.settings_title)});
    		
    		menu2.addItem(useGps);
    		menu2.addItem(useActivity);
    		
    		WatchUi.pushView(menu2, new SettingsMenu2Delegate([useGps, useActivity]), WatchUi.SLIDE_UP);
    		
    	}
    	else {
    		var view = new SettingsView();
    		var delegate = new SettingsDelegate();
    		view.layoutLoaded.on(delegate.method(:onSettingsLayoutLoaded));
    	
			Toybox.WatchUi.pushView(view, delegate, WatchUi.SLIDE_UP);
		}
		
        return true;
    }
    
   	function onSelect() {
		//System.println("barbecue_appDelegate.onSelect Menu behavior triggered");
		
		Toybox.WatchUi.pushView(new SteakMenuView(), new SteakMenuDelegate(), WatchUi.SLIDE_UP);
		//Toybox.System.println("Changed to MainMenu()");
		return true;
	}
	
	// Detect Menu button input
	
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        
        if(keyEvent.getKey() == WatchUi.KEY_ENTER) {
        	self.onMenu();
        }
        
        return true;
    }
   	
   	function onBack() {
		var app = Application.getApp();
		// Save menu prompted if activity is enabled and there is at least one steak that has been initialized
		if(app.controller.getActivityEnabled() && app.controller.steaksInitialized()) {
			self.promptSaveSession();
		} else {
			WatchUi.popView(WatchUi.SLIDE_DOWN);
		}
		
		// Commenting for the release. Will be used in low-n-slow
		// Persist the smoking timer
		//app.controller.saveSmokeTimer();
		
   		return true;
   	}
    
    
    function promptSaveSession() {
    	var conf = new Toybox.WatchUi.Confirmation("Save Activity?");
		var resp = new SimpleDispatchConfirmationDelegate();
		
		//the confirmation view is "asynchronous" - to handle it here we need to provide a callback to
		//the delegate and in this case we're going to provide the onSaveConfirm defined below
		resp.callbackMethod = self.method(:onSaveConfirm);
		
		// XXX: Is there a way to select "accept" by default? Now it is "reject" by default.
		WatchUi.pushView(conf, resp, WatchUi.SLIDE_IMMEDIATE);
	}
	
    //this is how we want to handle responses from the confirmation view when we're deciding if we want to save/discard the activity
    //etc.
    function onSaveConfirm(response) {
    	
    	var app = Application.getApp();
    	 
    	if(response == WatchUi.CONFIRM_YES) {
    		app.controller.recordingStop();
			app.controller.recordingSave();
    	}
    	else {
    		app.controller.recordingStop();
    		app.controller.recordingDiscard();
    	}
    	
    	WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
    
    // Settings
	function onPreviousPage() {
		self.onMenu();
		return true;
    }
}