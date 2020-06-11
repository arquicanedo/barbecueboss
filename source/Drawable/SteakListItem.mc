using Toybox;
using Toybox.WatchUi;
using Toybox.Graphics;

class SteakListItem extends WatchUi.Drawable {

	//all instances of the list item will have the same shared dictionary of meat type -> icon to save memory
	//hidden static var _meatFont = null;
	hidden static var _meatMap;
	
	
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
		
		if(null == _meatMap) {
			_meatMap = {};
		}
	
		/*if(null == _meatFont) {
			_meatFont = WatchUi.loadResource(Rez.Fonts.FONT_MEATFONT_MEDIUM);
		}*/
			
		if(null == _meatMap.get(steak.getFoodType())) {
			_meatMap.put(steak.getFoodType(), self.getMeatImage(steak.getFoodType()));
		}
	}
	
	function getMeatImage(meatType) {
		switch(meatType) {
			case SteakEntry.BURGER:
				return WatchUi.loadResource(Rez.Drawables.BurgerIconSmall);
				//return "0";
			case SteakEntry.BAKE:
				return WatchUi.loadResource(Rez.Drawables.BakeIconSmall);
				//return "1";
			case SteakEntry.CHICKEN:
				return WatchUi.loadResource(Rez.Drawable.ChickenIconSmall);
				//return "2";
			case SteakEntry.CORN:
				return WatchUi.loadResource(Rez.Drawables.CornIconSmall);
				//return "3";
			case SteakEntry.FISH:
				return WatchUi.loadResource(Rez.Drawables.FishIconSmall);
				//return "4";
			case SteakEntry.BEEF:
				return WatchUi.loadResource(Rez.Drawables.BeefIconSmall);
				//return "5";
			case SteakEntry.PORK:
				return WatchUi.loadResource(Rez.Drawables.PorkIconSmall);
				//return "6";
			case SteakEntry.LAMB:
				return WatchUi.loadResource(Rez.Drawables.LambIconSmall);
				//return "7";
			
			default:
				System.println("Unknown meat type when fetching icon, returning beef.");
				return WatchUi.loadResource(Rez.Drawables.BeefIconSmall);
				
		}
		
	}
	
	function getSelected() {
		return _steak.getSelected();
	}
	
	function draw(dc, x, y) {
		Drawable.draw(dc);
	
		dc.setColor(self.decideColor(), Graphics.COLOR_BLACK);
		//dc.drawText(x, y, _meatFont, "5", Graphics.TEXT_JUSTIFY_LEFT);
		var icon = _meatMap.get(_steak.getFoodType());
		dc.drawBitmap(x, y, icon);
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