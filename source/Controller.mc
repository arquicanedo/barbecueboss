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
	public var myTimer;
	
	//the total number of seconds running, and the number of seconds elapsed since start
    public var elapsedSeconds;
	public var totalSeconds;
	
	//the flip timer value
	hidden var targetSeconds;
		
	hidden var paused;
	hidden var cancelled;
	
	//current cooking / machine state
	hidden var status;
	
	//the FIT activity session being used
	hidden var session;
	hidden var flipVibrator = [ new WatchUi.Attention.VibeProfile(75, 2500) ];
	
	//"events"
	public var timerChanged = new SimpleCallbackEvent("timerChanged");
	public var flipChanged = new SimpleCallbackEvent("flipChanged");
	
	public enum {
	    	COOKING, 
	    	USER_FLIPPING,
	    	//AUTO_FLIPPING,
	    	SAVING,
	    	DISCARDING,
	    	EXIT
	}
    
    function initialize() {
		System.println("initializing controller...");
		myTimer = new Timer.Timer();
		paused = false;
		cancelled = false;
		self.setStatus(COOKING);
		
		self.initializeGPS();
		self.initializeActivityRecording();
	}
    
    function dispose() {
    
    }
    
    function getStatus() {
    	return self.status;
    }
    
    private function setStatus(status) {
    	self.status = status;
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
    
    function flipMeat() {
    	
    	Attention.vibrate(self.flipVibrator);
    	
    	totalFlips++;
    	self.flipChanged.emit(totalFlips);
    	
    	System.println("The meat has been flipped");
    	
    	self.resetTimer(targetSeconds);
    	self.initializeSystemTimer(targetSeconds);
    	self.session.addLap();
    }
    
    // Goes back to the user selection of time for a new flip
    function resetTimer(seconds) {
    	elapsedSeconds = 0;
    	totalSeconds = seconds;
    	targetSeconds = seconds;
    }

    // initializes System Timer
    function initializeSystemTimer(seconds) {
    	self.setStatus(COOKING);
        self.myTimer.stop();
        
     	resetTimer(seconds);
    	
    	self.myTimer.start(method(:timerCallback), 1000, true);
    	self.timerChanged.emit([self.elapsedSeconds, self.totalSeconds]);
    }
        
    function initializeFlip() {
    	totalFlips = 0;
    	self.flipChanged.emit(totalFlips);
    }
    
	function initializeTimer(seconds) {
		initializeSystemTimer(seconds);
		initializeFlip();
	}
	
	function timerStop() {
		self.myTimer.stop();
	}
	
	function timerResume() {
	    self.myTimer.start(method(:timerCallback), 1000, true);
	}
	
	function timerRestart() {
	    self.initializeSystemTimer(targetSeconds);
	}
    
    function isPaused() {
    	return self.paused;
    }
    
    function isCancelled() {
    	return self.cancelled;
    }
    
    function timerCallback() {

        self.printGPS();        
        self.timerChanged.emit([self.elapsedSeconds, self.totalSeconds]);
        
    	// Stop the timer after the 00:00 has been reached and get confirmation to continue
    	if (totalSeconds <= 0) {
    		
    		if(Attention has :vibrate) {
    			Attention.vibrate(self.flipVibrator);
    			//Attention.playTone(Attention.TONE_CANARY);
    		}
    		
    		//self.setStatus(AUTO_FLIPPING);
    		self.timerStop();
    		//self.recordingStop();
    	}
    	else {
    	    elapsedSeconds = elapsedSeconds + 1;
    		totalSeconds = totalSeconds - 1;
    	}
	}
	
	function decideSelection() {
		if (self.getStatus() == COOKING) {
			System.println("Selection received @ COOKING, going to USER_FLIPPING");
			self.timerStop();
			self.recordingStop();
			self.setStatus(USER_FLIPPING);
		}
		else if (self.getStatus() == USER_FLIPPING) {
			System.println("Selection received @ USER_FLIPPING, going to COOKING");
			self.timerRestart();
			self.recordingStart();
			self.setStatus(COOKING);
			self.flipMeat();
		}
		/*else if (self.getStatus() == AUTO_FLIPPING) {
			System.println("Selection received @ AUTO_FLIPPING, going to COOKING");
			self.timerRestart();
			self.recordingStart();
			self.status = COOKING;
			self.flipMeat();
		}*/
	}
	
	function decideCancellation() {
		if (self.getStatus() == COOKING) {
			System.println("Back received @ COOKING, going to SAVING");
			self.timerStop();
			self.recordingStop();
			self.setStatus(SAVING);
		}
		else if (self.getStatus() == USER_FLIPPING) {
			System.println("Back received @ USER_FLIPPING, going to COOKING");
			self.timerResume();
			self.recordingStart();
			self.setStatus(COOKING);
		}
		/*else if (self.getStatus() == AUTO_FLIPPING) {
			System.println("Back received @ AUTO_FLIPPING, going to SAVING");
			self.timerStop();
			self.recordingStop();
			self.status = SAVING;
		}*/

	}
}
