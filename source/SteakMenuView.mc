using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;
using Toybox.Application;


class SteakMenuView extends WatchUi.View {

	hidden var app;
	
    function initialize() {
        View.initialize();
        self.app = Application.getApp();
    }

    // Load your resources here
    function onLayout(dc) {
	    
	 	View.setLayout(Rez.Layouts.SteakMenuLayout(dc));
	 	
	 	var steakList = View.findDrawableById("steakList");
	 	steakList.setMaxSteaks(app.controller.getTotalSteaks());
	 	steakList.setSteaks(app.controller.getSteaks());
    }
    
    
    function updateSelector() {
        var selection = app.controller.getSelectedSteak();
    	
    	// XXX: This is dirty. I don't know how to concatenate strings in Monkey-c. I'd like to do this in a loop.
    	var selector_drawable1;
    	var selector_drawable2;
    	var selector_drawable3;
    	var selector_drawable4;
    	    	    	    	
    	// XXX: Is there a better way to "hide" the drawables? 
    	// For reference see this discussion https://forums.garmin.com/developer/connect-iq/f/discussion/3506/how-to-hide-a-drawable
		selector_drawable1 = View.findDrawableById("SteakSelector1"); 
		selector_drawable2 = View.findDrawableById("SteakSelector2"); 
		selector_drawable3 = View.findDrawableById("SteakSelector3"); 
		selector_drawable4 = View.findDrawableById("SteakSelector4");
    	
    	// Hide everything
    	selector_drawable1.setText("");
    	selector_drawable2.setText("");
    	selector_drawable3.setText("");
    	selector_drawable4.setText("");
    	
    	// Draw the correct one
    	switch (selection) {
    		case 0: selector_drawable1.setText(">"); break;
    	    case 1: selector_drawable2.setText(">"); break;
    	    case 2: selector_drawable3.setText(">"); break;
    	    case 3: selector_drawable4.setText(">"); break;
    	}
    }
    
    function updateSteakLabels() {
    	var steak1 = View.findDrawableById("Steak1"); 
    	var steak2 = View.findDrawableById("Steak2"); 
       	var steak3 = View.findDrawableById("Steak3"); 
    	var steak4 = View.findDrawableById("Steak4"); 
    	steak1.setColor(decideColor(0));
    	steak2.setColor(decideColor(1));
    	steak3.setColor(decideColor(2));
    	steak4.setColor(decideColor(3));
    }
    
    function updateSteakStatus() {
    	var status1 = app.controller.getStatus(0);
    	var status2 = app.controller.getStatus(1);
     	var status3 = app.controller.getStatus(2);
    	var status4 = app.controller.getStatus(3);
    	
    	var steak_drawable1 = View.findDrawableById("SteakStatus1"); 
    	var steak_drawable2 = View.findDrawableById("SteakStatus2"); 
    	var steak_drawable3 = View.findDrawableById("SteakStatus3"); 
    	var steak_drawable4 = View.findDrawableById("SteakStatus4");     	
    	
    	var status = new [app.controller.total_steaks];
    	
		for( var i = 0; i < app.controller.total_steaks; i += 1 ) {    	
			if (app.controller.getStatus(i) == app.controller.COOKING) {
				status[i] = Lang.format(
				"$1$ $2$", ["Flip", app.controller.totalFlips[i]]);
			}
			else {
				status[i] = "Start";
			}
		}
		
		steak_drawable1.setText(status[0]);
		steak_drawable2.setText(status[1]);
		steak_drawable3.setText(status[2]);
		steak_drawable4.setText(status[3]);	
		
		steak_drawable1.setColor(decideColor(0));
		steak_drawable2.setColor(decideColor(1));		
		steak_drawable3.setColor(decideColor(2));
		steak_drawable4.setColor(decideColor(3));		
										
    }
    
    function updateSteakMenu(dc) {
		self.updateSelector();
		self.updateSteakLabels();
		self.updateSteakStatus();
		self.updateTimers();
    }
    
    
   	function updateTimers() {
		var my_timers = new [app.controller.total_steaks];
		for( var i = 0; i < app.controller.total_steaks; i += 1 ) {
			var myMinutes;
			
			if (app.controller.getStatus(i) == app.controller.COOKING) { 	
				var minutes = app.controller.targetSeconds[i] / 60;
				var seconds = app.controller.targetSeconds[i] % 60;
			    myMinutes = Lang.format(
		    		"$1$:$2$",
    				[minutes.format("%02d"), seconds.format("%02d")]);
    			my_timers[i] = myMinutes;
			}
			else {
				myMinutes = Lang.format(
		    		"$1$:$2$",
    				["00", "00"]);
    			my_timers[i] = myMinutes;
			}
	    }	
	    var timer_drawable1 = View.findDrawableById("SteakTimer1"); 
	    var timer_drawable2 = View.findDrawableById("SteakTimer2"); 
	    var timer_drawable3 = View.findDrawableById("SteakTimer3"); 
	    var timer_drawable4 = View.findDrawableById("SteakTimer4");
	    
	    timer_drawable1.setText(my_timers[0]);
	    timer_drawable2.setText(my_timers[1]);
	    timer_drawable3.setText(my_timers[2]);
	    timer_drawable4.setText(my_timers[3]);
	     
	    timer_drawable1.setColor(decideColor(0));
	    timer_drawable2.setColor(decideColor(1));
	    timer_drawable3.setColor(decideColor(2));	     
	    timer_drawable4.setColor(decideColor(3));	     	     	     	     
	}
    
    

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        //register for timer changed "events"
		app.controller.timerChanged.on(self.method(:onTimerChanged));
    }
    
    //handle timer changed event
    function onTimerChanged(sender, value) {
    	//self.setTimers();
    	//self.updateTimers();
    	Toybox.WatchUi.requestUpdate();
    }
    
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
		//self.drawSteakMenu(dc);
		//self.updateSteakMenu(dc);
		View.onUpdate(dc);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
}
