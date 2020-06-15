using Toybox.WatchUi;
using Toybox.System;

class SettingsDelegate extends WatchUi.BehaviorDelegate {

	hidden var _settingsView;
	
    function initialize(settingsView) {
        BehaviorDelegate.initialize();
        
        _settingsView = settingsView;
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
}