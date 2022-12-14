using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;

/*
class StringPicker extends WatchUi.Picker {
    const mCharacterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    hidden var mTitleText;
    hidden var mFactory;



    function initialize() {
        mFactory = new CharacterFactory(mCharacterSet, {:addOk=>true});
        mTitleText = "";

        var string = Application.getApp().controller.storageGetValue("string");
        var defaults = null;
        var titleText = Rez.Strings.stringPickerTitle;

        if(string != null) {
            mTitleText = string;
            titleText = string;
            defaults = [mFactory.getIndex(string.substring(string.length()-1, string.length()))];
        }

        var mTitle = new WatchUi.Text({:text=>titleText, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});

        Picker.initialize({:title=>mTitle, :pattern=>[mFactory], :defaults=>defaults});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    function addCharacter(character) {
        mTitleText += character;
        mTitle.setText(mTitleText);
    }

    function removeCharacter() {
        mTitleText = mTitleText.substring(0, mTitleText.length() - 1);

        if(0 == mTitleText.length()) {
            mTitle.setText(WatchUi.loadResource(Rez.Strings.stringPickerTitle));
        }
        else {
            mTitle.setText(mTitleText);
        }
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
*/