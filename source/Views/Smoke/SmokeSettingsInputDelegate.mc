using Toybox;
using Toybox.WatchUi;

/* this class implements the smoke settings using Menu2 for new(er) devices, further below is an impl for Menu for older devices */
(:ciq3)
class SmokeSettingsMenu2InputDelegate extends WatchUi.Menu2InputDelegate {

	hidden var _app;
	
	function initialize() {
		Menu2InputDelegate.initialize();
		
		_app = Application.getApp();
	}
	
	function onSelect(item) {
		
		if(self has :handleSelect3) {
			handleSelect3(item);
		}
		else {
			handleSelect1(item);
		}
			
		return true;
	}
	
	(:ciq3)
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
			pickerDelegate.callbackMethod = method(:onPickerSelected);
			WatchUi.pushView(new DurationPicker(DurationPicker.HHMM), pickerDelegate, WatchUi.SLIDE_UP);
			item.setSubLabel((_app.controller.getWaterCheckTime() / 60).toString() + " min.");
			// XXX: I tried the menu2.updateItem(item, index) but does not update the sublabel with the selected value
			return;
		}
	}
	
	function handleSelect1(item) {
		System.println(item.getId());
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
	
	
	function onPickerSelected(time){
		var timeout = ((time[0] * 60 * 60) + (time[2] * 60));
		_app.controller.setWaterCheckTime(timeout);
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

		return true;
	}
}