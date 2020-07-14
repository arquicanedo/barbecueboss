using Toybox;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy;

(:btle)
class TenergyScanView extends WatchUi.Menu2 {
	
	hidden var _controller;

	function initialize(options) {
		Menu2.initialize(options);
		_controller = Application.getApp().controller;
	}

	function onScanResult(sender, result) {
		updateScanResults();	
	}

	function updateScanResults() {
		var results = _controller.getBluetoothController().getScanResults();
		
		for(var i = 0; i < results.size(); i++) {
			//var item = self.findItemById(_scanResults[i].);
			var label = Lang.format("Device $1$", [i + 1]);
			var sublabel = Lang.format("Signal: $1$", [results[i].getScanResult().getRssi()]);
			var id = i.toString();
			
			self.addItem(new WatchUi.MenuItem(label, sublabel, id, null));
		}
		
		WatchUi.requestUpdate();
	}


	function onShow() {
		var bt = _controller.getBluetoothController();
		bt.scanResult.on(self.method(:onScanResult));
		bt.startScan();
	}
	
}