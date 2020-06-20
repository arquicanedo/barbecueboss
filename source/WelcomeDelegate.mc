using Toybox.WatchUi;
using Toybox.System;

class WelcomeDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        System.println("barbecue_appDelegate.initialize()");
        BehaviorDelegate.initialize();
        
		var app = Application.getApp();
		app.controller.getTimeOfDay();
		var myTime = app.controller.storageGetValue("smokerTimer");
		var currentTime = app.controller.getTimeOfDay();
		

		System.println("Current time = " + 
		    currentTime.hour.format("%02d") + ":" +
		    currentTime.min.format("%02d") + ":" +
		    currentTime.sec.format("%02d")
		);
		
		if (myTime != null) {
			System.println("Datastore time = " + 
			    myTime[0].format("%02d") + ":" +
			    myTime[1].format("%02d") + ":" +
			    myTime[2].format("%02d")
			);
			var diff = (currentTime.hour - myTime[0])*60*60 + (currentTime.min - myTime[1])*60 + (currentTime.sec - myTime[2]);
			System.println("App has been sleeping for " + 
			//currentTime.hour - myTime[0] + ":" + currentTime.min - myTime[1] + ":" + currentTime.sec - myTime[2] + "(" +
				diff + " seconds");
		}

    }

    function onMenu() {
    	var view = new SettingsView();
    	var delegate = new SettingsDelegate();
    	view.layoutLoaded.on(delegate.method(:onSettingsLayoutLoaded));
    	
		Toybox.WatchUi.pushView(view, delegate, WatchUi.SLIDE_UP);
        return true;
    }
    
   	function onSelect() {
		System.println("barbecue_appDelegate.onSelect Menu behavior triggered");
		
		Toybox.WatchUi.pushView(new SteakMenuView(), new SteakMenuDelegate(), WatchUi.SLIDE_UP);
		Toybox.System.println("Changed to MainMenu()");
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
		
		if(app.controller.getActivityEnabled()) {
			self.promptSaveSession();
		} else {
			WatchUi.popView(WatchUi.SLIDE_DOWN);
		}
		
		// Persist the smoking timer
		app.controller.saveSmokeTimer();
		
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