using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;
using Toybox.Application;


class SteakMenuView extends WatchUi.View {

	hidden var app;
	hidden var mySteakMenuTitleText;
	hidden var mySteakLabelsText;	// Array
	hidden var mySelectorMarker;

	hidden var steak_y_pos = [50, 65, 80, 95];
	hidden var steak_x_pos = [30, 30, 30, 30];


    function initialize() {
        self.app = Application.getApp();
        mySteakLabelsText = new [app.controller.total_steaks];
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
	    View.initialize();
	    
    }
    
    
    function drawSteakMenu(dc) {
    	self.setSteakMenuTitle();
    	self.setSteakLabels();
    	self.setSelectorMarker();
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
    	mySteakMenuTitleText.draw(dc);
    	for( var i = 0; i < app.controller.total_steaks; i += 1 ) {
    		mySteakLabelsText[i].draw(dc);
    	}
    	mySelectorMarker.draw(dc);
    }
    
    
    function setSteakMenuTitle() {
    	System.println("setSteakMenu().............");
    	var mySteakMenu = Lang.format(
		    "$1$", ["Steak Menu"]);
    	mySteakMenuTitleText = new WatchUi.Text({
            :text=>mySteakMenu,
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>30
        });
    }
        
        
	function setSteakLabels() {
		for( var i = 0; i < app.controller.total_steaks; i += 1 ) {
		    var mySteakLabel = Lang.format(
		    	"$1$ $2$ $3$", ["Steak", i, app.controller.steak_status[i]]);
	    	mySteakLabelsText[i] = new WatchUi.Text({
	            :text=>mySteakLabel,
	            :color=>Graphics.COLOR_WHITE,
	            :font=>Graphics.FONT_SMALL,
	            :locX =>steak_x_pos[i],
	            :locY=>steak_y_pos[i]
	        });		
		}
    }
    
    function setSelectorMarker() {
	    var mySelector = Lang.format("$1$", [">"]);
	    
	   	mySelectorMarker = new WatchUi.Text({
	            :text=>mySelector,
	            :color=>Graphics.COLOR_ORANGE,
	            :font=>Graphics.FONT_SMALL,
	            :locX =>steak_x_pos[app.controller.steak_selection]-10,
	            :locY=>steak_y_pos[app.controller.steak_selection]
	        });	
    }
    


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    
        // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
		self.drawSteakMenu(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    

}
