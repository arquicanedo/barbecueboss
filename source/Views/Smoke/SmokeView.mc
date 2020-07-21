using Toybox;
using Toybox.WatchUi;

(:smoke)
class SmokeView extends WatchUi.View {
	
	hidden var _dummyItem;
	hidden var _dueTime;
	
	function initialize() {
		View.initialize();
		
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
		
		Application.getApp().controller.timerChanged.on(method(:onSmokeTimerChanged));
	}

	function onHide() {
		var lst = findDrawableById("smokeList");
		lst.resetItems();
		_dummyItem = null;
		SteakListItem.MeatMap.remove(SteakEntry.SMOKE);
		Application.getApp().controller.timerChanged.reset();
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
			System.println("smoke time diff is negative");
			_dummyItem.getSteak().setTimeout(0);
			return;
		}
		else {
			_dummyItem.getSteak().setTimeout(diff);
		}
	}
	
	(:btle)
	function initializeBluetooth() {
	
		if(Application.getApp().controller.getMeatProbeEnabled()) {
			var bt = Application.getApp().controller.getBluetoothController();
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
		var unit = Application.getApp().controller.getMeatProbeUnit();
		var temps = value.getTemps(unit);
		findDrawableById("upperTemp").setTemps(temps);
		findDrawableById("lowerTemp").setTemps(temps);
		
		WatchUi.requestUpdate();
	}
	
	/*
	(:btle)
	function getProbeText(temps, unit) {
	
		var output = "";
		for(var i = 0; i < temps.size(); i++) {
			output += Lang.format(
									"Probe $1$: $2$$3$", 
									[
										i, -1 == temps[i] ? "NOT CONNECTED" : temps[i].format("%.2f"), 
										unit
									]);
			output += "\n";
		}
		
		return output;
	}*/
}