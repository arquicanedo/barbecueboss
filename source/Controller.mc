using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;
using Toybox.Position;
using Toybox.ActivityRecording;

class Controller {


	hidden var app;

	//total number of flips performed
	public var totalFlips;
	
	//the 1 second timer driving things
	// Looks like there is support for only *three* timers https://forums.garmin.com/developer/connect-iq/f/discussion/165057/too-many-timers-error
	public var myTimer;
	
	//the total number of seconds running, and the number of seconds elapsed since start
    public var elapsedSeconds;
	public var totalSeconds;
	
	//the flip timer value
	public var targetSeconds;
		
	hidden var paused;
	hidden var cancelled;
	
	//current cooking / machine state
	hidden var status;
	
	//the FIT activity session being used
	hidden var session;
	
	//vibration profiles set below conditionally if the device supports them
	hidden var flipVibrator;
	hidden var startSteakVibrator;
	
	//"events"
	public var timerChanged = new SimpleCallbackEvent("timerChanged");
	public var flipChanged = new SimpleCallbackEvent("flipChanged");
	
	
	// Steak menu related
//	public var steak_selection;
	public var total_steaks;
//	public var steak_timeout;
	
	hidden var steaks;
	
	public enum {
			INIT,
	    	COOKING, 
	    	USER_FLIPPING,
	    	//AUTO_FLIPPING,
	    	SAVING,
	    	DISCARDING,
	    	EXIT
	}
    
    function initialize() {
		System.println("initializing controller...");
		paused = false;
		cancelled = false;

		if(Attention has :vibrate){
			self.flipVibrator = [ new WatchUi.Attention.VibeProfile(75, 2500) ];
			self.startSteakVibrator = [ new WatchUi.Attention.VibeProfile(50, 500) ];
		} 
		
		self.initializeGPS();
		self.initializeActivityRecording();
		
		self.total_steaks = self.calculateMaxSteaks();
		self.steaks = new [self.total_steaks];
		
		// Timer always running. 
		self.myTimer = new Timer.Timer();
		self.myTimer.start(method(:timerCallback), 1000, true);
		
	
		for(var i = 0; i < self.total_steaks; i++) {
			self.steaks[i] = new SteakEntry(Lang.format("Steak $1$", [i + 1]));
		
			if(i == 0) {
				self.steaks[i].setSelected(true);
			}
		}
			
		// Activity Recording. TODO: Investigate what custom data types we can come up with for grilling.
		// For now every "flip" is a lap.
		self.recordingStart();
		
	}
    
    function dispose() {
    
    }
    
    function getSteaks() {
    	return steaks;
    }
    function getTotalSteaks() {
    	return self.total_steaks;
    }
    
    function getStatus(i) {
    	return self.steaks[i].getStatus();
    }
    
	hidden function setStatus(idx, status) {
    	self.steaks[idx].setStatus(status);
    }
    
    // https://forums.garmin.com/developer/connect-iq/f/discussion/6626/position-accuracy-is-always-position-quality_last_known/44227#44227	
    function onPosition(info) {
    	System.println("GPS Acc: " + info.accuracy);
	    System.println("GPS Position " + info.position.toGeoString( Position.GEO_DEG ) );
	}
    
