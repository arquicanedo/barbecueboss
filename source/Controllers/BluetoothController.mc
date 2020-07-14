using Toybox;
using Toybox.Timer;
using Toybox.BluetoothLowEnergy;

(:btle)
class BluetoothController {

	hidden var _bluetoothDelegate;
	hidden var _scanResults = [];
	
	public var scanResult = new SimpleCallbackEvent("onScanResult");
	public var tempChanged = new SimpleCallbackEvent("onTempChanged");
	public var connectionChanged = new SimpleCallbackEvent("onConnectionChanged");
	
	function initialize() {
		if($ has :TenergySolis) {
			_bluetoothDelegate = new TenergySolis.BluetoothDelegate();
			_bluetoothDelegate.subscribe(self);
			BluetoothLowEnergy.setDelegate(_bluetoothDelegate);
		}
	}

	function dispose() {
		scanResult.reset();
		tempChanged.reset();
		
		//can't do this, so I suppose we let it linger
		//BluetoothLowEnergy.setDelegate(null);
		stopScan();
		_bluetoothDelegate.dispose();
		_bluetoothDelegate = null;
	}
	
	function getScanResults() {
		return _scanResults;
	}
	
	function startScan() {
		System.println("Starting BTLE scan");
		BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_SCANNING);
	}
	
	function stopScan() {
		System.println("Stopping BTLE scan");
		BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_OFF);
	}
	
	function onStateChanged(state) {
	
		switch(state) {
		
			case TenergySolis.BluetoothDelegate.READ:
				stopScan();
				break;
				
			case TenergySolis.BluetoothDelegate.PAIRING:
				startScanTimer();
				break;
		
			default:
				break;
		}
		
		connectionChanged.emit(state);
	}
	
	function startScanTimer() {
		new Timer.Timer().start(method(:onScanTimer), 10000, false);
	}
	
	function onScanTimer() {
		startScan();
	}
	
	function onScanResult(result) {
		System.println("TenergyScanView recv scanResult");
		
		if(0 == _scanResults.size()) {
			_scanResults.add(result);
			scanResult.emit(result);
			return;
		}
		
		
		for(var i = 0; i < _scanResults.size(); i++) {
			if(_scanResults[i].isSameDevice(result)) {
				return;
			}
		}
		
		_scanResults.add(result);
		scanResult.emit(result);
	}
}