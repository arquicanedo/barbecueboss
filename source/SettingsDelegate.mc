using Toybox.WatchUi;
using Toybox.System;

class SettingsDelegate extends WatchUi.BehaviorDelegate {

	hidden var _settingsList;
	hidden var _deviceSettings;
	hidden var _app;
	
    function initialize(settingsView) {
        BehaviorDelegate.initialize();
                
       	_deviceSettings = System.getDeviceSettings();
        _settingsList = settingsView.findDrawableById("settingsList");
    	_app = Application.getApp();
    }

    function onMenu() {
        return true;
    }
    
    function onSelect() {
		//get the selected item
		var item = _settingsList.getSelectedItem();
		//update the value
		item.setStatus(!item.getStatus());
		//call the setter
		WatchUi.requestUpdate();
		return true;
	}	

   	function onBack() {
   		_settingsList = null;
   		_deviceSettings = null;
   		WatchUi.popView(WatchUi.SLIDE_DOWN);
   		return true;
   	}
   	
   	
   	function onNextPage() {
    	//round face watch devices with touch screens don't send swipe events, they use key events
    	//these keypresses are reversed from the kind of scroll/selection we are doing
    	if(_deviceSettings.isTouchScreen && _deviceSettings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
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
    	if(_deviceSettings.isTouchScreen && _deviceSettings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
    		_app.controller.nextSetting();
    	}
    	else {
    		_app.controller.previousSetting();
    	}
    	
		Toybox.WatchUi.requestUpdate();
		return true;
    }
   	
   	
}