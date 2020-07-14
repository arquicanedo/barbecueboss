using Toybox;
using Toybox.WatchUi;

class ListDrawable extends Toybox.WatchUi.Drawable {
	
	hidden var _listX;
	hidden var _listY;
	hidden var _listItemOffsetY;
	hidden var _maxItems;
	hidden var _selectorColor;
	hidden var _selectorX;
	hidden var _items;
	hidden var _selectorText;
	hidden var _selectorFont;
	
	hidden var _params;
	
	function initialize(params) {
		WatchUi.Drawable.initialize(params);
		
		_params = params;
		_listX = params.get(:itemOriginX);
		_listY = params.get(:itemOriginY);
		_listItemOffsetY = params.get(:listItemOffsetY);
		_selectorX = params.get(:selectorOriginX);
		_selectorColor = params.get(:selectorColor);
		_selectorFont = null == params.get(:selectorFont) ? params.get(:font) : WatchUi.loadResource(params.get(:selectorFont));
		_selectorText = null == params.get(:selectorText) ? ">" : params.get(:selectorText);
	}

	function getSelectedItem() {
	
		for(var i = 0; i < _items.size(); i++) {
			if(_items[i].getSelected()){
				return _items[i];
			}
		}
		
		return null;
	}
	
	function getSelectedIndex() {
		for(var i = 0; i < _items.size(); i++) {
			if(_items[i].getSelected()){
				return i;
			}
		}
		
		return -1;
	}
	
	function getParams() {
		return _params;
	}
	
	function setItems(items) {
		_items = items;
	}
	
	function getItems() {
		return _items;
	}
	
	function getMaxItems() {
		return _maxItems;
	}
	
	function setMaxItems(max) {
		_maxItems = max;
	}

	function draw(dc) {
		dc.clear();
		self.drawItems(dc);
	}
	
	function drawItems(dc) {

		if(null == _items) {
			return;
		}
		
		for(var i = 0; i < _items.size(); i++) {
		
			var offset = _listY + (i * _listItemOffsetY);
			if(_items[i].getSelected()) {
				dc.setColor(_selectorColor, Graphics.COLOR_BLACK);
				dc.drawText(_selectorX, offset + 2, _selectorFont, _selectorText, Graphics.TEXT_JUSTIFY_LEFT);
			}
 		
 			_items[i].draw(dc, _listX, offset);
		}
	}
	
	function decideColor(steak) {
		var status = steak.getStatus();
		var initialized = steak.getInitialized();
		var targetSeconds = steak.getTimeout();
		
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