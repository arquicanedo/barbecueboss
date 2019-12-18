using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;


class barbecue_appApp extends Application.AppBase {

	public var controller;
	
    function initialize() {
        AppBase.initialize();
        controller = new Controller();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new welcomeView(), new welcomeDelegate() ];
    }
    

}
