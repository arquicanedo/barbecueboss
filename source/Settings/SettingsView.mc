using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;


(:ciq1)
class SettingsView extends WatchUi.View {

	hidden var _app;
	public var layoutLoaded = new SimpleCallbackEvent("layoutLoaded");
	
    function initialize(app) {
        View.initialize();
    
    	_app = app;
    }

    // Load your resources here
    function onLayout(dc) {
	    View.setLayout(Rez.Layouts.SettingsLayout(dc));
	    layoutLoaded.emit(findDrawableById("settingsList"));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	var list = findDrawableById("settingsList");
        var settings = new [2];
        var font = list.getParams().get(:font);

		_app.controller.setSettings(settings, settings.size());
        settings[0] = new SettingsListItem(WatchUi.loadResource(Rez.Strings.settings_gps), font, method(:getGpsStatus), method(:setGpsStatus));
        settings[0].setSelected(true);
        
        settings[1] = new SettingsListItem(WatchUi.loadResource(Rez.Strings.settings_activity), font, method(:getActivityEnabled), method(:setActivityEnabled));
        
        list.setItems(settings);
    }
    

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	dispose();
    }
    
    function dispose() {
    	var list = findDrawableById("settingsList");
    	var items = list.getItems();
    	
    	if(null != items) {
    		for(var i = 0; i < items.size(); i++) {
    			items[i].dispose();
    		}	
    	}
    	
    	list.setItems(null);
    	self.layoutLoaded.reset();
    }
    
    function setGpsStatus(enabled) {
    	_app.controller.setGpsEnabled(enabled);
    }
    
    function getGpsStatus() {
    	return _app.controller.getGpsEnabled(); 
    }
    
    function getActivityEnabled() {
    	return _app.controller.getActivityEnabled();
    }
    
    function setActivityEnabled(enabled) {
    	_app.controller.setActivityEnabled(enabled);
    }
}
