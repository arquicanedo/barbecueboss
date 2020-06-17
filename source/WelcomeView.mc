using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;


class WelcomeView extends WatchUi.View {
	
	hidden var timer;
	hidden var logoImage;
	hidden var logoX;
	hidden var logoY;
	
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
	    View.setLayout(Rez.Layouts.WelcomeLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    
    	//we aren't using the image in the welcomeLayout.xml any more because it uses a LOT of memory to do it that way
    	//layouts get loaded up when the view is loaded and all of its resources stay in memory all the time so the logo image was eating 10k of RAM
    	//to not be displayed
    	//doing it like this (load the image onShow(), release the image onHide()) means we only use that 10k when the user is viewing the welcome screen
    	//we could also create multiple sized images for use on smaller/lower memory devices and would save even more
    	if(null == self.logoImage){
    		self.logoImage = WatchUi.loadResource(Rez.Drawables.WelcomeLogoImage);
    		
	    	var deviceSettings = System.getDeviceSettings();
			self.logoX = (deviceSettings.screenWidth - self.logoImage.getWidth()) / 2;
			self.logoY = (deviceSettings.screenHeight - self.logoImage.getHeight()) / 2;
    	}
    	
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        if(null != self.logoImage) {
        	dc.drawBitmap(self.logoX, self.logoY, self.logoImage);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	self.logoImage = null;
    }
    
	function selectTime(minutes) {
		System.print("User selected");
		System.println(minutes);
	}	
}
