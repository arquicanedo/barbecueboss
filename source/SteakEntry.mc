using Toybox;

class SteakEntry {

	hidden var _isSelected = false;
	hidden var _status = Controller.INIT;
	hidden var _timeout = 0;
	hidden var _elapsedSeconds = 0;
	hidden var _totalSeconds = 0;
	hidden var _targetSeconds = 0;
	hidden var _totalFlips = 0;
	hidden var _label;
	
	function initialize(label) {
		_label = label;	
	}
	
	function getStatus() {
		return _status;
	}
	
	function setStatus(status) {
		_status = status;
	}
	
	function getLabel() {
		return _label;
	}
	
	function setSelected(isSelected){
		_isSelected = isSelected;
	}
	
	function getSelected() {
		return _isSelected;
	}

	function setTargetSeconds(seconds) {
		_targetSeconds = seconds;
	}
	
	function getTargetSeconds() {
		return _targetSeconds;
	}
	
	function setTimeout(seconds) {
		_timeout = seconds;
	}
	
	function getTimeout() {
		return _timeout;
	}
	
	function setTotalFlips(flips) {
		_totalFlips = flips;
	}
	
	function getTotalFlips() {
		return _totalFlips;
	}
	
	function getOverview() {
		return Lang.format(" $1$   Flip $2$   $3$:$4$", 
			[ 
				_label, 
				_totalFlips, 
				(_targetSeconds / 60).format("%02d"), 
				(_targetSeconds % 60).format("%02d")
			]
		);
	}	
}