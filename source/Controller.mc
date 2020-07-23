using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;
using Toybox.Time;
using Toybox.Position;
using Toybox.ActivityRecording;

class Controller {

	hidden var app;
	hidden var bluetoothController;
	
	//settings for all devices
	hidden static var GPS_ENABLED_KEY = "gps";
	hidden static var ACTIVITY_ENABLED_KEY = "activity";
	hidden static var FOOD_TYPE_KEY = "type";
	hidden static var FOOD_TIME_KEY = "time";
	hidden static var TOTAL_TIME_KEY = "total";
	
	//settings for devices with bluetooth support
	(:btle)hidden static var MEAT_PROBE_ENABLED_KEY = "meatProbeEnabled";
	(:btle)hidden static var MEAT_PROBE_UNIT_KEY = "meatProbeUnit";
	
	//settings for devices that support smoking operations
	(:smoke)hidden static var WATER_CHECK_TIME = "waterCheck";
	(:smoke)hidden static var SMOKE_CHECK_TIME = "smokeCheck";
	(:smoke)hidden static var TEMP_CHECK_TIME = "tempCheck";
	(:smoke)hidden static var SMOKER_TIME = "smokerTime";
	
	//total number of flips performed
	public var totalFlips;
	
	//the 1 second timer driving things
	// Looks like there is support for only *three* timers https://forums.garmin.com/developer/connect-iq/f/discussion/165057/too-many-timers-error
	public var myTimer;
	
	//the FIT activity session being used
	hidden var session = null;
	
	//vibration profiles set below conditionally if the device supports them
	hidden var flipVibrator;
	hidden var startSteakVibrator;
	
	//"events"
	public var timerChanged = new SimpleCallbackEvent("timer");
	public var flipChanged = new SimpleCallbackEvent("flip");
	
	(:smoke)public var smokeSettingsChanged = new SimpleCallbackEvent("smoke");
	
	// Steak menu related
	public var total_steaks;
	hidden var steaks;
	
	// Settings menu
	public var total_settings;
	hidden var settings;
	
	// Data Store
	public var storage;
	
	hidden var _smoking = false;
	
	// This is a hack. I don't know how to do it properly because the BitMapFactory returns the bitmap but I need the index
	public var lastSelectedFoodType = null;
	
	hidden var foodCounter = {
		SteakEntry.BEEF => 0,
		SteakEntry.CHICKEN => 0,
		SteakEntry.CORN => 0,
		SteakEntry.BURGER => 0,
		SteakEntry.BAKE => 0,
		SteakEntry.FISH => 0,
		SteakEntry.DRINK => 0
	};
	
	
	public enum {
			INIT,
	    	COOKING, 
	    	SAVING
	}
    
    function initialize(app) {
		//System.println("initializing controller...");

		self.app = app;
		self.storage = new DataStore(app);
		
		if(Attention has :vibrate){
			self.flipVibrator = [ new WatchUi.Attention.VibeProfile(50, 500) ];
			self.startSteakVibrator = [ new WatchUi.Attention.VibeProfile(50, 500) ];
		} 
		
		self.initializeDefaultSettings();
		
		self.initializeGPS();
		self.initializeActivityRecording();
		
		self.total_steaks = self.calculateMaxSteaks();
		self.steaks = new [self.total_steaks];
		
		// Timer always running. 
		self.myTimer = new Timer.Timer();
		self.myTimer.start(method(:timerCallback), 1000, true);

		for(var i = 0; i < self.total_steaks; i++) {
			self.steaks[i] = new SteakEntry(Lang.format("$1$", [i + 1]), self.getLastFoodType(i));
		
			if(i == 0) {
				self.steaks[i].setSelected(true);
			}
		}

		// Activity Recording. TODO: Investigate what custom data types we can come up with for grilling.
		// For now every "flip" is a lap.
		self.recordingStart();
		
		//check for bluetooth support in the build, initialize if it exists
		if(self has :initializeBluetooth) {
			self.initializeBluetooth();
		}
	}
    
    (:btle)
    function initializeBluetooth() {
    	TenergySolis.initialize();
    	self.bluetoothController = new BluetoothController();
    }
    
    (:btle)
    function getBluetoothController() {
    	return self.bluetoothController;
    }
    
    (:btle)
    function getMeatProbeUnit() {
    	return self.storage.getValue(MEAT_PROBE_UNIT_KEY);
    }
    
    (:btle)
    function getMeatProbeEnabled() {
    	return self.storage.getValue(MEAT_PROBE_ENABLED_KEY);
    }
    
