using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

(:smoke)
class SmokeViewDelegate extends WatchUi.BehaviorDelegate {

	hidden var _app;
	(:btle)hidden var _probeUnitItem;
	(:btle)hidden var _probeEnabledItem;
	
	hidden var _waterCheck;
	hidden var _smokeCheck;
	hidden var _tempCheck;
	hidden var _menu;
	
    function initialize(app) {
        BehaviorDelegate.initialize();
        _app = app;

        _app.controller.smokeSettingsChanged.on(method(:onSmokeSettingsChanged));
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

	function onSmokeSettingsChanged(sender, value) {

		if(self has :createMenu2) {
			_waterCheck.setSubLabel((_app.controller.getWaterCheckTime() / 60).toString() + " min.");
			_menu.updateItem(_waterCheck, 0);
			
			_smokeCheck.setSubLabel((_app.controller.getSmokeCheckTime() / 60).toString() + " min.");
			_menu.updateItem(_smokeCheck, 1);
			
			_tempCheck.setSubLabel((_app.controller.getTempCheckTime() / 60).toString() + " min.");
			_menu.updateItem(_tempCheck, 2);
		}
		
	}

	(:ciq3)
	function createMenu2() {
		
		_waterCheck = new WatchUi.MenuItem("Water Check", (_app.controller.getWaterCheckTime() / 60).toString() + " min.", "waterCheck", null);
		_smokeCheck = new WatchUi.MenuItem("Smoke Check", (_app.controller.getSmokeCheckTime() / 60).toString() + " min.", "smokeCheck", null);
		_tempCheck = new WatchUi.MenuItem("Temp Check", (_app.controller.getTempCheckTime() / 60).toString() + " min.", "tempCheck", null);

    	_menu = new WatchUi.Menu2({:title=> "Smoke Settings"});
    		
    	_menu.addItem(_waterCheck);
    	_menu.addItem(_smokeCheck);
    	_menu.addItem(_tempCheck);

		if(self has :createBtleMenuItems) {
			createBtleMenuItems(_menu);
    	}
		
		WatchUi.pushView(_menu, new SmokeSettingsMenu2InputDelegate(_app), WatchUi.SLIDE_UP);
	}
	
	(:ciq1)
	function createMenu() {
		var menu = new WatchUi.Menu();
    	menu.setTitle(WatchUi.loadResource(Rez.Strings.smoke_menu_title));
    	menu.addItem(WatchUi.loadResource(Rez.Strings.smoke_menu_water_check_text), :waterCheck);
    	menu.addItem(WatchUi.loadResource(Rez.Strings.smoke_menu_smoke_check_text), :smokeCheck);
    	menu.addItem(WatchUi.loadResource(Rez.Strings.smoke_menu_temp_check_text), :tempCheck);

		WatchUi.pushView(menu, new SmokeSettingsInputDelegate(), WatchUi.SLIDE_UP);
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
   		_app.controller.smokeSettingsChanged.reset();
		WatchUi.switchToView(new WelcomeView(), new WelcomeDelegate(_app), WatchUi.SLIDE_DOWN);
   		return true;
   	}
    
    // Settings
	function onPreviousPage() {
		self.onMenu();
		return true;
    }
    
    function onTimePicked(time) {
    	System.println(time);
    	var dueTime = Time.now().add(new Time.Duration((time[0] * (60*60)) + (time[2]*60)));
    	_app.controller.startSmoker(dueTime);
    }
    
    function onSelect() {
    	var dpd = new DurationPickerCallbackDelegate();
    	dpd.callbackMethod = method(:onTimePicked);
    	WatchUi.pushView(new DurationPicker(DurationPicker.HHMM), dpd, WatchUi.SLIDE_LEFT);
    	return true;
    }
    
}