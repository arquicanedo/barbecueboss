using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;


class Controller {

	hidden var flipped;
	
	public var myTimer;
	hidden var myTimerText;
	hidden var myFlipText;
    hidden var myMinutes;
    hidden var myFlip;
    hidden var elapsedSeconds;
	hidden var totalSeconds;

	hidden var targetMinutes;
	hidden var app;
	hidden var paused;
	
	function initialize() {
		System.println("initializing controller...");
		paused = false;
	}
    
    function flipMeat() {
    	flipped = flipped + 1;
    	System.println("The meat has been flipped");
    	self.resetTimer(targetMinutes);
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
    
    function resetTimer(minutes) {
    	elapsedSeconds = 0;
    	totalSeconds = minutes*60;
    	targetMinutes = minutes;
    	WatchUi.requestUpdate();
    	
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
    
    function initializeTimer(minutes) {
        System.println(minutes);
     
        myTimer = new Timer.Timer();
    	myTimer.start(method(:timerCallback), 1000, true);
     
     
		resetTimer(minutes);
    	flipped = 0;
    
        self.setFlipText();
        self.setTimerText();    
    }
    
    
    function countDown(dc) {
		System.println("countDown()");
	
    	self.setFlipText();
		self.setTimerText();
		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        myTimerText.draw(dc);
        myFlipText.draw(dc);
    }
    
    function tick() {
        elapsedSeconds = elapsedSeconds + 1;
    	totalSeconds = totalSeconds - 1;
    	WatchUi.requestUpdate();
    	
    	System.println("Tick...");

    	// Stop the timer after the 00:00 has been rendered
    	if (totalSeconds == 0) {
    		paused = true;
    		flipMeat();
    	}
    }
    
    function isPaused() {
    	return self.paused;
    }

	 
    function timerCallback() {
    	self.tick();
	}

}
