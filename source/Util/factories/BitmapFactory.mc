using Toybox.Graphics;
using Toybox.WatchUi;

class BitmapFactory extends WatchUi.PickerFactory {
    hidden var mBitmapSet;
    hidden var mAddOk;
    const DONE = -1;
    hidden var app;

    function initialize(bitmapSet, options) {
        PickerFactory.initialize();
        // Dictionary that maps key (SteakEntry.FoodType -> Bitmap)
        mBitmapSet = bitmapSet;
        mAddOk = (null != options) and (options.get(:addOk) == true);        
        app = Application.getApp();
    }
    
    function getValue(index) {
		return mBitmapSet[index];
    }
    
    function getIndex(item) {
    	return mBitmapSet.indexOf(item);
    }

    function getDrawable(item, selected) {
    	System.println(mBitmapSet);
    	System.println(item + " " + selected);
    	
    	var bitmap = new WatchUi.Bitmap({
		    :rezId=>self.mBitmapSet[item],
		    :locX =>WatchUi.LAYOUT_HALIGN_CENTER, 
		    :locY=>WatchUi.LAYOUT_VALIGN_CENTER
		});

		// Hack, I can't return [bitmap, item] and propagate it back to the SteakMenuDelegate
		app.controller.lastSelectedFoodType = item;
        return bitmap;
    }

    function isDone(value) {
        return mAddOk and (value == DONE);
    }
    
    function getSize() {
    	System.println(mBitmapSet.size());
        return mBitmapSet.size() + ( mAddOk ? 1 : 0 );
    }
}
