using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.System;

(:smoke)
class SmokeCheckView extends WatchUi.View {

	hidden var _checkText;	

    function initialize(checkText) {
        View.initialize();
        self._checkText = checkText;
    }

    function onLayout(dc) {
	    View.setLayout(Rez.Layouts.SmokeCheckLayout(dc));
	    View.findDrawableById("SmokeCheckText").setText(self._checkText);
    }

    function onShow() {
        	
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }


}
