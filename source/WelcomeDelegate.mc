using Toybox.WatchUi;
using Toybox.System;

class WelcomeDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        System.println("barbecue_appDelegate.initialize()");
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    	Toybox.WatchUi.pushView(new SteakMenuView(), new SteakMenuDelegate(), WatchUi.SLIDE_UP);
        //WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
   	function onSelect() {
		System.println("barbecue_appDelegate.onSelect Menu behavior triggered");
		
		/*if(Toybox.WatchUi has :Menu2) {
			Toybox.WatchUi.pushView( Rez.Menus.MainMenu2(), new Menu2InputDelegate(), Toybox.WatchUi.SLIDE_UP );
			Toybox.System.println("Changed to MainMenu()");
			//Toybox.WatchUi.requestUpdate();
		}
		else*/ {
			Toybox.WatchUi.pushView(new SteakMenuView(), new SteakMenuDelegate(), WatchUi.SLIDE_UP);
			//Toybox.WatchUi.pushView( new Rez.Menus.MainMenu(), new MenuDelegate(), Toybox.WatchUi.SLIDE_UP );
			Toybox.System.println("Changed to MainMenu()");
			//Toybox.WatchUi.requestUpdate();
		}
		
		//WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuDelegate(), WatchUi.SLIDE_UP);
		return true;
	}
	
	// Detect Menu button input
	/*
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        return true;
    }
   	*/
   	
   	function onBack() {
		var app = Application.getApp();
		self.promptSaveSession();
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
    	
    	app.controller.dispose();
    	WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    

}