    (:btle)
    function setMeatProbeUnit(unit) {
    	self.storage.setValue(MEAT_PROBE_UNIT_KEY, unit);
    	self.smokeSettingsChanged.emit(null);
    }
    
    (:smoke)
    function getWaterCheckTime() {
    	return self.storage.getValue(WATER_CHECK_TIME);
    }
    
    (:smoke)
    function setWaterCheckTime(time) {
    	self.storage.setValue(WATER_CHECK_TIME, time);
    	self.smokeSettingsChanged.emit(null);
    }
    
    (:smoke)
    function getTempCheckTime() {
    	return self.storage.getValue(TEMP_CHECK_TIME);
    }
    
    (:smoke)
    function setTempCheckTime(time) {
    	self.storage.setValue(TEMP_CHECK_TIME, time);
    	self.smokeSettingsChanged.emit(null);
    }
    
    (:smoke)
    function getSmokeCheckTime() {
    	return self.storage.getValue(SMOKE_CHECK_TIME);
    }
    
    (:smoke)
    function setSmokeCheckTime(time) {
    	self.storage.setValue(SMOKE_CHECK_TIME, time);
    	self.smokeSettingsChanged.emit(null);
    }

    (:btle)
    function setMeatProbeEnabled(enabled) {
    	self.storage.setValue(MEAT_PROBE_ENABLED_KEY, enabled);
    	
    	if(!enabled) {
    		self.bluetoothController.dispose();
    	}
    	else {
    		self.bluetoothController.initialize();
    	}
    	
    	self.smokeSettingsChanged.emit(null);
    }

    (:smoke)
    function startSmoker(dueTime) {
    	self.storage.setValue(SMOKER_TIME, dueTime.value());
    }
    
    function initializeDefaultSettings() {
    	var val = self.storage.getValue(GPS_ENABLED_KEY);
    	
    	if(null == val) {
    		self.storage.setValue(GPS_ENABLED_KEY, true);
    	}
    	
    	val = self.storage.getValue(ACTIVITY_ENABLED_KEY);
    	if(null == val) {
    		self.storage.setValue(ACTIVITY_ENABLED_KEY, true);
    	}
    	
    	//has the build for the current device included things marked at (:btle) ? if so, initialize bluetooth
    	if($ has :BluetoothController) {
    		self.initializeBtleDefaultSettings();
	    }
	    
	    if(self has :initializeSmokerSettings) {
	    	self.initializeSmokerSettings();
	    }
    }
    
    (:smoke)
    function initializeSmokerSettings() {
    	
    	var val = self.storage.getValue(SMOKER_TIME);
    	
    	if(null == val) {
    		self.storage.setValue(SMOKER_TIME, 0);
    	}
    	
    	val = self.storage.getValue(WATER_CHECK_TIME);
    	if(null == val) {
    		self.storage.setValue(WATER_CHECK_TIME, 60 * 60);
    	} 
    	
    	val = self.storage.getValue(SMOKE_CHECK_TIME);
    	if(null == val) {
    		self.storage.setValue(SMOKE_CHECK_TIME, 45 * 60);
    	}
    	
    	val = self.storage.getValue(TEMP_CHECK_TIME);
    	if(null == val) {
    		self.storage.setValue(TEMP_CHECK_TIME, 45 * 60);
    	}
    }
    
    (:btle)
    function initializeBtleDefaultSettings() {
    	var val = self.storage.getValue(MEAT_PROBE_ENABLED_KEY);
    	if(null == val) {
    		self.storage.setValue(MEAT_PROBE_ENABLED_KEY, false);
    	}
    	
    	val = self.storage.getValue(MEAT_PROBE_UNIT_KEY);
    	if(null == val) {
    		self.storage.setValue(MEAT_PROBE_UNIT_KEY, TenergySolis.BluetoothDevice.TEMP_DEG_C);
    	}
    }
    
    function dispose() {
    	self.myTimer.stop();
    	
    	if(null != self.session) {
			self.session.stop();
		}
		
		self.disableGPS();
		// I couldn't find any documentation about the SimpleCallbackEvent. I wonder where I got this from.
		timerChanged.reset();
		flipChanged.reset();
    }
    
    function setActivityEnabled(enabled) {
    	self.storage.setValue(ACTIVITY_ENABLED_KEY, enabled);
    	if(!enabled) {
    		// The other option is to recordingDiscard but that may be abrupt for the exit conditions.
    		self.recordingStop();
    	}
    	else {
    		self.initializeActivityRecording();
    	}
    }
    
    function getActivityEnabled() {
    	return self.storage.getValue(ACTIVITY_ENABLED_KEY);
    }
    
