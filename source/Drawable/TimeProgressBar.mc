using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Math;

class TimeProgressBar extends WatchUi.Drawable {

    var mColor;
    var mWidth;
    var mHeight;
    var mPercentCompleted;
    var mRadius;
    var mYCoord;

    function initialize(color, width, height, yCoord, radius) {
        Drawable.initialize({});
        mColor = color;
        mWidth = width;
        mHeight = height;
        mRadius = radius;
        mPercentCompleted = 0;
        mYCoord = yCoord;
    }

    function draw(dc) {
        var centerX = dc.getWidth() / 2;
        var x = (centerX - (mWidth/2)).toNumber();
        var y = 10;

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.drawRoundedRectangle(x, mYCoord, self.mWidth, self.mHeight, mRadius);
        dc.setColor(mColor, mColor);
        dc.fillRoundedRectangle(x, mYCoord, (self.mWidth*mPercentCompleted).toNumber(), self.mHeight, mRadius);
    }
    
    function progress(percent) {
    	self.mPercentCompleted = percent;
    }
    
    function reset() {
    	self.mPercentCompleted = 0;
    }

}