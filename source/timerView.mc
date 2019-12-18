using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;
using Toybox.Application;


class timerView extends WatchUi.View {

	hidden var app;
    hidden var myTimer;
	
	

    function initialize(minutes) {
    	System.println("timerView() initialized...");
    	app = Application.getApp();
    	app.controller.initializeTimer(minutes);
    	
    	/*
    	myTimer = new Timer.Timer();
    	myTimer.start(method(:timerCallback), 1000, true);
    	*/
    	
    	View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        System.println("timerView.onLayout() initialized...");
		WatchUi.View.setLayout(Rez.Layouts.TimerLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        System.println("onShow()");
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
		app.controller.countDown(dc);
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
