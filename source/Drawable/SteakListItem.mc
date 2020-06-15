using Toybox;
using Toybox.WatchUi;
using Toybox.Graphics;

class SteakListItem extends WatchUi.Drawable {

	public enum {
		SMALL = 0,
		MEDIUM = 1,
		LARGE = 2,
		EXTRA_LARGE = 3,
		HUGE = 4
	}
	
	//all instances of the list item will have the same shared dictionary of meat type -> icon to save memory
	hidden static var _meatMap;
	hidden static var _iconSize;
	hidden static var _iconWidth;
	hidden static var _flipIcon;
	
	hidden var _font;
	hidden var _flipOriginX;
	hidden var _targetOriginX;
	hidden var _steak;
	hidden var _itemColor;
	hidden var _iconOffsetY;
	
	
	function initialize(steak, params) {
		Drawable.initialize(params);
	
		_steak = steak;
		_font = params.get(:font);
		_flipOriginX = params.get(:flipOriginX);
		_targetOriginX = params.get(:targetOriginX);
		_itemColor = params.get(:itemColor);
		_iconOffsetY = null == params.get(:iconOffsetY) ? 10 : params.get(:iconOffsetY);
		_iconSize = null == params.get(:iconSize) ? SteakListItem.MEDIUM : params.get(:iconSize);
		
		if(null == _iconWidth || null == _flipIcon) {
			switch(_iconSize) {
				case SteakListItem.SMALL:
					_iconWidth = 16;
					_flipIcon = WatchUi.loadResource(Rez.Drawables.FlipIconSmall);
					break;
				case SteakListItem.MEDIUM:
					_iconWidth = 24;
					_flipIcon = WatchUi.loadResource(Rez.Drawables.FlipIconMedium);
					break;
				case SteakListItem.LARGE:
					_iconWidth = 32;
					_flipIcon = WatchUi.loadResource(Rez.Drawables.FlipIconLarge);
					break;
			}
		}
		
		//if this is the first SteakListItem to be created we need to go ahead and initialize the dictionary
		//that maps a food type enum -> bitmap
		if(null == _meatMap) {
			_meatMap = {};
		}
			
		//if we haven't yet loaded the bitmap for this food type, load it and store it in the map/cache
		if(null == _meatMap.get(steak.getFoodType())) {
			_meatMap.put(steak.getFoodType(), self.getMeatImage(steak.getFoodType()));
		}
	}
	
	/*
		this method takes a food type enum and loads/returns the appropriate bitmap from the resources
	*/
	function getMeatImage(meatType) {
		switch(meatType) {
			case SteakEntry.BURGER:
				return _iconSize == SteakListItem.SMALL ? 
							WatchUi.loadResource(Rez.Drawables.BurgerIconSmall) : 
						_iconSize == SteakListItem.MEDIUM ? 
							WatchUi.loadResource(Rez.Drawables.BurgerIconMedium) : 
						WatchUi.loadResource(Rez.Drawables.BurgerIconLarge);
				
			case SteakEntry.BAKE:
				return _iconSize == SteakListItem.SMALL ? 
							WatchUi.loadResource(Rez.Drawables.BakeIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.BakeIconMedium) :
						WatchUi.loadResource(Rez.Drawables.BakeIconLarge);

			case SteakEntry.CHICKEN:
				return _iconSize == SteakListItem.SMALL ? 
							WatchUi.loadResource(Rez.Drawables.ChickenIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.ChickenIconMedium) :
						WatchUi.loadResource(Rez.Drawables.ChickenIconLarge);

			case SteakEntry.CORN:
				return _iconSize == SteakListItem.SMALL ? 
							WatchUi.loadResource(Rez.Drawables.CornIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.CornIconMedium) :
						WatchUi.loadResource(Rez.Drawables.CornIconLarge);

			case SteakEntry.FISH:
				return _iconSize == SteakListItem.SMALL ?
							WatchUi.loadResource(Rez.Drawables.FishIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.FishIconMedium) :
						WatchUi.loadResource(Rez.Drawables.FishIconLarge);

			case SteakEntry.BEEF:
				return _iconSize == SteakListItem.SMALL ?
							WatchUi.loadResource(Rez.Drawables.BeefIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.BeefIconMedium) :
						WatchUi.loadResource(Rez.Drawables.BeefIconLarge);

			case SteakEntry.DRINK:
				return _iconSize == SteakListItem.SMALL ?
							WatchUi.loadResource(Rez.Drawables.DrinkIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.DrinkIconMedium) :
						WatchUi.loadResource(Rez.Drawables.DrinkIconLarge);
			default:
				System.println("Unknown meat type when fetching icon, returning beef.");
				return WatchUi.loadResource(Rez.Drawables.BeefIconSmall);
				
		}
	}
	
	function getSelected() {
		return _steak.getSelected();
	}
	
	/*
		draws the list entry on the screen. The list itself just tells the entries where to position themselves, and the entries draw themselves on the screen
		in this case we'll draw some text for flip/timer but draw a bitmap for the food type
		we use the _meatMap dictionary to fetch the appropriate cached image so we don't have to do the heavy lifting of loading a resource while we're
		trying to draw on the screen so it executes quickly
	*/
	function draw(dc, x, y) {
		Drawable.draw(dc);
	
		dc.setColor(self.decideColor(), Graphics.COLOR_BLACK);
		
		//fetch the icon to use from the static bitmap cache and draw it
		dc.drawBitmap(x, y + _iconOffsetY, _meatMap.get(_steak.getFoodType()));
		dc.drawText(x + _iconWidth + 5, y, _font, _steak.getFoodTypeCount().toString(), Graphics.TEXT_JUSTIFY_LEFT); 
		
		dc.drawBitmap(_flipOriginX, y + _iconOffsetY, _flipIcon);
		//dc.drawText(_flipOriginX, y, _font, "Flip", Graphics.TEXT_JUSTIFY_LEFT);
		dc.drawText(_flipOriginX + _iconWidth + 5, y, _font, _steak.getTotalFlips().toString(), Graphics.TEXT_JUSTIFY_LEFT);
		
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