using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;


class Controller {

	hidden var flipped;
	
	hidden var myText;
    hidden var myMinutes;
    hidden var elapsedSeconds;
	hidden var totalSeconds;

	hidden var targetMinutes;
	hidden var app;
	
	function initialize() {
		System.println("initializing controller...");
	}
	
    function Arqui() {
    	System.println("Arqui......");
    }
    
    function flipMeat() {
    	flipped = flipped + 1;
    	System.println("The meat has been flipped");
    	self.initializeTimer(targetMinutes);
    }
    
    function initializeTimer(minutes) {
        System.println(minutes);
        var zero = 0;
        myMinutes = Lang.format(
		    "$1$:$2$",
    		[minutes.format("%02d"), zero.format("%02d")]);
    	elapsedSeconds = 0;
    	totalSeconds = minutes*60;
    	flipped = 0;
    	targetMinutes = minutes;
    	
    	myText = new WatchUi.Text({
            :text=>myMinutes,
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    	
    }
    
    function getTimerText() {
        return myText;
    }
    
    function countDown(dc) {
        var actualMinutes = elapsedSeconds / 60;
        var actualSeconds = elapsedSeconds % 60;
        
		var reverseMinutes = totalSeconds / 60;
		var reverseSeconds = totalSeconds % 60;
        
        myMinutes = Lang.format(
		    "$1$:$2$",
    		[reverseMinutes.format("%02d"), reverseSeconds.format("%02d")]);
    	
    	var color = Graphics.COLOR_WHITE;
    	if (totalSeconds <= 20 && totalSeconds > 10) {
    		color = Graphics.COLOR_ORANGE;
    	}
    	else if (totalSeconds <= 10 && totalSeconds >= 0) {
    		color = Graphics.COLOR_RED;
    	}    	
    		
    	myText = new WatchUi.Text({
            :text=>myMinutes,
            :color=>color,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        myText.draw(dc);
    }
    
    function tick(myTimer) {
        elapsedSeconds = elapsedSeconds + 1;
    	totalSeconds = totalSeconds - 1;
    	WatchUi.requestUpdate();
    	
    	// Stop the timer after the 00:00 has been rendered
    	if (totalSeconds == 0) {
    		myTimer.stop();
    		flipMeat();
    	}
    }

}
