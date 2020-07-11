using Toybox;
using Toybox.Time;
using Toybox.Time.Gregorian;


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
	hidden var _totalTime = 0;	
	hidden var _currentFlip = 0;
	hidden var _timePerFlip = 0;
	hidden var _label;
	hidden var _initialized = false;
	hidden var _foodType = SteakEntry.BEEF;	
	hidden var _eta = null;
	hidden var _etaStart = null;
	

	function reset() {
		_status = Controller.INIT;
		_timeout = 0;
		_currentFlip = 0;
		_timeout = 0;
	}

	
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
		var duration = new Time.Duration(self.getTotalTime());
		_eta = now.add(duration);
		_etaStart = now; 
	}
	
	function getProgress() {
		var now = new Time.Moment(Time.now().value());
		var totalSeconds = _eta.subtract(_etaStart);
		var elapsedSeconds = now.subtract(_etaStart);
		return elapsedSeconds.value().toFloat() / totalSeconds.value().toFloat();
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

	
	function setTimeout(seconds) {
		_timeout = seconds;
		_initialized = true;
	}
	
	function getTimeout() {
		return _timeout;
	}
	
	function getTotalTime() {
		return _totalTime;
	}
	
	function setTotalTime(totalTime) {
		_totalTime = totalTime;
	}
	
	
	function setCurrentFlip(currentFlip) {
		_currentFlip = currentFlip;
	}
	
	function getCurrentFlip() {
		return _currentFlip;
	}
	
	function getTimePerFlip() {
		return _timePerFlip;
	}
	
	function setTimePerFlip(timePerFlip) {
		_timePerFlip = timePerFlip;
	}
	
	function getTimeoutString() {
		return Lang.format("$1$:$2$", [ (self.getTimeout() / 60).format("%02d"), (self.getTimeout() % 60).format("%02d") ]);
	}
	
	function getETAString() {
		if (_status == Controller.COOKING) {
			var today = Gregorian.info(_eta, Time.FORMAT_MEDIUM);
			var dateString = Lang.format(
			    "$1$:$2$",
			    [
			        today.hour.format("%02d"),
			        today.min.format("%02d"),
			    ]
			);
			return dateString;
		}
		else {
			return "00:00";
		}
	}
	
}