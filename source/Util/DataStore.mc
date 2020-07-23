using Toybox.Application;
//using Toybox.Application.Storage;


class DataStore {

	hidden var app;
	
	function initialize(app) {
		self.app = app;
		return true;
	}
	
	//(:ciq1)
	function getValue(key) {
		var value = self.app.getProperty(key);
		//System.println("DataStore fetching " + key + " " + value);
		return value;
	}
	
	//(:ciq1)
	function setValue(key, value) {
		//System.println("DataStore storing " + key + " " + value);
		self.app.setProperty(key, value);
	}
}