using Toybox;
using Toybox.WatchUi;

class SteakListDrawable extends Toybox.WatchUi.Drawable {
	
	hidden var _listX;
	hidden var _listY;
	hidden var _targetOriginX;
	hidden var _flipOriginX;
	hidden var _font;
	hidden var _justification;
	hidden var _listItemOffsetY;
	hidden var _maxSteaks;
	hidden var _selectorColor;
	hidden var _itemColor;
	hidden var _selectorX;
	hidden var _steaks;
	hidden var _selectorText;
	hidden var _selectorFont;
	//hidden var _flipFont;
	hidden var _flipText;
	
	function initialize(params) {
		WatchUi.Drawable.initialize(params);
		
		_listX = params.get(:itemOriginX);
		_listY = params.get(:itemOriginY);
		_listItemOffsetY = params.get(:listItemOffsetY);
		_selectorX = params.get(:selectorOriginX);
		_font = params.get(:font);
		_justification = params.get(:listJustification);
		_selectorColor = params.get(:selectorColor);
		_itemColor = params.get(:itemColor);
		_targetOriginX = params.get(:targetOriginX);
		_flipOriginX = params.get(:flipOriginX);
		_selectorFont = null == params.get(:selectorFont) ? _font : WatchUi.loadResource(params.get(:selectorFont));
		_selectorText = null == params.get(:selectorText) ? ">" : params.get(:selectorText);
		_flipText = null == params.get(:flipText) ? ">" : params.get(:flipText);
		//_selectorFont = null == params.get(:selectorFont) ? _font : WatchUi.loadResource(params.get(:selectorFont));
	}

	function setSteaks(steaks) {
		_steaks = steaks; 
	}
	
	function getMaxSteaks() {
		return _maxSteaks;
	}
	
	function setMaxSteaks(max) {
		_maxSteaks = max;
	}

	function draw(dc) {
		dc.clear();
		self.drawItems(dc);
	}
	
	function drawItems(dc) {

		if(null == _steaks) {
			return;
		}
		
		var length = _steaks.size();
		for(var i = 0; i < length; i++) {
		
			var offset = _listY + (i * _listItemOffsetY);
			if(_steaks[i].getSelected()) {
				dc.setColor(_selectorColor, Graphics.COLOR_BLACK);
				dc.drawText(_selectorX, offset + 2, _selectorFont, _selectorText, _justification);
			}
 		
			dc.setColor(decideColor(_steaks[i]), Graphics.COLOR_BLACK);
			dc.drawText(_listX, offset, _font, _steaks[i].getLabel(), _justification);
			dc.drawText(_flipOriginX, offset, _font, _steaks[i].getFlipString(), _justification);
			dc.drawText(_targetOriginX, offset, _font, _steaks[i].getTargetString(), _justification); 
		}
	}
	
	function decideColor(steak) {
		var status = steak.getStatus();
		var initialized = steak.getInitialized();
		var targetSeconds = steak.getTargetSeconds();
		
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