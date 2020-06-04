using Toybox;

class Util {

	static function fontStringToSymbol(stringVal) {
		switch(stringVal) {
			case "Graphics.FONT_XTINY":
				return Graphics.FONT_XTINY;
			case "Graphics.FONT_TINY": 
				return Graphics.FONT_TINY;
			case "Graphics.FONT_SMALL":
				return Graphics.FONT_SMALL;
			case "Graphics.FONT_MEDIUM":
				return Graphics.FONT_MEDIUM;
			case "Graphics.FONT_LARGE":
				return Graphics.FONT_LARGE;
				
			default:
				return Graphics.FONT_MEDIUM;
		}
	}
	
	static function justificationStringToSymbol(stringVal) {
		switch(stringVal) {
			case "Graphics.TEXT_JUSTIFY_RIGHT":
				return Graphics.TEXT_JUSTIFY_RIGHT;
			case "Graphics.TEXT_JUSTIFY_LEFT":
				return Graphics.TEXT_JUSTIFY_LEFT;
			case "Graphics.TEXT_JUSTIFY_CENTER":
				return Graphics.TEXT_JUSTIFY_CENTER;
			default:
				return Graphics.TEXT_JUSTIFY_LEFT;
		}
	}
}