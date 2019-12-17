using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;

class timerView extends WatchUi.View {

    hidden var myText;
    hidden var myMinutes;
    hidden var myTimer;
    hidden var elapsedSeconds;
	hidden var totalSeconds;
	hidden var flipped;
	hidden var targetMinutes;

    function initialize(minutes) {
    	System.println("timerView() initialized... ping");
        View.initialize();
        System.println(minutes);
        var zero = 0;
        myMinutes = Lang.format(
		    "$1$:$2$",
    		[minutes.format("%02d"), zero.format("%02d")]);
    
    	myTimer = new Timer.Timer();
    	myTimer.start(method(:timerCallback), 1000, true);
    	elapsedSeconds = 0;
    	totalSeconds = minutes*60;
    	flipped = false;
    	targetMinutes = minutes;
    	
    }

    // Load your resources here
    function onLayout(dc) {
        System.println("timerView.onLayout() initialized...");
		WatchUi.View.setLayout(Rez.Layouts.TimerLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        myText = new WatchUi.Text({
            //:text=>"Hello World!",
            :text=>myMinutes,
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        if (flipped == false) {
			countDown(dc);
		}
		else {
			self.initialize(targetMinutes);
		}
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
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
    
    function flipMeat() {
    }
    
    function timerCallback() {
    	elapsedSeconds = elapsedSeconds + 1;
    	totalSeconds = totalSeconds - 1;
    	WatchUi.requestUpdate();
    	
    	// Stop the timer after the 00:00 has been rendered
    	if (totalSeconds == 0) {
    		myTimer.stop();
    		flipped = true;
    	}
	}


}
