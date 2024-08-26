import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TestWFView extends WatchUi.WatchFace {

    var background;
    var hourHand;
    var minuteHand;

    function initialize() {
        background = WatchUi.loadResource(Rez.Drawables.background) as BitmapResource;
        hourHand = WatchUi.loadResource(Rez.Drawables.hour_hand) as BitmapResource;
        minuteHand = WatchUi.loadResource(Rez.Drawables.minute_hand) as BitmapResource;
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        // var clockTime = System.getClockTime();
        // var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        // var view = View.findDrawableById("TimeLabel") as Text;
        // view.setText(timeString);

        var w = dc.getWidth();
        var h = dc.getHeight();
        System.println("Screen size: "+w+"x"+h);

        // Draw background
        dc.drawBitmap((w - background.getWidth()) / 2, (h - background.getHeight()) / 2, background);

        // Get time
        var time = System.getClockTime();
        var hours = time.hour % 12 + time.min / 60;
        var minutes = time.min + time.sec / 60;

        // Calculate angles for hands rotation
        var minuteAngle = minutes*360/60;
        var hourAngle = (hours*360/12) + minuteAngle/12;
        System.println("hours="+hours+"     minutes="+minutes);
        System.println("hourAngle="+hourAngle+"     minuteAngle="+minuteAngle);
        
        // Draw hour hand
        drawRotated(dc, hourHand, w / 2, h / 2, hourAngle);

        // Draw minute hand
        drawRotated(dc, minuteHand, w / 2, h / 2, minuteAngle);

        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    // Draw with custom rotation
    function drawRotated(dc, image, cx, cy, angle) {
        var radians = Math.toRadians(angle);
        var imageX = cx - image.getWidth() / 2;
        var imageY = cy - image.getHeight() / 2;
        var transform = new Graphics.AffineTransform();
        transform.translate(cx, cy);
        transform.rotate(radians);
        transform.translate(-cx, -cy);
        dc.drawBitmap2(imageX, imageY, image, {:transform=>transform});
    }

}
