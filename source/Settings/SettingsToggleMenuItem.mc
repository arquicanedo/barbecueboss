using Toybox;
using Toybox.WatchUi;

class SettingsToggleMenuItem extends WatchUi.ToggleMenuItem {

	hidden var _getter;
	hidden var _setter;
	
	function initialize(label, sublabel, identifier, enabled, options) {
		ToggleMenuItem.initialize(label, sublabel, identifier, enabled, options);
		
		_getter = options.get(:getter);
		_setter = options.get(:setter);
		
	}

	function toggle() {
		_setter.invoke(!_getter.invoke());
	}
}