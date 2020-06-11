using Toybox;

class SteakEntry {

	enum {
		BURGER = 0,
		BAKE = 1,
		CHICKEN = 2,
		CORN = 3,
		FISH = 4,
		BEEF = 5,
		PORK = 6,
		LAMB = 7	
	}

	hidden var _isSelected = false;
	hidden var _status = Controller.INIT;
	hidden var _timeout = 0;
	hidden var _elapsedSeconds = 0;
	hidden var _totalSeconds = 0;
	hidden var _targetSeconds = 0;
	hidden var _totalFlips = 0;
	hidden var _label;
	hidden var _initialized = false;
	hidden var _foodType = SteakEntry.BEEF;	// What type of food is this steak
	hidden var _foodTypeCount = 0;	// What steak number of the same type is on the grill
	
	function initialize(label) {
		_label = label;	
	}
	
	function getInitialized() {
		return _initialized;
	}
	
	function getStatus() {
		return _status;
	}
	
	function setStatus(status) {
		//System.println("setStatus");
		_status = status;
	}
	
	function getFoodtypeCount() {
		return _foodTypeCount;
	}
	
	function setFoodTypeCount(foodTypeCount) {
		_foodTypeCount = foodTypeCount;
	}
	
	function getFoodTypeCount() {
		return _foodTypeCount;
	}
	
	function getFoodType() {
		return _foodType;
	}
	
	function setFoodType(foodType) {
		_foodType = foodType;
	}
	
	function getLabel() {
		if (_foodTypeCount == 0) {
			return _label;
		}
		else {
			return _label + _foodTypeCount;
		}
	}
	
	function setLabel(label) {
		_label = label;
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
		_targetSeconds = seconds;
		_initialized = true;
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
	
	function getFlipString() {
		return Lang.format("Flip $1$", [_totalFlips]);
	}
	
	function getTargetString() {
		return Lang.format("$1$:$2$", [ (_targetSeconds / 60).format("%02d"), (_targetSeconds % 60).format("%02d") ]);
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