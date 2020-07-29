using Toybox;
using Toybox.WatchUi;

(:smoke)
class SmokeView extends WatchUi.View {
	
	hidden var _dummyItem;
	hidden var _dueTime;
	hidden var _app;
	
	// Very basic behavior now. These trigger only once.
	hidden var _smokeCheckTriggered = false;
	hidden var _waterCheckTriggered = false;
	hidden var _tempCheckTriggered = false;
	
	function initialize(app) {
		View.initialize();
		
		_app = app;
		
		if(self has :initializeBluetooth) {
			initializeBluetooth();
		}	
	}
	
	function onLayout(dc) {
		View.setLayout(Rez.Layouts.SmokeLayout(dc));
	}

	function onShow() {
		if(null == _dummyItem) {
			var lst = findDrawableById("smokeList");
			
			_dummyItem = new SteakListItem(new SteakEntry("", SteakEntry.SMOKE), lst.getParams());
			lst.setItems([_dummyItem]);
		}
		
		_app.controller.timerChanged.on(method(:onSmokeTimerChanged));
	}

	function onHide() {
		var lst = findDrawableById("smokeList");
		lst.resetItems();
		_dummyItem = null;
		SteakListItem.MeatMap.remove(SteakEntry.SMOKE);
		_app.controller.timerChanged.reset();
	}
	
	function onSmokeTimerChanged(sender, value) {
		_dueTime = Application.getApp().controller.getSmokeTimer();
		WatchUi.requestUpdate();
	}
	
	function onUpdate(dc) {
		View.onUpdate(dc);
		
		if(null == _dueTime || _dueTime == 0) {
			_dummyItem.getSteak().setTimeout(0);
			return;
		}
		
		var diff = (_dueTime) - Time.now().value();
		
		if(diff < 0) {
			System.println("smoke diff neg.");
			_dummyItem.getSteak().setTimeout(0);
			return;
		}
		else {
			_dummyItem.getSteak().setTimeout(diff);
		}
		
		self.smokeCheckWarning(diff);

    	
	}
	
	function smokeCheckWarning(diff) {
    	if (diff <= _app.controller.getWaterCheckTime() && false == self._waterCheckTriggered) {
			self._waterCheckTriggered = true;
			Toybox.WatchUi.pushView(new SmokeCheckView("Water"), new SmokeCheckViewDelegate(), WatchUi.SLIDE_UP);	
    	}
    	if (diff <= _app.controller.getSmokeCheckTime() && false == self._smokeCheckTriggered) {
			self._smokeCheckTriggered = true;
			Toybox.WatchUi.pushView(new SmokeCheckView("Smoke"), new SmokeCheckViewDelegate(), WatchUi.SLIDE_UP);
    	}
    	if (diff <= _app.controller.getTempCheckTime() && false == self._tempCheckTriggered) {
    		self._tempCheckTriggered = true;
			Toybox.WatchUi.pushView(new SmokeCheckView("Temp"), new SmokeCheckViewDelegate(), WatchUi.SLIDE_UP);

    	}
	    System.println(Lang.format("ALARM UPDATE [$1$, $2$, $3$]", [self._waterCheckTriggered, self._smokeCheckTriggered, self._tempCheckTriggered]));
	}
	

	
	(:btle)
	function initializeBluetooth() {
	
		if(_app.controller.getMeatProbeEnabled()) {
			var bt = _app.controller.getBluetoothController();
			bt.scanResult.on(self.method(:onScanResult));
			bt.connectionChanged.on(self.method(:onConnectionChanged));
			bt.startScan();
		}	
	}
	
	(:btle)
	function onConnectionChanged(sender, state) {
		if(state != BluetoothLowEnergy.CONNECTION_STATE_CONNECTED) {
			findDrawableById("upperTemp").setTemps(null);
			findDrawableById("lowerTemp").setTemps(null);
		}
	}
	
	(:btle)
	function onScanResult(sender, result) {
		result.tempChanged.on(self.method(:onTempChanged));
		result.pairAndConnect();
	}
	
	(:btle)
	function onTempChanged(sender, value) {
		var unit = _app.controller.getMeatProbeUnit();
		var temps = value.getTemps(unit);
		findDrawableById("upperTemp").setTemps(temps);
		findDrawableById("lowerTemp").setTemps(temps);
		
		WatchUi.requestUpdate();
	}
}