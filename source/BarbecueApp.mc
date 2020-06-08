using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;


class BarbecueApp extends Application.AppBase {

	public static var controller = new Controller();
	
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	self.controller.dispose();
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new WelcomeView(), new WelcomeDelegate() ];
    }
}
