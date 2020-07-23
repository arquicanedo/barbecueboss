 using Toybox;
 using Toybox.WatchUi;
 
 (:ciq3)
 class SettingsMenu2Delegate extends WatchUi.Menu2InputDelegate {
 
 	var _app;
 	var _settingsList;
 	
 	function initialize(app, settingsList) {
 		Menu2InputDelegate.initialize();
 		_app = app;
 		_settingsList = settingsList;
 	}
 	
 	function onSelect(item) {
	
		if(item has :toggle) {
			item.toggle();
		}
		
		return true;
	}
	
 }