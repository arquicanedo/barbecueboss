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
	public var steak_selection;
	public var steak_status;
	public var total_steaks;
	public var steak_timeout;
	
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
		
		self.total_steaks = 4;
		self.steak_selection = 0;
		self.steak_status = new [self.total_steaks];
		self.status = new [self.total_steaks];
		self.elapsedSeconds = new [self.total_steaks];
		self.totalSeconds = new [self.total_steaks];
		self.targetSeconds = new [self.total_steaks];
		self.totalFlips = new [self.total_steaks];
		self.steak_timeout = new [self.total_steaks];

		
		// Timer always running. 
		self.myTimer = new Timer.Timer();
		self.myTimer.start(method(:timerCallback), 1000, true);
		
		
		for (var i=0; i<self.total_steaks; i+=1) {
			self.steak_status[i] = false;
			self.totalFlips[i] = 0;
			self.setStatus(i, INIT);
			self.totalSeconds[i] = 0;
			self.targetSeconds[i] = 0;
		}
		
		// Activity Recording. TODO: Investigate what custom data types we can come up with for grilling.
		// For now every "flip" is a lap.
		self.recordingStart();
		
	}
    
    function dispose() {
    
    }
    
    function getStatus(i) {
    	return self.status[i];
    }
    
    private function setStatus(i, status_target) {
    	self.status[i] = status_target;
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
    	
    	self.totalFlips[i]++;
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
    	self.setStatus(i, COOKING);
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

        
        System.println("Steak target seconds");
        System.println(self.targetSeconds);
        
        // Manage the timers
        for (var i = 0; i<self.total_steaks; i+=1) {
			// Decrease cooking steak timers
        	if (self.getStatus(i) == COOKING) {
        		self.targetSeconds[i] -= 1;
				// Reset timers if expired
				if (self.targetSeconds[i] < 0) {
					self.targetSeconds[i] = self.steak_timeout[i];
					self.flipMeat(i);
				}
        	}
        }
        self.timerChanged.emit([self.elapsedSeconds, self.totalSeconds]);
	}
	
	
	function decideSelection() {
		var i = self.steak_selection;
		var timeout = self.steak_timeout[i];
		System.println("Deciding Selection on steak");
		System.println(i);
		System.println(timeout);
		if (self.getStatus(i) == INIT) {
			self.setStatus(i, COOKING);
			System.println("Status set to COOKING");
			self.targetSeconds[i] = timeout;
			
			if(Attention has :vibrate) {
				Attention.vibrate(self.startSteakVibrator);
			}
					
		}
		else if (self.getStatus(i) == COOKING) {
			self.targetSeconds[i] = timeout;
			self.flipMeat(i);
		}
	}

	
	function decideCancellation() {
		var i = self.steak_selection;
		System.println("Deciding Cancellation on steak");
		System.println(i);

	}
	
	
	function nextSteak() {
		self.steak_selection = (self.steak_selection + 1 ) % self.total_steaks;
		System.println("Steak selection");
		System.println(self.steak_selection);
	}
	
	function previousSteak() {
		self.steak_selection = (self.steak_selection - 1 ) % self.total_steaks;
		if (self.steak_selection < 0) {
			self.steak_selection = self.total_steaks - 1;
		}
		System.println("Steak selection");
		System.println(self.steak_selection);
	}
}
