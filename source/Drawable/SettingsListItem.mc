using Toybox;
using Toybox.WatchUi;

class SettingsListItem extends WatchUi.Drawable {

	//hidden static var _glyphFont;
	hidden static var _onImage;
	hidden static var _offImage;
	hidden static var _offsetCenterY;
		
	hidden var _text;
	hidden var _statusGetter;
	hidden var _statusSetter;
	hidden var _status = false;
	hidden var _font;
	hidden var _selected = false;	// This relates to the user selection

	
	function initialize(text, textFont, getter, setter) {
		Drawable.initialize({});	
		
		_text = text;
		_font = textFont;
		_statusGetter = getter;
		_statusSetter = setter;
		
		_status = false;
		
		if(null == _onImage) {
			
			_onImage = WatchUi.loadResource(Rez.Drawables.SwitchOnIconMedium);
			_offImage = WatchUi.loadResource(Rez.Drawables.SwitchOffIconMedium);
			
			//figure out how many px on the vertical to nudge the toggle icon to center against the row text
			_offsetCenterY = (Graphics.getFontHeight(_font) - _onImage.getHeight());
			
			if(_offsetCenterY < 0) {
				_offsetCenterY *= -1;
			}
		}
		
		_status = _statusGetter.invoke();
	}

	function getStatus() {
		return _status;
	}
	
	function setStatus(status) {
		_status = status;
		_statusSetter.invoke(status);
	}

	function draw(dc, x, y) {
		Drawable.draw(dc);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(x + 5, y, _font, _text, Graphics.TEXT_JUSTIFY_LEFT);
		
		var img = _status ? _onImage : _offImage;
		var width = dc.getWidth();
		
		dc.drawBitmap(dc.getWidth() - (img.getWidth() * 2), y + _offsetCenterY, img); 
	}
	
	function setSelected(selected){
		_selected = selected;
	}
	
	function getSelected() {
		return _selected;
	}
	
}