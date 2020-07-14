using Toybox;
using Toybox.WatchUi;

class SettingsEnumToggleMenuItem extends WatchUi.MenuItem {

	hidden var _enumValues;
	hidden var _getter;
	hidden var _setter;
	hidden var _currVal;
	
	function initialize(label, sublabel, identifier, options) {
		MenuItem.initialize(label, sublabel, identifier, options);
	
		_enumValues = options.get(:enumValues);
		_getter = options.get(:getter);
		_setter = options.get(:setter);
		_currVal = options.get(:selectedValue);
		
		if(null == _currVal) {
			_currVal = _getter.invoke();
		}
	}

	function toggle() {
		var idx = 0;
		for(; idx < _enumValues.size(); idx++) {
			if(_enumValues[idx].get(:value) == _currVal) {
				idx++;
				break;
			} 
		}
		
		System.println(idx.toString());
		
		idx = idx < _enumValues.size() ? idx : (idx % _enumValues.size());
		
		setSubLabel(_enumValues[idx].get(:description));
		_currVal = _enumValues[idx].get(:value);
		
		_setter.invoke(_currVal);
	}
}