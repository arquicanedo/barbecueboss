using Toybox;
using Toybox.WatchUi;


(:btle)
class TenergyScanViewDelegate extends WatchUi.Menu2InputDelegate {

	hidden var _controller;
	
	
	function initialize() {
		Menu2InputDelegate.initialize();
		_controller = Application.getApp().controller;
	}

	function onSelect(item) {
	
		var result = _controller.getBluetoothController().getScanResults()[item.getId().toNumber()];
	
		System.println(Lang.format("Connecting to device $1$ with RSSI $2$", [item.getId(), result.getScanResult().getRssi()]));
		result.pairAndConnect();
	}
}
