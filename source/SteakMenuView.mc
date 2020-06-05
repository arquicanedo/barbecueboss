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

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	//register for timer changed "events"
		app.controller.timerChanged.on(self.method(:onTimerChanged));
    }
    
    //handle timer changed event
    function onTimerChanged(sender, value) {
    	Toybox.WatchUi.requestUpdate();
    }
    
    // Update the view
    function onUpdate(dc) {
		View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	//if the view isn't being displayed, there's no point in handling the timer callbacks and wasting memory
    	app.controller.timerChanged.reset();
    }
}
