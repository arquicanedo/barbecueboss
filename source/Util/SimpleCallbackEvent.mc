using Toybox.System;

/*
	NAB
	this is a simple event emitter. you construct the event with a name. 
	
	you can then add a callback method by calling .on(method(mymethod))
	to fire the event, call .emit(someValue)
	
	all subscriber methods to the event should have a function signature like:
	
	function myListener(sender, value)
	
	sender - the event instance that is emitting
	value - the value supplied by the emitter to be passed to the listener

*/

public class SimpleCallbackEvent {

	private var callbackMethod;
	private var eventName;
	
	public function initialize(eventName) {
		self.eventName = eventName;
	}

	public function getName() {
		return self.eventName;
	}
	
	public function reset() {
		self.callbackMethod = null;
	}
	
	public function on(callbackMethod){
		
		if(null != self.callbackMethod){
			System.println("event: " + self.eventName + " already has a callback when subscribing");
		}
		
		self.callbackMethod = callbackMethod;
	}

	public function emit(value) {
		System.println("emitting event " + self.eventName);
		
		if(null != self.callbackMethod) {
			self.callbackMethod.invoke(self, value);
		}
	}
}
