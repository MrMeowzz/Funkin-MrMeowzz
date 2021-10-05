package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class AltGameOverScreen extends MusicBeatState
{
	var replayButton:FlxSprite;
	var cancelButton:FlxSprite;

	var bf:FlxSprite;

	var txt:FlxText;

	var canChangeThing:Bool = true;

	var replaySelect:Bool = false;

	public function new():Void
	{
		super();
	}

	override function create()
	{
		FlxG.sound.playMusic(Paths.music('gameOver'), 1);

		bf = new FlxSprite(0, 30);
		bf.frames = Paths.getSparrowAtlas('deathAlt/bfDark');
		bf.animation.addByPrefix('move', "Thing", 13);
		bf.animation.play('move');
		add(bf);
		bf.screenCenter(X);

		txt = new FlxText(0, 0, 0, "", 45);
		txt.setFormat(Paths.font("vcr.ttf"), 45, FlxColor.WHITE, CENTER);
		add(txt);
		txt.text = "You Died! Replay this game?";
		txt.screenCenter();

		replayButton = new FlxSprite(FlxG.width * 0.28, FlxG.height * 0.7);
		replayButton.frames = Paths.getSparrowAtlas('deathAlt/UIDark');
		replayButton.animation.addByPrefix('selected', 'replay', 0, false);
		replayButton.animation.appendByPrefix('selected', 'selectedreplay');
		replayButton.animation.play('selected');
		add(replayButton);

		cancelButton = new FlxSprite(FlxG.width * 0.58, replayButton.y);
		cancelButton.frames = Paths.getSparrowAtlas('deathAlt/UIDark');
		cancelButton.animation.addByPrefix('selected', 'cancel', 0, false);
		cancelButton.animation.appendByPrefix('selected', 'cancelselected');
		cancelButton.animation.play('selected');
		add(cancelButton);

		changeThing();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.LEFT_P || controls.RIGHT_P)
			if (canChangeThing)
				changeThing();

		if (controls.ACCEPT && canChangeThing)
		{
			if (replaySelect)
			{
				canChangeThing = false;
				txt.visible = false;
				bf.visible = false;
				cancelButton.visible = false;
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.music('gameOverEnd'), 1, false, null, true);
				if (FlxG.save.data.instantrestart)
				{
					LoadingState.loadAndSwitchState(new PlayState());
				}
				new FlxTimer().start(0.7, function(tmr:FlxTimer)
				{
					FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
					{
						LoadingState.loadAndSwitchState(new PlayState());
					});
				});
			}
			else
			{
				FlxG.sound.music.stop();
				PlayState.deathCounter = 0;

				if (PlayState.isStoryMode)
				{
					OG.currentCutsceneEnded = false;
					FlxG.switchState(new StoryMenuState());
				}
				else
				{
					OG.currentCutsceneEnded = false;
					FlxG.switchState(new FreeplayState());
				}
			}
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;

			if (PlayState.isStoryMode)
			{
				OG.currentCutsceneEnded = false;
				FlxG.switchState(new StoryMenuState());
			}
			else
			{
				OG.currentCutsceneEnded = false;
				FlxG.switchState(new FreeplayState());
			}
		}

		super.update(elapsed);
	}

	function changeThing():Void
	{
		replaySelect = !replaySelect;

		if (replaySelect)
		{
			cancelButton.animation.curAnim.curFrame = 0;
			replayButton.animation.curAnim.curFrame = 1;
		}
		else
		{
			cancelButton.animation.curAnim.curFrame = 1;
			replayButton.animation.curAnim.curFrame = 0;
		}
	}
}
