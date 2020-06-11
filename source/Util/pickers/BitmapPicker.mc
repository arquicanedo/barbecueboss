using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;

class BitmapPicker extends WatchUi.Picker {    
    hidden var mTitleText;
    hidden var mFactory;

    function initialize(bitmaps) {
    	System.println("Bitmaps initialized: " + bitmaps);
        mFactory = new BitmapFactory(bitmaps, {:addOk=>false});
        mTitleText = "";

        var string = Application.getApp().getProperty("string");
        var defaults = null;
        var titleText = Rez.Strings.bitmapPickerTitle;

        if(string != null) {
            mTitleText = string;
            titleText = string;
        }

        mTitle = new WatchUi.Text({:text=>titleText, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});

        Picker.initialize({:title=>mTitle, :pattern=>[mFactory]});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    function getTitle() {
        return mTitleText.toString();
    }

    function getTitleLength() {
        return mTitleText.length();
    }

    function isDone(value) {
        return mFactory.isDone(value);
    }
}