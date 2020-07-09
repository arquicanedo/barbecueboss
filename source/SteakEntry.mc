using Toybox;
using Toybox.Time;

class SteakEntry {

	enum {
		BURGER = 0,
		BAKE = 1,
		CHICKEN = 2,
		CORN = 3,
		FISH = 4,
		BEEF = 5,
		DRINK = 6,
		SMOKE = 7	
	}

	hidden var _isSelected = false;
	hidden var _status = Controller.INIT;
	hidden var _timeout = 0;
	hidden var _targetSeconds = 0;	
	hidden var _totalFlips = 0;
	hidden var _currentFlip = 0;
	hidden var _label;
	hidden var _initialized = false;
	hidden var _foodType = SteakEntry.BEEF;	
	hidden var _eta = null;
	
	function initialize(label, foodType) {
		_label = label;	
		if (foodType != null) {
			_foodType = foodType;
		}
	}
	
	function getInitialized() {
		return _initialized;
	}
	
	function getStatus() {
		return _status;
	}
	
	function setStatus(status) {
		_status = status;
	}
	
	function getETA() {
		return _eta;
	}
	
	function setETA() {
		var now = new Time.Moment(Time.now().value());
		var duration = new Time.Duration(self.getTimeout());
		_eta = now.add(duration);
	}
	
	
	function getFoodType() {
		return _foodType;
	}
	
	function setFoodType(foodType) {
		_foodType = foodType;
	}
	
	function getLabel() {
		return _label;
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
	
	function getCurrentFlip() {
		if (_status == Controller.COOKING) {
			var now = new Time.Moment(Time.now().value());
			var eta = _eta;
			var diff = eta.subtract(now);
			var secondsPerFlip = _timeout / _totalFlips;
			System.println(Lang.format("now $1$ eta $2$ diff $3$ secsPerFlip $4$", [now.value(), eta.value(), diff.value(), secondsPerFlip]));
			return _totalFlips - (diff.value() / secondsPerFlip);
		}
		else {
			return 0;
		}
	}

	// Lap is the time left within a flip
	function getLap() {
		if (_status == Controller.COOKING) {
			var offset = (_timeout / _totalFlips) * self.getCurrentFlip();
			var lap = _targetSeconds - (_timeout - offset);
			return lap;
		}
		else {
			return 0;
		}
	}
	
	function getTargetString() {
		var lap = self.getLap();
		return Lang.format("$1$:$2$", [ (lap / 60).format("%02d"), (lap % 60).format("%02d") ]);
	}
	
	
}