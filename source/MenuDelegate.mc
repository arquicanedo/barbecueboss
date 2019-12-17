using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class MenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            System.println("Clicked item_1");
			WatchUi.pushView(new timerView(1), new timerDelegate(), WatchUi.SLIDE_UP);
            
        } else if (item == :item_2) {
            System.println("item 2");
			WatchUi.pushView(new timerView(2), new timerDelegate(), WatchUi.SLIDE_UP);
        }
        else if (item == :item_3) {
            System.println("item 3");
			WatchUi.pushView(new timerView(3), new timerDelegate(), WatchUi.SLIDE_UP);
        }
        else if (item == :item_4) {
            System.println("item 4");
			WatchUi.pushView(new timerView(4), new timerDelegate(), WatchUi.SLIDE_UP);
        }
        else if (item == :item_5) {
            System.println("item 5");
			WatchUi.pushView(new timerView(5), new timerDelegate(), WatchUi.SLIDE_UP);
        }
    }
    
    
    function timerCooking() {
		Toybox.System.println("Cooking timer....");
	}
	
	

}