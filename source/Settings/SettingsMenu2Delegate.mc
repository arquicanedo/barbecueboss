 using Toybox;
 using Toybox.WatchUi;
 
 class SettingsMenu2Delegate extends WatchUi.Menu2InputDelegate {
 
 	var _app;
 	var _settingsList;
 	
 	function initialize(settingsList) {
 		Menu2InputDelegate.initialize();
 		_app = Application.getApp();
 		_settingsList = settingsList;
 	}
 	
 	function onSelect(item) {
	
		if(item has :toggle) {
			item.toggle();
		}
		
		return true;
	}
	
 }