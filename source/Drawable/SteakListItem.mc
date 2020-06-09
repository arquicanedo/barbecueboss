using Toybox;
using Toybox.WatchUi;
using Toybox.Graphics;

class SteakListItem extends WatchUi.Drawable {

	hidden var _font;
	hidden var _flipOriginX;
	hidden var _targetOriginX;
	hidden var _steak;
	hidden var _itemColor;
	
	function initialize(steak, params) {
		Drawable.initialize(params);
		
		_steak = steak;
		_font = params.get(:font);
		_flipOriginX = params.get(:flipOriginX);
		_targetOriginX = params.get(:targetOriginX);
		_itemColor = params.get(:itemColor);
	}
	
	function getSelected() {
		return _steak.getSelected();
	}
	
	function draw(dc, x, y) {
		Drawable.draw(dc);
	
		dc.setColor(self.decideColor(), Graphics.COLOR_BLACK);
		dc.drawText(x, y, _font, _steak.getLabel(), Graphics.TEXT_JUSTIFY_LEFT);
		dc.drawText(_flipOriginX, y, _font, _steak.getFlipString(), Graphics.TEXT_JUSTIFY_LEFT);
		dc.drawText(_targetOriginX, y, _font, _steak.getTargetString(), Graphics.TEXT_JUSTIFY_LEFT); 
	}
	
	function decideColor() {
		var status = _steak.getStatus();
		var initialized = _steak.getInitialized();
		var targetSeconds = _steak.getTargetSeconds();
		
		if (status == Controller.INIT) {
			return _itemColor;
    	}
    	else {
    		if (status == Controller.COOKING && targetSeconds <= 20 && targetSeconds > 10) {
    			return Graphics.COLOR_ORANGE;
    		}
    		else if (initialized && status == Controller.COOKING && targetSeconds <= 10) {
    			return Graphics.COLOR_RED;
    		}
    		else {
    			return Graphics.COLOR_WHITE;
    		}
    	}
    }
	
}