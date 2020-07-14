using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;
using Toybox.Application;


class SteakMenuView extends WatchUi.View {

	hidden var _app;
	hidden var _gpsIcon;
	hidden var _activityIcon; 
	hidden var _gpsX;
	hidden var _gpsY;
	hidden var _activityX;
	hidden var _activityY;
	hidden var _timeLabel;
	hidden var _progressBarY;
	hidden var _font;
	hidden var _etaX;
	hidden var _etaY;
	hidden var _timeProgressBar;
	
    function initialize() {
        View.initialize();
        
        _app = Application.getApp();	
    }

	function dispose() {
		//_app = null;
		_gpsIcon = null;
		_activityIcon = null;
		_gpsX = null;
		_gpsY = null;
		_activityX = null;
		_activityY = null;
		_timeLabel = null;
		_timeProgressBar = null;
		
		var steakList = View.findDrawableById("steakList");
		steakList.resetItems();
	
		_app.controller.timerChanged.reset();
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
    
    	var list = View.findDrawableById("steakList");
	 	list.setMaxItems(_app.controller.getTotalSteaks());
	 	list.setItems(self.getSteakItems(list, _app.controller.getSteaks()));

		self._timeLabel = View.findDrawableById("timeLabel");
		
        if(_app.controller.getGpsEnabled()) {
        
        	if(null == _gpsIcon) {
	        	self._gpsIcon = WatchUi.loadResource(Rez.Drawables.GpsIconSmall);
	        	self._gpsX = list.getParams().get(:gpsX);
	        	self._gpsY = list.getParams().get(:gpsY);
	        }
        }
        else {
        	self._gpsIcon = null;
        	self._gpsX = null;
        	self._gpsY = null;
        }
        
        if(_app.controller.getActivityEnabled()) {
        
        	if(null == self._activityIcon) {
	        	self._activityIcon = WatchUi.loadResource(Rez.Drawables.ActivityIconSmall);
	        	self._activityX = list.getParams().get(:activityX);
	        	self._activityY = list.getParams().get(:activityY);
	        }
        }
        else {
        	self._activityIcon = null;
        	self._activityX = null;
        	self._activityY = null;
        }
        
        self._progressBarY = null == list.getParams().get(:progressBarY) ? 8 : list.getParams().get(:progressBarY);
        self._font = null == list.getParams().get(:font) ? Graphics.FONT_TINY : list.getParams().get(:font);
        
		// etaX == targetOriginX for alignment
        self._etaX = null == list.getParams().get(:targetOriginX) ? 90 : list.getParams().get(:targetOriginX);
		self._etaY = null == list.getParams().get(:etaY) ? 0 : list.getParams().get(:etaY);

		// Configuration related
	 	
    	//register for timer changed "events"
		_app.controller.timerChanged.on(self.method(:onTimerChanged));
    }
    
    //handle timer changed event
    function onTimerChanged(sender, value) {
    	Toybox.WatchUi.requestUpdate();
    }
    
    // Update the view
    function onUpdate(dc) {
    	View.onUpdate(dc);
    	
    	var selectedSteak = (_app.controller.getSteaks())[_app.controller.getSelectedSteak()];
    	
    	self.drawSettingsIcons(dc);
    	self.drawTime(dc);
    	self.drawTimeProgressBar(dc, selectedSteak);
    	self.drawETA(dc, selectedSteak);
    }
    
    // Draws the progress for the selected steak
    function drawTimeProgressBar(dc, selectedSteak) {
    	var timeProgressBar = new TimeProgressBar(Graphics.COLOR_BLUE, 100, 6, _progressBarY, 5);
    	if (selectedSteak.getStatus() == _app.controller.COOKING) {
	    	timeProgressBar.progress(selectedSteak.getProgress());
	    	timeProgressBar.draw(dc);
    	}
    }
    
    // Draws the ETA selected steak if using TOTAL_TIME
    function drawETA(dc, selectedSteak) {
    	if (selectedSteak.getCookingMode() == selectedSteak.TOTAL_TIME) {
	    	if (selectedSteak.getStatus() == _app.controller.COOKING) {
	    		var list = View.findDrawableById("steakList");    	
	    		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		    	dc.drawText(self._etaX, self._etaY, self._font, selectedSteak.getETAString(), Graphics.TEXT_JUSTIFY_LEFT);
	    	}
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
    	dispose();
    }
}
