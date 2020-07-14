using Toybox;
using Toybox.WatchUi;

(:btle)
class TenergyConfigMenuInputDelegate extends WatchUi.Menu2InputDelegate {

	function initialize() {
		Menu2InputDelegate.initialize();
	}
	
	function onSelect(item) {
	
		var id = item.getId();
		
		if(id.equals("enabledItem")) {
			item.toggle();
			return;
		}
		
		if(id.equals("scanItem")){
			
			WatchUi.pushView(new TenergyScanView( 
				{ 
					:title => WatchUi.loadResource(Rez.Strings.tenergy_scan_menu_title)
				}), 
				new TenergyScanViewDelegate(), 
				WatchUi.SLIDE_UP);
				
			return; 
		}
	}
}