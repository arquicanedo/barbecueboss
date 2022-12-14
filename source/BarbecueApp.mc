import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

import Toybox.System;


class BarbecueApp extends Application.AppBase {

	public static var controller = new Controller();
	
    function initialize() {
        AppBase.initialize();
    }


    // onStart() is called on application start up
    function onStart(state) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state) as Void {
    	self.controller.dispose();
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new WelcomeView(), new WelcomeDelegate() ] as Array<Views or InputDelegates>;
    }
}

function getApp() as BarbecueApp {
    return Application.getApp() as BarbecueApp;
}