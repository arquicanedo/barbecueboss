using Toybox;
using Toybox.WatchUi;
using Toybox.Graphics;

(:btle)
class ProbeTempDrawable extends WatchUi.Drawable {

	hidden var _numProbes = 1;
	hidden var _startProbe = 0;
	hidden var _temps;
	hidden var _x = 0;
	hidden var _y = 0;
	hidden var _width = 0;
	hidden var _height = 0;
	
	function initialize(settings) {
		Drawable.initialize(settings);
		
		if(null != settings.get(:numProbes)) {
			_numProbes = settings.get(:numProbes);
		}
		
		if(null != settings.get(:startProbe)) {
			_startProbe = settings.get(:startProbe);
		}
		
		if(null != settings.get(:x)) {
			_x = settings.get(:x);
		}
		
		if(null != settings.get(:y)) {
			_y = settings.get(:y);
		}
		
		if(null != settings.get(:width)) {
			_width = settings.get(:width);
		}
		
		if(null != settings.get(:height)) {
			_height = settings.get(:height);
		}
	}
	
	function setTemps(temps) {
		_temps = temps;
	}
	
	function draw(dc) {
	
		if(null == _temps) {
			return;
		}
		
		var width = (_width / _numProbes);
		var middle = (_height / 2) + _y;
		var start = _x;
		
		for(var i = _startProbe; i < (_startProbe + _numProbes) && i < _temps.size(); i++) {
			if(-1 == _temps[i])  {
				dc.drawText(start, middle, Graphics.FONT_XTINY, "X", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
			}
			else {
				dc.drawText(start, middle, Graphics.FONT_XTINY, _temps[i].format("%1d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
			}
			start += width;
		} 
	}
}