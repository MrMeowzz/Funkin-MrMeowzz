package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

using StringTools;

class Boyfriend extends Character
{
	public var stunned:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'bf')
	{
		super(x, y, char, true);
	}

	override function update(elapsed:Float)
	{
		if (!debugMode)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
			else
				holdTimer = 0;
			
			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, false, 10);
				if (PlayState.SONG.player1.startsWith('gf'))
					PlayState.boyfriend.dance();
			}

			if (PlayState.boyfriend.color != FlxColor.WHITE && animation.curAnim.finished && !debugMode)
			{
				PlayState.boyfriend.color = FlxColor.WHITE;
				playAnim('idle', true, false, 10);
				if (PlayState.SONG.player1.startsWith('gf'))
					PlayState.boyfriend.dance();
			}

			if (animation.curAnim.name.endsWith('alt') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, false, 10);
			}

			if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
			{
				playAnim('deathLoop');
			}
		}

		super.update(elapsed);
	}
}
