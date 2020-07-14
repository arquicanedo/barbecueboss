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