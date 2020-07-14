using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

(:smoke)
class SmokeViewDelegate extends WatchUi.BehaviorDelegate {

	hidden var _app;
	(:btle)hidden var _probeUnitItem;
	(:btle)hidden var _probeEnabledItem;
	
    function initialize() {
        BehaviorDelegate.initialize();
        _app = Application.getApp();
    }

    function onMenu() {
    	
    	if(self has :createMenu2) {
    		createMenu2();
    	}
    	else {
    		createMenu();
    	}
    	
        return true;
    }

	(:ciq3)
	function createMenu2() {
		var waterCheck = new WatchUi.MenuItem("Water Check", "60 mins.", "waterCheck", null);
		var smokeCheck = new WatchUi.MenuItem("Smoke Check", "45 mins.", "smokeCheck", null);
		var tempCheck = new WatchUi.MenuItem("Temp Check", "30 mins.", "tempCheck", null);

    	var menu2 = new WatchUi.Menu2({:title=> "Smoke Settings"});
    		
    	menu2.addItem(waterCheck);
    	menu2.addItem(smokeCheck);
    	menu2.addItem(tempCheck);

		if(self has :createBtleMenuItems) {
			createBtleMenuItems(menu2);
    	}
		
		WatchUi.pushView(menu2, new SmokeSettingsMenu2InputDelegate(), WatchUi.SLIDE_UP);
	}
	
	(:ciq1)
	function createMenu() {
		var menu = new WatchUi.Menu();
    	menu.setTitle(WatchUi.loadResource(Rez.Strings.smoke_menu_title));
    	menu.addItem(WatchUi.loadResource(Rez.Strings.smoke_menu_water_check_text), :waterCheck);
    	menu.addItem(WatchUi.loadResource(Rez.Strings.smoke_menu_smoke_check_text), :smokeCheck);
    	menu.addItem(WatchUi.loadResource(Rez.Strings.smoke_menu_temp_check_text), :tempCheck);

		WatchUi.pushView(createMenu(), new SmokeSettingsInputDelegate(), WatchUi.SLIDE_UP);
	}
	    
    (:btle)
    function createBtleMenuItems(menu2) {
		var probeConfig = new WatchUi.MenuItem("Probe Config", _app.controller.getMeatProbeEnabled() ? "Tenergy Solis BTLE" : "Disabled", "probeConfig", null);
		_probeUnitItem = new SettingsEnumToggleMenuItem( 
														"Temp. Unit", 
														getTempType(), 
														"tempUnit", 
														{ 
															:getter => self.method(:onGetTempUnit), 
															:setter => self.method(:onSetTempUnit), 
															:enumValues => 
																		[
																			{ :value => TenergySolis.BluetoothDevice.TEMP_DEG_C, :description => "deg C" },
																			{ :value => TenergySolis.BluetoothDevice.TEMP_DEG_F, :description => "deg F" }
																		]
														});

		menu2.addItem(probeConfig);
		menu2.addItem(_probeUnitItem);
    }
    
    (:btle)
    function getTempType() {
    	switch(_app.controller.getMeatProbeUnit()) {
    		case TenergySolis.BluetoothDevice.TEMP_DEG_C:
    			return "deg C";
    		case TenergySolis.BluetoothDevice.TEMP_DEG_F:
    			return "deg F";
    		default:
    			return "";
    	}
    }
    
    (:btle)
   	function onGetTempUnit() {
   		return _app.controller.getMeatProbeUnit();
   	}
   	
   	(:btle)
   	function onSetTempUnit(unit) {
   		_app.controller.setMeatProbeUnit(unit);
   	}
   	
   	function onBack() {
		WatchUi.switchToView(new WelcomeView(), new WelcomeDelegate(), WatchUi.SLIDE_DOWN);
   		return true;
   	}
    
    // Settings
	function onPreviousPage() {
		self.onMenu();
		return true;
    }
    
    function onTimePicked(time) {
    	System.println(time);
    	var dueTime = Time.now().add(new Time.Duration((time[0] * 60) + time[2]));
    	_app.controller.startSmoker(dueTime);
    }
    
    function onSelect() {
    	var dpd = new DurationPickerCallbackDelegate();
    	dpd.callbackMethod = method(:onTimePicked);
    	WatchUi.pushView(new DurationPicker(), dpd, WatchUi.SLIDE_LEFT);
    	return true;
    }
    
}