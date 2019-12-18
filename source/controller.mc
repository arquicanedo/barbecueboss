using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;

class Controller {

	hidden var flipped;
	
	public var myTimer;
	hidden var myTimerText;
	hidden var myFlipText;
    hidden var myMinutes;
    hidden var myFlip;
    hidden var myCookingStatusText;
    hidden var myCookingStatus;
    hidden var elapsedSeconds;
	hidden var totalSeconds;

	hidden var targetMinutes;
	hidden var app;
	hidden var paused;
	hidden var cancelled;
	hidden var status;
	
	enum {
    	COOKING, 
    	USER_FLIPPING,
    	AUTO_FLIPPING,
    	SAVING,
    	EXIT
    }
	
	function initialize() {
		System.println("initializing controller...");
		myTimer = new Timer.Timer();
		paused = false;
		cancelled = false;
		status = COOKING;
	}
    
    function flipMeat() {
    	flipped = flipped + 1;
    	System.println("The meat has been flipped");
    	self.resetTimer(targetMinutes);
    	self.initializeSystemTimer(targetMinutes);
    }
    
    function setFlipText() {
    	myFlip = Lang.format(
		    "$1$ $2$", ["Flip: ", flipped.format("%d")]);
    	myFlipText = new WatchUi.Text({
            :text=>myFlip,
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>50
        });

    }
    
    function setCookingStatusText(status) {
    	myCookingStatus = Lang.format("$1$", [status]);
    	myCookingStatusText = new WatchUi.Text({
    	    :text=>myCookingStatus,
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>20
        });
    }
    
    function updateCookingStatusText() {
    	if (self.status == COOKING) {
			self.setCookingStatusText("Cooking");
		}
		else if (self.status == USER_FLIPPING) {
			self.setCookingStatusText("Confirm flip");
		}
		else if (self.status == AUTO_FLIPPING) {
			self.setCookingStatusText("Another flip?");
		}
		else if (self.status == SAVING) {
			self.setCookingStatusText("Save?");
		}
    }
    
    // Goes back to the user selection of time for a new flip
    function resetTimer(minutes) {
    	elapsedSeconds = 0;
    	totalSeconds = minutes*60;
    	targetMinutes = minutes;
    }
    
    function setTimerText() {
        var zero = 0;
        var actualMinutes = elapsedSeconds / 60;
        var actualSeconds = elapsedSeconds % 60;
        
		var reverseMinutes = totalSeconds / 60;
		var reverseSeconds = totalSeconds % 60;
		
		var color = Graphics.COLOR_WHITE;
    	if (totalSeconds <= 20 && totalSeconds > 10) {
    		color = Graphics.COLOR_ORANGE;
    	}
    	else if (totalSeconds <= 10 && totalSeconds >= 0) {
    		color = Graphics.COLOR_RED;
    	} 
    	
       	myMinutes = Lang.format(
		    "$1$:$2$",
    		[reverseMinutes.format("%02d"), reverseSeconds.format("%02d")]);
    	
        myTimerText = new WatchUi.Text({
            :text=>myMinutes,
            :color=>color,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    // initializes System Timer
    function initializeSystemTimer(minutes) {
        System.println(minutes);
     	self.myTimer.stop();
    	self.myTimer.start(method(:timerCallback), 1000, true);
     	System.println("Resetting system timer");
		resetTimer(minutes);
        self.setTimerText();    
    }
    
    function initializeFlip() {
    	flipped = 0;
    	self.setFlipText();
    }
    
	function initializeTimerView(minutes) {
		initializeSystemTimer(minutes);
		initializeFlip();
	}
	
	function timerStop() {
		self.myTimer.stop();
	}
	
	function timerResume() {
	    self.myTimer.start(method(:timerCallback), 1000, true);
	}
	
	function timerRestart() {
	    self.initializeSystemTimer(targetMinutes);
	}
    
    
    function drawTimer(dc) {
    	System.println("drawTimer...");
    	self.setFlipText();
		self.setTimerText();
		self.updateCookingStatusText();
		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        
        myTimerText.draw(dc);
        myFlipText.draw(dc);
        myCookingStatusText.draw(dc);        
    }
    
    
    function tick() {
        System.println("Tick...");
    	// Stop the timer after the 00:00 has been reached and get confirmation to continue
    	if (totalSeconds <= 0) {
    		status = AUTO_FLIPPING;
    		self.timerStop();
    	}
    	else {
    	    elapsedSeconds = elapsedSeconds + 1;
    		totalSeconds = totalSeconds - 1;
    	}
    	Toybox.WatchUi.requestUpdate();
    }
    
    function isPaused() {
    	return self.paused;
    }
    
    function isCancelled() {
    	return self.cancelled;
    }
    
	 
    function timerCallback() {
    	self.tick();
	}
	
	function saveActivity() {
		System.println("TODO: saving activity...");
	}
	
	function decideSelection() {
		if (self.status == COOKING) {
			System.println("Selection received, going to USER_FLIPPING");
			self.timerStop();
			self.status = USER_FLIPPING;
		}
		else if (self.status == USER_FLIPPING) {
			System.println("Selection received, going to COOKING");
			self.timerRestart();
			self.status = COOKING;
			self.flipMeat();
		}
		else if (self.status == AUTO_FLIPPING) {
			System.println("Selection received, going to COOKING");
			self.timerRestart();
			self.status = COOKING;
			self.flipMeat();
		}
		else if (self.status == SAVING) {
			System.println("Selection received, going to EXIT");
			self.saveActivity();
			self.status = EXIT;
		}
		Toybox.WatchUi.requestUpdate();
	}
	
	function decideCancellation() {
		if (self.status == COOKING) {
			System.println("Back received, going to SAVING");
			self.timerStop();
			self.status = SAVING;
		}
		else if (self.status == USER_FLIPPING) {
			System.println("Back received, going to COOKING");
			self.timerResume();
			self.status = COOKING;
		}
		else if (self.status == AUTO_FLIPPING) {
			System.println("Back received, going to SAVING");
			self.timerStop();
			self.status = SAVING;
		}
		else if (self.status == SAVING) {
			System.println("Back received, going to COOKING");
			self.timerResume();
			self.status = COOKING;
		}
		Toybox.WatchUi.requestUpdate();		
	}

}
