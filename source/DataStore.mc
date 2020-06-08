using Toybox.Application;
//using Toybox.Application.Storage;


class DataStore {

	hidden var app;
	
	function initialize() {
		self.app = Application.getApp();
		return true;
	}
	
	function getValue(key) {
		System.println("DataStore fetching " + key);
		return self.app.getProperty(key);
	}
	
	function setValue(key, value) {
		System.println("DataStore storing " + key + " " + value);
		self.app.setProperty(key, value);
	}
}