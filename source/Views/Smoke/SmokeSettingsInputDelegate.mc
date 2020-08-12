using Toybox;
using Toybox.WatchUi;

/* this class implements the smoke settings using Menu2 for new(er) devices, further below is an impl for Menu for older devices */
(:ciq3)
class SmokeSettingsMenu2InputDelegate extends WatchUi.Menu2InputDelegate {

	hidden var _app;
	
	function initialize(app) {
		Menu2InputDelegate.initialize();
		
		_app = app;
	}
	
	function onSelect(item) {
		handleSelect3(item);
		return true;
	}
	
	function handleSelect3(item) {
		System.println(item.getId());
			
		var id = item.getId();
		if(id.equals("probeConfig")) {
			if(self has :showMeatProbeConfig) {
				showMeatProbeConfig();
			}
			
			return;
		}
		
		if(id.equals("tempUnit")) {
			item.toggle();
			WatchUi.requestUpdate();
			return;
		}
		
		if(id.equals("waterCheck")) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onWaterCheckPicked);
			WatchUi.pushView(new DurationPicker(DurationPicker.HHMM), pickerDelegate, WatchUi.SLIDE_UP);

			return;
		}
		
		if(id.equals("smokeCheck")) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onSmokeCheckPicked);
			WatchUi.pushView(new DurationPicker(DurationPicker.HHMM), pickerDelegate, WatchUi.SLIDE_UP);
			
			return;
		}
		
		if(id.equals("tempCheck")) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onTempCheckPicked);
			WatchUi.pushView(new DurationPicker(DurationPicker.HHMM), pickerDelegate, WatchUi.SLIDE_UP);
			
			return;
		}
	}
	
	
	(:btle)
	function showMeatProbeConfig() {
		//put up the config menu for the probe with scan, etc.
		var configMenu = new WatchUi.Menu2({:title => "Probe Settings"});
		var enabledItem = new SettingsToggleMenuItem(
			"Enabled", 
			null, 
			"enabledItem", 
			_app.controller.getMeatProbeEnabled(), 
			{ 
				:getter => _app.controller.method(:getMeatProbeEnabled), 
				:setter => self.method(:onMeatProbeToggled)
			});
			
		var scanItem = new WatchUi.MenuItem("Device Scan", "", "scanItem", {});
		
		configMenu.addItem(enabledItem);
		configMenu.addItem(scanItem);
		
		WatchUi.pushView(configMenu, new TenergyConfigMenuInputDelegate(), WatchUi.SLIDE_UP);
	}
	
	(:btle)
	function onMeatProbeToggled(enabled) {
		_app.controller.setMeatProbeEnabled(enabled);
	}
	
	function onTempCheckPicked(time) {
		var timeout = ((time[0] * 60 * 60) + (time[2] * 60));
		_app.controller.setTempCheckTime(timeout);
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
	 
	function onSmokeCheckPicked(time) {
		var timeout = ((time[0] * 60 * 60) + (time[2] * 60));
		_app.controller.setSmokeCheckTime(timeout);
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
	
	function onWaterCheckPicked(time){
		var timeout = ((time[0] * 60 * 60) + (time[2] * 60));
		_app.controller.setWaterCheckTime(timeout);
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
	
}

(:ciq1)
class SmokeSettingsInputDelegate extends WatchUi.MenuInputDelegate {

	hidden var _app;
	
	function initialize() {
		MenuInputDelegate.initialize();
		
		_app = Application.getApp();
	}
	
	function onMenuItem(item) {
		System.println(item);

		
		if(item == :waterCheck) {
		
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onWaterCheckPicked);
			WatchUi.pushView(new DurationPicker(DurationPicker.HHMM), pickerDelegate, WatchUi.SLIDE_UP);
			
			return;
		}
		
		if(item == :smokeCheck) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onSmokeCheckPicked);
			WatchUi.pushView(new DurationPicker(DurationPicker.HHMM), pickerDelegate, WatchUi.SLIDE_UP);
		
			return;
		}
		
		if(item == :tempCheck) {
			var pickerDelegate = new DurationPickerCallbackDelegate();
			pickerDelegate.callbackMethod = method(:onTempCheckPicked);
			WatchUi.pushView(new DurationPicker(DurationPicker.HHMM), pickerDelegate, WatchUi.SLIDE_UP);
			
			return;
		}

	}
	
	function onTempCheckPicked(time) {
		var timeout = ((time[0] * 60 * 60) + (time[2] * 60));
		_app.controller.setTempCheckTime(timeout);
	}
	 
	function onSmokeCheckPicked(time) {
		var timeout = ((time[0] * 60 * 60) + (time[2] * 60));
		_app.controller.setSmokeCheckTime(timeout);
	}
	
	function onWaterCheckPicked(time){
		var timeout = ((time[0] * 60 * 60) + (time[2] * 60));
		_app.controller.setWaterCheckTime(timeout);
	}
	
}