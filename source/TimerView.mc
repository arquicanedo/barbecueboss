using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;
using Toybox.Application;


class TimerView extends WatchUi.View {

	hidden var app;
    hidden var myTimer;
	hidden var myTimerText;
	hidden var myFlipText;
    hidden var myMinutes;
    hidden var myCookingStatusText;
    hidden var myCookingStatus;
	hidden var stateLocY = 25;
	hidden var verticalTextSlop = 10;
	hidden var timerSeconds = 1;
	
    function initialize(seconds) {
    	System.println("timerView() initialized...");
    	
    	self.app = Application.getApp();
    	self.timerSeconds = seconds;
    	
    	View.initialize();
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

        //register for timer/flip changed "events"
		app.controller.timerChanged.on(self.method(:onTimerChanged));
		app.controller.flipChanged.on(self.method(:onFlipChanged));
		
    	app.controller.initializeTimer(self.timerSeconds);
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
		self.drawTimer(dc);
    }
    
    //handle timer changed event
    function onTimerChanged(sender, value) {
    	self.setTimerText(value[0], value[1]);
    	Toybox.WatchUi.requestUpdate();
    }
    
    //handle flip changed event
    function onFlipChanged(sender, totalFlips) {
    	self.setFlipText(totalFlips);
    }

    function setTimerText(elapsedSeconds, totalSeconds) {
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


    function drawTimer(dc) {
    	//System.println("drawTimer...");
    	
    	self.setFlipText(app.controller.totalFlips);
		self.setTimerText(app.controller.elapsedSeconds, app.controller.totalSeconds);
		self.updateCookingStatusText();
		
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        myCookingStatusText.draw(dc);
        myFlipText.setLocation(WatchUi.LAYOUT_HALIGN_CENTER, 
        						myCookingStatusText.locY + myCookingStatusText.height + self.verticalTextSlop);
        myFlipText.draw(dc);
        myTimerText.setLocation(WatchUi.LAYOUT_HALIGN_CENTER, 
        						myFlipText.locY + myFlipText.height + self.verticalTextSlop); 
        myTimerText.draw(dc);        
    }

    function setFlipText(totalFlips) {
    	var myFlip = Lang.format(
		    "$1$ $2$", ["Flip: ", totalFlips.format("%d")]);
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
            :locY=>self.stateLocY
        });
    }
    
    function updateCookingStatusText() {
    	if (app.controller.getStatus() == Controller.COOKING) {
			self.setCookingStatusText("Cooking");
		}
		else if (app.controller.getStatus() == Controller.USER_FLIPPING) {
			self.setCookingStatusText("Confirm flip");
		}
		else {
			self.setCookingStatusText("Cooking");
		}
		/*else if (app.controller.getStatus() == AUTO_FLIPPING) {
			self.setCookingStatusText("Another flip?");
		}*/
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	app.controller.timerChanged.reset();
		app.controller.flipChanged.reset();
    }
}