    function getGpsEnabled() {
    	return self.storage.getValue(GPS_ENABLED_KEY);
    }
    
    function setGpsEnabled(enabled) {
    	self.storage.setValue(GPS_ENABLED_KEY, enabled);
    	if(!enabled) {
    		self.disableGPS();
    	} 
    	else {
    		self.initializeGPS();
    	}
    }
    
    function getSteaks() {
    	return self.steaks;
    }
    
    function getTotalSteaks() {
    	return self.total_steaks;
    }
	
    // https://forums.garmin.com/developer/connect-iq/f/discussion/6626/position-accuracy-is-always-position-quality_last_known/44227#44227	
    function onPosition(info) {
    	//System.println("GPS Acc: " + info.accuracy);
	    //System.println("GPS Position " + info.position.toGeoString( Position.GEO_DEG ) );
	}
    
	function initializeGPS() {
		
		if(self.getGpsEnabled()) {
			//System.println("Initializing GPS sensing.......");
	    	Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method( :onPosition ) );
	    }
	    else {
	    	System.println("GPS disabled by app settings.");
	    }
	}
	
	function disableGPS() {
		System.println("Stopping GPS sensing.......");
		Position.enableLocationEvents( Position.LOCATION_DISABLE, method( :onPosition ) );
	}
		
	// https://forums.garmin.com/developer/connect-iq/f/q-a/171125/state-of-session-after-save/922655#922655
	// https://developer.garmin.com/connect-iq/api-docs/
	function initializeActivityRecording() {
		if(self.getActivityEnabled()) {
			System.println("Activity recording enabled by app settings.");
			self.createSession();
		}
		/*else {
			System.println("Activity recording disabled by app settings.");
		}*/
	}
	
	function createSession() {
		self.session = ActivityRecording.createSession(
			{   // set up recording session
			    :name=>"Barbecue",                               // set session name
			    :sport=>ActivityRecording.SPORT_GENERIC,        // set sport type
			    :subSport=>ActivityRecording.SUB_SPORT_GENERIC  // set sub sport type
			});
	}
	
	function recordingStart() {
		if (self.session != null) {
			System.println("Session started");
			self.session.start();
		}
	}
	
	function recordingStop() {
		if (self.session != null && self.session.isRecording()) {
			System.println("session stopped");
			self.session.stop();
		}
	}
	
	function recordingSave() {
		if (self.session != null && self.session.isRecording()) {
			System.println("session saved");
			self.session.save();
			session = null;
		}
	}
	
	function recordingDiscard() {
		if (self.session != null) {
			System.println("session discarded");
			self.session.discard();
			session = null;
		}	
	}

    function flipMeat(i) {
    
    	if(Attention has :vibrate) {
    		Attention.vibrate(self.flipVibrator);
    	}
    	
    	self.steaks[i].setCurrentFlip(self.steaks[i].getCurrentFlip() + 1);
    	
    	if(null != self.session) {
			self.session.addLap();
		}
    }
    
	function timerStop(i) {
		self.myTimer.stop();
	}
	
	function timerResume(i) {
	    self.myTimer.start(method(:timerCallback), 1000, true);
	}
	        
	        
	// Manage the timers
    function timerCallback() {
        for (var i = 0; i < self.total_steaks; i+=1) {        	
			// Decrease cooking steak timers
        	if (self.steaks[i].getStatus() == COOKING) {
        	
        	    // Kill timer if we've exceeded the ETA when cooking in TOTAL_TIME mode
        	    if (steaks[i].getCookingMode() == SteakEntry.TOTAL_TIME) {
					var now = new Time.Moment(Time.now().value());
					if (now.greaterThan(self.steaks[i].getETA())) {
						steaks[i].reset();
						return;
					}
				}
	        	
        		if(self.steaks[i].getInitialized()) {
	        		var newTimeout = self.steaks[i].getTimeout() - 1;
					// Reset flip timeout if expired
					if (newTimeout < 0) {
						self.steaks[i].setTimeout(self.steaks[i].getTimePerFlip());
						self.flipMeat(i);
					} 
					else {
						self.steaks[i].setTimeout(newTimeout);
					}
				}
        	}
        }
        self.timerChanged.emit([]);
	}
	
	function getSelectedSteak() {
		for(var i = 0; i < self.total_steaks; i++) {
			if(self.steaks[i].getSelected()) {
				return i;
			}
		}
		
		return 0;
	}
	
	function decideSelection() {
		var i = self.getSelectedSteak();
		var timeout = self.steaks[i].getTimeout();
		var secsPerFlip = self.steaks[i].getTimeout();
		//System.println(Lang.format("Deciding Selection on steak $1$ for $2$ sec and $3$ seconds per flip", [i, timeout, secsPerFlip]));
		
		if (self.steaks[i].getStatus() == INIT) {
		
			if (timeout > 0) {
				self.steaks[i].setStatus(COOKING);
				
				if (self.steaks[i].getCookingMode() == SteakEntry.TOTAL_TIME) {
					self.steaks[i].setETA();
				}
							
				//System.println("Status set to COOKING");
				
				if(Attention has :vibrate) {
					Attention.vibrate(self.startSteakVibrator);
				}
				
				// Persist last set steak
				self.setLastTimeout(i, timeout);
				
			}
			else {
				self.steaks[i].setStatus(INIT);
				//System.println("The user picked 0 minutes 0 seconds. Not legal");
			}
					
		}
		else if (self.steaks[i].getStatus() == COOKING) {
			//if we are just now transitioning to cooking we don't want to count a flip yet.
			var initialized = self.steaks[i].getInitialized(); 
			self.setLastTimeout(i, timeout);
			self.steaks[i].setTimeout(timeout);
			
			if(initialized) {
				self.flipMeat(i);
			}
		}
	}

	function decideCancellation() {
		var i = self.getSelectedSteak();
		//System.println("Deciding Cancellation on steak");
		//System.println(i);
	}
	
	function nextSteak() {
		var i = self.getSelectedSteak();
		steaks[i].setSelected(false);
		steaks[(i + 1) % self.total_steaks].setSelected(true);
	}
	
	function previousSteak() {
		var i = self.getSelectedSteak();
		steaks[i].setSelected(false);
		var prevSteak = ((i - 1) % self.total_steaks);
		if(prevSteak < 0) {
			prevSteak = self.total_steaks - 1;
		}
		steaks[prevSteak].setSelected(true);
	}
	
	
	function getSelectedSetting() {
		for(var i = 0; i < self.total_settings; i++) {
			if(self.settings[i].getSelected()) {
				return i;
			}
		}
		
		return 0;
	}
	
	function setSettings(settings, total_settings) {
		self.total_settings = total_settings;
		self.settings = settings;
	}
	
	function nextSetting() {
		var i = self.getSelectedSetting();
		settings[i].setSelected(false);
		settings[(i + 1) % self.total_settings].setSelected(true);
	}
	
	function previousSetting() {
		var i = self.getSelectedSetting();
		settings[i].setSelected(false);
		var prevSetting = ((i - 1) % self.total_settings);
		if(prevSetting < 0) {
			prevSetting = self.total_settings - 1;
		}
		settings[prevSetting].setSelected(true);
	}

	function calculateMaxSteaks() {
		//this can be overridden per family/device in the string resource for that device
    	return WatchUi.loadResource(Rez.Strings.maxSteaks).toNumber();
    }
    
    function getLastFoodType(i) {
    	var key = FOOD_TYPE_KEY + i;
    	return self.storage.getValue(key);
    }
    
    function setLastFoodType(i, foodType) {
    	var key = FOOD_TYPE_KEY + i;
    	self.storage.setValue(key, foodType);
    }
    
    function getLastTimeout(i) {
    	var key = FOOD_TIME_KEY + i;
    	return self.storage.getValue(key);
    }
    
    function setLastTimeout(i, timeout) {
    	var key = FOOD_TIME_KEY + i;
    	self.storage.setValue(key, timeout);
    }
    
    function getLastTotalTime(i) {
    	var key = TOTAL_TIME_KEY + i;
    	return self.storage.getValue(key);
    }
    
    function setLastTotalTime(i, time) {
    	var key = TOTAL_TIME_KEY + i;
    	self.storage.setValue(key, time);
    }

    function getLastFlips(i) {
    	var key = "Flips" + i;
    	return self.storage.getValue(key);
    }
    
    function setLastFlips(i, flips) {
    	var key = "Flips" + i;
    	self.storage.setValue(key, flips);
    }

    function getTimeOfDay() {
		var myTime = new Time.Moment(Time.now().value());
		return myTime.value().toNumber();
    }
    
    function saveSmokeTimer() {    	
    	var currentTime = new Time.Moment(Time.now().value());
    	self.storage.setValue(SMOKER_TIME, currentTime.value().toNumber());
    		
    }
    
    function getSmokeTimer() {
    	return self.storage.getValue(SMOKER_TIME);
    }
    
    function steaksInitialized() {
    	for(var i = 0; i < self.total_steaks; i++) {
    		if (self.steaks[i].getInitialized() == true) {
    			return true;
    		}
    	}
    	return false;
    }
    
    
}