	function initializeGPS() {
		System.println("Initializing GPS sensing.......");
	    Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method( :onPosition ) );
	}
	
	function printGPS() {
	    var gpsinfo = Position.getInfo();
		System.println(Lang.format("GPS Acc: $1$ position: $2$", [
			gpsinfo.accuracy, 
			gpsinfo.position.toGeoString( Position.GEO_DM )
		]));
	}
	
	// https://forums.garmin.com/developer/connect-iq/f/q-a/171125/state-of-session-after-save/922655#922655
	// https://developer.garmin.com/connect-iq/api-docs/
	function initializeActivityRecording() {
		self.createSession();
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
			System.println("ActivityRecording session started");
			self.session.start();
		}
	}
	
	function recordingStop() {
		if (self.session != null && self.session.isRecording()) {
			System.println("ActivityRecording session stopped");
			self.session.stop();
		}
	}
	
	function recordingSave() {
		if (self.session != null && self.session.isRecording()) {
			System.println("ActivityRecording session saved !!!!!!!!!!!!!!!!!");
			self.session.save();
			session = null;
		}
	}
	
	function recordingDiscard() {
		if (self.session != null) {
			System.println("ActivityRecording session discarded");
			self.session.discard();
			session = null;
		}	
	}
	
	
    // ******* THIS WILL BE GONE EVENTUALLY ********/
    function flipMeat(i) {
    
    	if(Attention has :vibrate) {
    		Attention.vibrate(self.flipVibrator);
    	}
    	
    	self.steaks[i].setTotalFlips(self.steaks[i].getTotalFlips() + 1);
		self.session.addLap();    	
    }

    
    // Goes back to the user selection of time for a new flip
    function resetTimer(i, seconds) {
    	System.println("resetTimer for");
    	System.println(seconds);
    	elapsedSeconds[i] = 0;
    	totalSeconds[i] = seconds;
    	targetSeconds[i] = seconds;
    }

    // initializes System Timer
    function initializeSystemTimer(i, seconds) {
    	self.setStatus(i, Controller.COOKING);
        self.myTimer.stop();
        
     	resetTimer(i, seconds);
    	
    	self.myTimer.start(method(:timerCallback), 1000, true);
    	self.timerChanged.emit([self.elapsedSeconds[i], self.totalSeconds[i]]);
    }
        
    function initializeFlip(i) {
    	totalFlips[i] = 0;
    	self.flipChanged.emit(totalFlips[i]);
    }
    
	function initializeTimer(i, seconds) {
		initializeSystemTimer(i, seconds);
		//initializeFlip();
	}
	
	function timerStop(i) {
		self.myTimer.stop();
	}
	
	function timerResume(i) {
	    self.myTimer.start(method(:timerCallback), 1000, true);
	}
	
	function timerRestart(i) {
	    self.initializeSystemTimer(i, targetSeconds[i]);
	}
    
    function isPaused() {
    	return self.paused;
    }
    
    function isCancelled() {
    	return self.cancelled;
    }
    /************** UNTIL HERE ***********/
    
    
    function timerCallback() {
		System.println("timerCallback");
        self.printGPS();        
        
        // Manage the timers
        for (var i = 0; i < self.total_steaks; i+=1) {
			// Decrease cooking steak timers
        	if (self.steaks[i].getStatus() == COOKING) {
        		
        		var targetSeconds = self.steaks[i].getTargetSeconds() - 1;
        		
				// Reset timers if expired
				if (targetSeconds < 0) {
					self.steaks[i].setTargetSeconds(self.steaks[i].getTimeout());
					self.flipMeat(i);
				} 
				else {
					self.steaks[i].setTargetSeconds(targetSeconds);
				}
				
        	}
        }
        
        self.timerChanged.emit([self.elapsedSeconds, self.totalSeconds]);
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
		System.println("Deciding Selection on steak");
		System.println(i);
		System.println(timeout);
		if (self.getStatus(i) == INIT) {
			if (timeout > 0) {
				self.setStatus(i, COOKING);
				System.println("Status set to COOKING");
				self.steaks[i].setTimeout(timeout);
				
				if(Attention has :vibrate) {
					Attention.vibrate(self.startSteakVibrator);
				}
			}
			else {
				self.setStatus(i, INIT);
				System.println("The user picked 0 minutes 0 seconds. Not legal");
			}
					
		}
		else if (self.getStatus(i) == COOKING) {
			self.steaks[i].setTimeout(timeout);
			self.flipMeat(i);
		}
	}

	function decideCancellation() {
		var i = self.getSelectedSteak();
		System.println("Deciding Cancellation on steak");
		System.println(i);

	}
	
	function nextSteak() {
		var i = self.getSelectedSteak();
		
		steaks[i].setSelected(false);
		steaks[(i + 1) % self.total_steaks].setSelected(true);

		System.println(Lang.format("Selected steak $1$", [(i + 1) % self.total_steaks]));
	}
	
	function previousSteak() {
		var i = self.getSelectedSteak();
		
		steaks[i].setSelected(false);
		steaks[(i - 1) % self.total_steaks].setSelected(true);

		System.println(Lang.format("Selected steak $1$", [(i - 1) % self.total_steaks]));
	}
	
	function calculateMaxSteaks() {
    	
		//this can be overridden per family/device in the string resource for that device
    	return WatchUi.loadResource(Rez.Strings.maxSteaks).toNumber();    	
    }
    
}
