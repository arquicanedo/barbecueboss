using Toybox;
using Toybox.WatchUi;

class SettingsListItem extends WatchUi.Drawable {

	hidden static var _glyphFont;
	hidden static var _onText;
	hidden static var _offText;
	
	hidden var _text;
	hidden var _statusGetter;
	hidden var _statusSetter;
	hidden var _status;
	hidden var _font;
	hidden var _selected = false;
	
	function initialize(text, textFont, getter, setter) {
		Drawable.initialize({});	
		
		_text = text;
		_font = textFont;
		_statusGetter = getter;
		_statusSetter = setter;
		
		_status = false;
		
		if(null == _glyphFont) {
			_glyphFont = WatchUi.loadResource(Rez.Fonts.FONT_GLYPH3_SMALL);
			_onText = WatchUi.loadResource(Rez.Strings.glyph_3_toggle_on);
			_offText = WatchUi.loadResource(Rez.Strings.glyph_3_toggle_off);
		}
	}


	function draw(dc, x, y) {
		Drawable.draw(dc);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(x, y, _font, "testing", Graphics.TEXT_JUSTIFY_LEFT);
		
		dc.drawText(dc.getWidth() - 30, y, _glyphFont, _onText, Graphics.TEXT_JUSTIFY_RIGHT);
	}
	
	function setSelected(selected){
		_selected = selected;
	}
	
	function getSelected() {
		return _selected;
	}
}