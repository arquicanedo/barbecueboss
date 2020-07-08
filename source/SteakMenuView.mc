using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;
using Toybox.Application;


class SteakMenuView extends WatchUi.View {

	hidden var app;
	hidden var _gpsIcon;
	hidden var _activityIcon; 
	hidden var _gpsX;
	hidden var _gpsY;
	hidden var _activityX;
	hidden var _activityY;
	hidden var _timeLabel;
	hidden var _timeProgressBar;
	
    function initialize() {
        View.initialize();
        self._timeProgressBar = new TimeProgressBar(Graphics.COLOR_LT_GRAY, 100, 6, 8, 5);
        //self._timeProgressBar.progress(0.75);
        self.app = Application.getApp();
    }

    // Load your resources here
    function onLayout(dc) {
	 	View.setLayout(Rez.Layouts.SteakMenuLayout(dc));
    }

	function getSteakItems(steakList, steaks) {
		var items = new[steaks.size()];
		
		var params = steakList.getParams();
		
		if(params.hasKey(:identifier)) {
			params.remove(:identifier);
		}
		
		for(var i = 0; i < steaks.size(); i++) {
			//it's not really possible to setup parameters for sub-items in a drawable in the XML
			//so instead we pass all params to the list, and then when we create the list items we just fetch that set
			//of params and use it
			items[i] = new SteakListItem(steaks[i], params);  
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

		self._timeLabel = View.findDrawableById("timeLabel");
		
		var list = View.findDrawableById("steakList");
        if(self.app.controller.getGpsEnabled()) {
        	self._gpsIcon = WatchUi.loadResource(Rez.Drawables.GpsIconSmall);
        	self._gpsX = list.getParams().get(:gpsX);
        	self._gpsY = list.getParams().get(:gpsY);
        }
        else {
        	self._gpsIcon = null;
        	self._gpsX = null;
        	self._gpsY = null;
        }
        
        if(self.app.controller.getActivityEnabled()) {
        	self._activityIcon = WatchUi.loadResource(Rez.Drawables.ActivityIconSmall);
        	self._activityX = list.getParams().get(:activityX);
        	self._activityY = list.getParams().get(:activityY);
        }
        else {
        	self._activityIcon = null;
        	self._activityX = null;
        	self._activityY = null;
        }

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
    	self.drawSettingsIcons(dc);
    	self.drawTime(dc);
    	self.drawTimeProgressBar(dc);
    }
    
    // Draws the progress for the selected steak
    function drawTimeProgressBar(dc) {
    	var selectedSteak = (app.controller.getSteaks())[app.controller.getSelectedSteak()];
    	if (selectedSteak.getStatus() == app.controller.COOKING) {
	    	self._timeProgressBar.progress(1 - (selectedSteak.getTargetSeconds().toFloat()/selectedSteak.getTimeout().toFloat()));
	    	self._timeProgressBar.draw(dc);
    	}
    }
    
    function drawTime(dc) {
    	if(null != self._timeLabel) {
    	
    		//get the time, format as a string
    		var time = System.getClockTime();
    		var timeStr = Lang.format("$1$:$2$", [time.hour.format("%02d"), time.min.format("%02d")]);
    		
    		//update the label text and center it's location based on the screen width and the width of the new time string
    		self._timeLabel.setText(timeStr);
    		self._timeLabel.setJustification(Graphics.TEXT_JUSTIFY_CENTER);
    		//self._timeLabel.setLocation((dc.getWidth() / 2) - (dc.getTextWidthInPixels(timeStr, self._timeLabel. self._timeLabel.locY);
    	}
    }
    
    function drawSettingsIcons(dc) {
	 	if (null != self._gpsIcon) {
		 	dc.drawBitmap(_gpsX, _gpsY, self._gpsIcon);
		 	//System.println("****************************************** GPS ************");
		}
		if (null != self._activityIcon) {
		 	dc.drawBitmap(_activityX, _activityY, self._activityIcon);
		 	//System.println("****************************************** Activity ************");
		} 
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	//if the view isn't being displayed, there's no point in handling the timer callbacks and wasting memory
    	app.controller.timerChanged.reset();
    }
}
