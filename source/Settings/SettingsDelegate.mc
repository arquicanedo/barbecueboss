using Toybox.WatchUi;
using Toybox.System;

class SettingsDelegate extends WatchUi.BehaviorDelegate {

	hidden var _settingsList;
	hidden var _deviceSettings;
	hidden var _app;
	
    function initialize(app) {
        BehaviorDelegate.initialize();
       	_deviceSettings = System.getDeviceSettings();
    	_app = app;
    }

	function onSettingsLayoutLoaded(sender, settingsList) {
		_settingsList = settingsList;
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
   	
   	function onSwipe(swipeEvent){
    
    	var dir = swipeEvent.getDirection();
    	
    	if(dir == WatchUi.SWIPE_DOWN) {
    		var selected = _settingsList.getSelectedIndex();
    		
    		if(-1 != selected) {
    			var items = _settingsList.getItems();
    			
    			items[selected].setSelected(false);
    			items[(selected + 1) % items.size()].setSelected(true);
    		}
    	} 
    	else if(dir == WatchUi.SWIPE_UP) {
    		var selected = _settingsList.getSelectedIndex();
    		
    		if(-1 != selected) {
    			var items = _settingsList.getItems();
    			
    			items[selected].setSelected(false);
    			
    			var newSelection = (selected - 1) % items.size();
    			
    			if(newSelection < 0) {
    				items[items.size() - 1].setSelected(true);
    			}
    			else {
    				items[newSelection].setSelected(true);	
    			}
    		
    		}
    	}
    	
    	WatchUi.requestUpdate();
    }
}