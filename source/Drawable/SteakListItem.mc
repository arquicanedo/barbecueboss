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
	static var MeatMap;
	hidden static var _iconSize;
	hidden static var _iconWidth;
	hidden static var _flipIcon;
	hidden static var _flameIcon;

	hidden var _font;
	hidden var _flipOriginX;
	hidden var _targetOriginX;
	hidden var _steak;
	hidden var _itemColor;
	hidden var _iconOffsetY;
	hidden var _flameOffsetY;
	hidden var _hasFlip = true;
	hidden var _hasFlame = true;
	hidden var _isSmoking = false;
	
	function initialize(steak, params) {
		Drawable.initialize(params);
	
		_steak = steak;
		_font = params.get(:font);
		_flipOriginX = params.get(:flipOriginX);
		_targetOriginX = params.get(:targetOriginX);
		_itemColor = params.get(:itemColor);
		_iconOffsetY = null == params.get(:iconOffsetY) ? 10 : params.get(:iconOffsetY);
		_iconSize = null == params.get(:iconSize) ? SteakListItem.MEDIUM : params.get(:iconSize);
		_isSmoking = null == params.get(:isSmoking) ? false : params.get(:isSmoking);
		
		var hasFlip = params.get(:hasFlip);
		var hasFlame = params.get(:hasFlame);


	
		if(null != hasFlip) {
			_hasFlip = hasFlip;
		}	
		
		if(null != hasFlame) {
			_hasFlame = hasFlame;
		}
		
		
		if(null == _iconWidth || null == _flipIcon || null == _flameIcon) {
			
			var flipResource = null;
			var flameResource = null;
			
			switch(_iconSize) {
				
				case SteakListItem.SMALL:
					_iconWidth = 16;
					flipResource = Rez.Drawables.FlipIconSmall;
					flameResource = Rez.Drawables.FlameIconSmall;
					break;
					
				case SteakListItem.MEDIUM:
					_iconWidth = 24;
					flipResource = Rez.Drawables.FlipIconMedium;
					flameResource = Rez.Drawables.FlameIconLarge;
					break;
					
				case SteakListItem.LARGE:
					_iconWidth = 32;
					flipResource = Rez.Drawables.FlipIconLarge;
					flameResource = Rez.Drawables.FlameIconLarge;
					break;
					
				case SteakListItem.EXTRA_LARGE:
					_iconWidth = 64;
					flipResource = Rez.Drawables.FlipIconLarge;
					flameResource = Rez.Drawables.FlameIconLarge;
					break;
			}
			
			if(null == _flipIcon && _hasFlip) {
				_flipIcon = WatchUi.loadResource(flipResource);
			}
			
			if(null == _flameIcon && _hasFlame) {
				_flameIcon = WatchUi.loadResource(flameResource);
			}
		}
		
		//if this is the first SteakListItem to be created we need to go ahead and initialize the dictionary
		//that maps a food type enum -> bitmap
		if(null == MeatMap) {
			MeatMap = {};
		}
			
		//if we haven't yet loaded the bitmap for this food type, load it and store it in the map/cache
		if(null == MeatMap.get(steak.getFoodType())) {
			MeatMap.put(steak.getFoodType(), self.getMeatImage(steak.getFoodType()));
		}
	}
	
	function dispose() {
		_font = null;
		_flipOriginX = null;
		_targetOriginX = null;
		_steak = null;
		_itemColor = null;
		_iconOffsetY = null;
		_flameOffsetY = null;
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
						Rez.Drawables has :BurgerIconLarge ? WatchUi.loadResource(Rez.Drawables.BurgerIconLarge) : null;
				
			case SteakEntry.BAKE:
				return _iconSize == SteakListItem.SMALL ? 
							WatchUi.loadResource(Rez.Drawables.BakeIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.BakeIconMedium) :
						Rez.Drawables has :BakeIconLarge ? WatchUi.loadResource(Rez.Drawables.BakeIconLarge) : null;

			case SteakEntry.CHICKEN:
				return _iconSize == SteakListItem.SMALL ? 
							WatchUi.loadResource(Rez.Drawables.ChickenIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.ChickenIconMedium) :
						Rez.Drawables has :ChickenIconLarge ? WatchUi.loadResource(Rez.Drawables.ChickenIconLarge) : null;

			case SteakEntry.CORN:
				return _iconSize == SteakListItem.SMALL ? 
							WatchUi.loadResource(Rez.Drawables.CornIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.CornIconMedium) :
						Rez.Drawables has :CornIconLarge ? WatchUi.loadResource(Rez.Drawables.CornIconLarge) : null;

			case SteakEntry.FISH:
				return _iconSize == SteakListItem.SMALL ?
							WatchUi.loadResource(Rez.Drawables.FishIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.FishIconMedium) :
						Rez.Drawables has :FishIconLarge? WatchUi.loadResource(Rez.Drawables.FishIconLarge) : null;

			case SteakEntry.BEEF:
				return _iconSize == SteakListItem.SMALL ?
							WatchUi.loadResource(Rez.Drawables.BeefIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.BeefIconMedium) :
						Rez.Drawables has :BeefIconLarge ? WatchUi.loadResource(Rez.Drawables.BeefIconLarge) : null;

			case SteakEntry.DRINK:
				return _iconSize == SteakListItem.SMALL ?
							WatchUi.loadResource(Rez.Drawables.DrinkIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.DrinkIconMedium) :
						Rez.Drawables has :DrinkIconLarge ? WatchUi.loadResource(Rez.Drawables.DrinkIconLarge) : null;
						
			case SteakEntry.SMOKE:
				return _iconSize == SteakListItem.SMALL ?
							WatchUi.loadResource(Rez.Drawables.SmokeIconSmall) :
						_iconSize == SteakListItem.MEDIUM ?
							WatchUi.loadResource(Rez.Drawables.SmokeIconMedium) :
						_iconSize == SteakListItem.LARGE ? 
							WatchUi.loadResource(Rez.Drawables.SmokeIconLarge) :
						_iconSize == SteakListItem.EXTRA_LARGE ? WatchUi.loadResource(Rez.Drawables.SmokeIconExtraLarge) : null;
			default:
				System.println("Unknown meat type when fetching icon, returning beef.");
				return WatchUi.loadResource(Rez.Drawables.BeefIconSmall);
				
		}
	}
	
	function getSelected() {
		return _steak.getSelected();
	}
	
	function getSteak() {
		return _steak;
	}
	
	/*
		draws the list entry on the screen. The list itself just tells the entries where to position themselves, and the entries draw themselves on the screen
		in this case we'll draw some text for flip/timer but draw a bitmap for the food type
		we use the _meatMap dictionary to fetch the appropriate cached image so we don't have to do the heavy lifting of loading a resource while we're
		trying to draw on the screen so it executes quickly
	*/
	function draw(dc, x, y) {
		Drawable.draw(dc);
		
		// Food type - fetch the icon to use from the static bitmap cache and draw it
		dc.drawBitmap(x, y + _iconOffsetY, MeatMap.get(_steak.getFoodType()));
		
		// ETA
		//dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		//dc.drawText(_targetOriginX, 0, _font, _steak.getETAString(), Graphics.TEXT_JUSTIFY_LEFT);
		
		// Color affects only the running timer and flip
		dc.setColor(self.decideColor(), Graphics.COLOR_BLACK);
		
		if(_hasFlip) {
			// Flip Icon		
			dc.drawBitmap(_flipOriginX, y + _iconOffsetY, _flipIcon);
			// Flip counter
			dc.drawText(_flipOriginX + _iconWidth + 5, y, _font, _steak.getCurrentFlip().toString(), Graphics.TEXT_JUSTIFY_LEFT);
		}
		
		if(_hasFlame) {
			// Flame if we're getting close to a flip.
			if (_steak.getStatus() == Controller.COOKING && _steak.getTimeout() <= 20) {
	    		dc.drawBitmap(_targetOriginX - _iconWidth - 2, y + _iconOffsetY, _flameIcon);
	    	}
	    }

    	// Timeout
    	if(_isSmoking) {
    		dc.drawText(_targetOriginX, y, _font, _steak.getSmokeTimeoutString(), Graphics.TEXT_JUSTIFY_LEFT); 
    	}
    	else {
    		dc.drawText(_targetOriginX, y, _font, _steak.getTimeoutString(), Graphics.TEXT_JUSTIFY_LEFT); 
    	}
    	

	}
	
	function decideColor() {
		var status = _steak.getStatus();
		var initialized = _steak.getInitialized();
		//var targetSeconds = _steak.getTargetSeconds();
		var targetSeconds = _steak.getTimeout();
		
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