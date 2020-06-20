using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;
using Toybox.Application;


class SteakMenuView extends WatchUi.View {

	hidden var app;
	hidden var _gpsIcon;
	hidden var _activityIcon; 
		
    function initialize() {
        View.initialize();
        self.app = Application.getApp();
    }

    // Load your resources here
    function onLayout(dc) {
	 	View.setLayout(Rez.Layouts.SteakMenuLayout(dc));
	 	
	 	
	 	if (app.controller.getGpsEnabled() == true) {
		 	self._gpsIcon = WatchUi.loadResource(Rez.Drawables.GpsIconSmall);
		 	// This is SUPER ANNOYING, why is this not drawing?
		 	dc.drawBitmap(50, 150, self._gpsIcon);
		}
		if (app.controller.getActivityEnabled() == true) {
		 	self._activityIcon = WatchUi.loadResource(Rez.Drawables.ActivityIconSmall);
		 	// This is SUPER ANNOYING, why is this not drawing?
		 	dc.drawBitmap(60, 150, self._activityIcon);

		}
    }

	function getSteakItems(steakList, steaks) {
		var items = new[steaks.size()];
		
		for(var i = 0; i < steaks.size(); i++) {
			//it's not really possible to setup parameters for sub-items in a drawable in the XML
			//so instead we pass all params to the list, and then when we create the list items we just fetch that set
			//of params and use it
			items[i] = new SteakListItem(steaks[i], steakList.getParams());  
		}
	
		return items;	
	}

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    
    	var steakList = View.findDrawableById("steakList");
	 	steakList.setMaxItems(app.controller.getTotalSteaks());
	 	steakList.setItems(self.getSteakItems(steakList, app.controller.getSteaks()));


		// Configuration related
	 	
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
