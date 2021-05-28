package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;

class RunningTankman extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('tankmanKilled1');
        antialiasing = true;
        animation.addByPrefix("run", "tankman running", 24, true);
        animation.addByPrefix("shot", "John Shot " + FlxG.random.int(1,2), 24, false);
        setGraphicSize(Std.int(0.8 * width));
        updateHitbox();
        animation.play("run");
	}
}
