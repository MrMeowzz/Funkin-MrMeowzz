package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import openfl.Lib;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	var playingDeathSound:Bool = false;
	public static var daBf:String = '';

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		
		switch (daStage)
		{
			case 'school':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';

			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		if (PlayState.SONG.song.toLowerCase() == 'stress')
			daBf = 'bf-holding-gf-dead';

		if (PlayState.SONG.player1 == "tankman-pixel")
			daBf = 'tankman-pixel-dead';

		if (PlayState.SONG.player1 == "pico-pixel")
			daBf = 'pico-pixel-dead';

		if (PlayState.SONG.player1 == "bf-amogus")
			daBf = 'bf-amogus';

		if (daBf == 'bf' && FlxG.save.data.cleanmode)
			daBf = 'bfclean';

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.updateFramerate = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;

			if (PlayState.isStoryMode)
			{
				OG.gunsCutsceneEnded = false;
				OG.ughCutsceneEnded = false;
				OG.stressCutsceneEnded = false;
				OG.horrorlandCutsceneEnded = false;
				FlxG.switchState(new StoryMenuState());
			}
			else
			{
				FlxG.switchState(new FreeplayState());
			}
		}

		#if desktop
		if (FlxG.keys.justPressed.F11 || FlxG.keys.justPressed.F)
        {
			FlxG.save.data.fullscreen = !FlxG.fullscreen;
			FlxG.save.flush();	
        	FlxG.fullscreen = !FlxG.fullscreen;
        }
		#end

		var fps = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());
		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01 * (120 / (fps / 60)) / fps);
		}

		if (PlayState.storyWeek == 7 && bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && !playingDeathSound)
		{
			playingDeathSound = true;
			coolStartDeath(0.2);
			var jeffclean:Array<Int> = [];
			if (FlxG.save.data.cleanmode)
				jeffclean = [1, 3, 8, 13, 17, 21];
			FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, jeffclean)), 1, false, null, true, function() 
			{ 
				FlxG.sound.music.fadeIn(4, 0.2, 1);
			});
		}
		else if ((PlayState.SONG.song.toLowerCase() == "no among us" || PlayState.SONG.song.toLowerCase() == "h.e. no among us") && bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && !playingDeathSound)
		{
			playingDeathSound = true;
			coolStartDeath(0.2);
			var noamongusclean:Array<Int> = [];
			if (FlxG.save.data.cleanmode)
				noamongusclean = [2, 5, 6];
			FlxG.sound.play(Paths.sound('Gameover-' + FlxG.random.int(1, 6, noamongusclean)), 1, false, null, true, function() 
			{ 
				FlxG.sound.music.fadeIn(4, 0.2, 1);
			});
		}
		else if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			coolStartDeath();
		}
			

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	public function coolStartDeath(banana:Float = 1)
	{
		FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), banana);
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
