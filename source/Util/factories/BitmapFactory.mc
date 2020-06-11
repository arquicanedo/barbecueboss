using Toybox.Graphics;
using Toybox.WatchUi;

class BitmapFactory extends WatchUi.PickerFactory {
    hidden var mBitmapSet;
    hidden var mAddOk;
    const DONE = -1;

    function initialize(bitmapSet, options) {
        PickerFactory.initialize();
        // Dictionary that maps key (SteakEntry.FoodType -> Bitmap)
        mBitmapSet = bitmapSet;
        mAddOk = (null != options) and (options.get(:addOk) == true);
    }
    
    function getValue(index) {
		return mBitmapSet[index];
    }

    function getDrawable(item, selected) {
    	System.println(mBitmapSet);
    	System.println(item + " " + selected);
    	
    	var bitmap = new WatchUi.Bitmap({
		    :rezId=>self.mBitmapSet[item],
		    :locX =>WatchUi.LAYOUT_HALIGN_CENTER, 
		    :locY=>WatchUi.LAYOUT_VALIGN_CENTER
		});

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
