using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

/*
class StringPickerDelegate extends WatchUi.PickerDelegate {
    hidden var mPicker;

    function initialize(picker) {
        PickerDelegate.initialize();
        mPicker = picker;
    }

    function onCancel() {
        if(0 == mPicker.getTitleLength()) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        else {
            mPicker.removeCharacter();
        }
        return true;
    }

    function onAccept(values) {
        if(!mPicker.isDone(values[0])) {
            mPicker.addCharacter(values[0]);
            return false;
        }
        else {
            if(mPicker.getTitle().length() == 0) {
                Application.getApp().controller.deleteValue("string");
            }
            else {
                Application.getApp().controller.setValue("string", mPicker.getTitle());
            }
            return true;
        }
    }
}
*/