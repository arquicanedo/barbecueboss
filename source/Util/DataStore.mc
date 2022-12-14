using Toybox.Application;
//using Toybox.Application.Storage;


class DataStore {

	hidden var app;
	
	function initialize() {
		self.app = Application.getApp();
	}
	
	function getValue(key) {
		// https://forums.garmin.com/developer/connect-iq/i/bug-reports/set-getproperty-deprecate-on-sdk-4?CommentId=b16fd27e-39a3-450e-8e03-812435f75c8f
		var value;
		if(self.app has :Storage) {
            value = self.app.Storage.getValue(key);
        } else {
            value = self.app.getApp().getProperty(key);
        }
		System.println("DataStore fetching " + key + " " + value);
		return value;
	}
	
	function setValue(key, value) {
		System.println("DataStore storing " + key + " " + value);
		if(self.app has :Storage) {
            value = self.app.Storage.setValue(key, value);
        } else {
            value = self.app.getApp().setProperty(key, value);
        }
	}

	function deleteValue(key) {
		System.println("DataStore deleting " + key + " ");
		if(self.app has :Storage) {
            self.app.Storage.deleteValue(key);
        } else {
            self.app.getApp().deleteProperty(key);
        }
	}
}