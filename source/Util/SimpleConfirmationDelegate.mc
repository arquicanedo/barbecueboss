using Toybox.WatchUi;
using Toybox.System;

/*
	NAB
	This is a simple confirmation delegate for use with confirmation views that accepts an external callback (delegate)
	When the response from the confirmation is sent to us, we then execute the callback with the results.
*/
class SimpleDispatchConfirmationDelegate extends WatchUi.ConfirmationDelegate {
	public var response = WatchUi.CONFIRM_NO;
	public var callbackMethod;
	
	function initialize() {
		ConfirmationDelegate.initialize();
	}
	
	
	function onResponse(response) {
		self.callbackMethod.invoke(response);
	}
}