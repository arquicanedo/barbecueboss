using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;

class BitmapPicker extends WatchUi.Picker {
    hidden var mFactory;

    function initialize(app, bitmaps, pre_selected_item) {
    	//System.println("Bitmaps initialized: " + bitmaps);
        mFactory = new BitmapFactory(app, bitmaps, {:addOk=>false});

        var string = Application.getApp().getProperty("string");

        var title = new WatchUi.Text( 
        	{
        		:text=>WatchUi.loadResource(Rez.Strings.bitmapPickerTitle), 
        		:locX =>WatchUi.LAYOUT_HALIGN_CENTER, 
        		:locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
        		:color=>Graphics.COLOR_WHITE,
        		:font=>Graphics.FONT_SMALL
        	}
        );

        Picker.initialize({:title => title, :pattern=>[mFactory], :defaults=>[pre_selected_item]});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    function isDone(value) {
        return mFactory.isDone(value);
    }
}