using Toybox.WatchUi;
using Toybox.System;

class SettingsDelegate extends WatchUi.BehaviorDelegate {

	hidden var _settingsView;
	hidden var deviceSettings;
	hidden var _app;
	
    function initialize(settingsView) {
        BehaviorDelegate.initialize();
                
       	self.deviceSettings = System.getDeviceSettings();
        _settingsView = settingsView;
    	_app = Application.getApp();
    }

    function onMenu() {
        return true;
    }
    
    function onSelect() {
		//get the selected item
		var item = _settingsView.findDrawableById("settingsList").getSelectedItem();
		//update the value
		item.setStatus(!item.getStatus());
		//call the setter
		WatchUi.requestUpdate();
		return true;
	}	

   	function onBack() {
   		WatchUi.popView(WatchUi.SLIDE_DOWN);
   		return true;
   	}
   	
   	
   	function onNextPage() {
    	//round face watch devices with touch screens don't send swipe events, they use key events
    	//these keypresses are reversed from the kind of scroll/selection we are doing
    	if(self.deviceSettings.isTouchScreen && self.deviceSettings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
    		_app.controller.previousSetting();
    	}
    	else {
			_app.controller.nextSetting();
		}
		
		Toybox.WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {
    	//round face watch devices with touch screens don't send swipe events, they use key events
    	//these keypresses are reversed from the kind of scroll/selection we are doing
    	if(self.deviceSettings.isTouchScreen && self.deviceSettings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
    		_app.controller.nextSetting();
    	}
    	else {
    		_app.controller.previousSetting();
    	}
    	
		Toybox.WatchUi.requestUpdate();
		return true;
    }
   	
   	
}