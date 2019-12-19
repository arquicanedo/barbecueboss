using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;


class welcomeView extends WatchUi.View {
	
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
	    View.setLayout(Rez.Layouts.WelcomeLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
	// https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/WatchUi.html#requestUpdate-instance_method
	function timerMainScreenCallback() {
		Toybox.WatchUi.pushView( new Rez.Menus.MainMenu(), new MenuDelegate(), Toybox.WatchUi.SLIDE_UP );
		Toybox.System.println("Changed to MainMenu()");
		Toybox.WatchUi.requestUpdate();
	}

	function selectTime(minutes) {
		System.print("User selected");
		System.println(minutes);
	}

}
