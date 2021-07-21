package;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
class NoteSplash extends FlxSprite {
    public function new(xPos:Float,yPos:Float,?data:Int = 0) {
        super(xPos,yPos);
        var tex:FlxAtlasFrames;
        tex = Paths.getSparrowAtlas('noteSplashes');
        frames = tex;
        animation.addByPrefix("note1-0", "note impact 1  blue", 24, false);
		animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
		animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
		animation.addByPrefix("note3-0", "note impact 1 red", 24, false);

		animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
		animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
		animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
		animation.addByPrefix("note3-1", "note impact 2 red", 24, false);
        setupNoteSplash(xPos,xPos,data);
    }
    public function setupNoteSplash(xPos:Float, yPos:Float, ?data:Int = 0) {
        setPosition(xPos, yPos);
        alpha = 0.6;
        animation.play("note"+data+"-"+FlxG.random.int(0,1), true);
        updateHitbox();
        offset.set(0.3 * width, 0.3 * height);
    }
    override public function update(elapsed) {
        if (animation.curAnim.finished) {
            kill();
        }
        super.update(elapsed);
    }
}