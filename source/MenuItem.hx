package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import openfl.Lib;

class MenuItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;
	public var weekNum:Int;
	public var flashingInt:Int = 0;

	public function new(x:Float, y:Float, weekNum:Int = 0, folder:String)
	{
		super(x, y);
		week = new FlxSprite().loadGraphic(Paths.image('storymenu/' + folder + '/week' + weekNum));
		this.weekNum = weekNum;
		add(week);
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		isFlashing = true;
	}

	// if it runs at 60fps, fake framerate will be 6
	// if it runs at 144 fps, fake framerate will be like 14, and will update the graphic every 0.016666 * 3 seconds still???
	// so it runs basically every so many seconds, not dependant on framerate??
	// I'm still learning how math works thanks whoever is reading this lol
	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var fps = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());
		y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17 * (60 / fps));

		if (isFlashing)
			flashingInt += 1;

		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			if ((weekNum == 2 && Date.now().getMonth() == 9) || (Date.now().getMonth() == 9 && Date.now().getDate() == 31))
				week.color = FlxColor.WHITE;
			else if ((weekNum == 5 && Date.now().getMonth() == 11) || (Date.now().getMonth() == 11 && Date.now().getDate() == 25))
				week.color = FlxColor.RED;
			else
				week.color = 0xFF33ffff;
		else
		{
			if ((weekNum == 2 && Date.now().getMonth() == 9) || (Date.now().getMonth() == 9 && Date.now().getDate() == 31))
				week.color = FlxColor.ORANGE;
			else if ((weekNum == 5 && Date.now().getMonth() == 11) || (Date.now().getMonth() == 11 && Date.now().getDate() == 25))
				week.color = FlxColor.CYAN;
			else
				week.color = FlxColor.WHITE;
		}
	}
}
