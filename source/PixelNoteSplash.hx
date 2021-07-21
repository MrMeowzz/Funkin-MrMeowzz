package;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;

using StringTools;

class PixelNoteSplash extends FlxSprite {
    public function new(xPos:Float,yPos:Float,?data:Int = 0) {
        super(xPos,yPos);
        loadGraphic(Paths.image('noteSplashes-pixels'), true, 50, 50);
        animation.add("note1-0", [8, 9, 10, 11], 24, false);
		animation.add("note2-0", [16, 17, 18, 19], 24, false);
		animation.add("note0-0", [0, 1, 2, 3], 24, false);
		animation.add("note3-0", [24, 25, 26, 27], 24, false);

		animation.add("note1-1", [12, 13, 14, 15], 24, false);
		animation.add("note2-1", [20, 21, 22, 23], 24, false);
		animation.add("note0-1", [4, 5, 6, 7], 24, false);
		animation.add("note3-1", [28, 29, 30, 31], 24, false);
        setupNoteSplash(xPos,xPos,data,true);
    }
    public function setupNoteSplash(xPos:Float, yPos:Float, ?data:Int = 0,Resize:Bool = false) {
        setPosition(xPos, yPos);
        alpha = 0.6;
        if (Resize)
        {
            setGraphicSize(Std.int(width * PlayState.daPixelZoom));
		    updateHitbox();
        }
        animation.play("note"+data+"-"+FlxG.random.int(0,1), true);
        updateHitbox();
        offset.set(-20, -10);
    }
    override public function update(elapsed) {
        if (animation.curAnim.finished) {
            kill();
        }
        super.update(elapsed);
    }
}