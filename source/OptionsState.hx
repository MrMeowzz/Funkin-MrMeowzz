package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import openfl.Lib;

using StringTools;

class OptionsState extends MusicBeatState
{
	var Options:Array<String> = ['Clean Mode', 'Preload Freeplay Previews', 'Freeplay Previews', 'Color Ratings', 'Fullscreen', 'FPS Counter', 'Downscroll', 'Override Song Scroll Speed', 'Miss Stun', 'Miss Sounds'];

	var descriptions:Array<String> = ['Changes some assets to make it more appropriate.', 'Preloads the freeplay song previews so it does not lag while switching songs. Freeplay will take longer to load.', 'Disables the freeplay song previews.', 'Adds color to the ratings.', 'Makes the game fullscreen or windowed.', 'Toggles the visibility of the FPS Counter in the top left.', 'Whether to use downscroll or upscroll.', 'Whether to override the song scroll speed or not. Press the <- and -> keys if enabled. Hold shift to increase or decrease faster.', 'Whether to disable or enable miss stun. Disabling miss stun causes health to drain faster and enables anti-mash.', 'Whether to play miss sounds or not.'];

	public static var DefaultValues:Array<Bool> = [false,true,true,true,false,true,false,false,true,true];

	var OptionsON:Array<String> = ['Clean Mode ON', 'Preload Freeplay PRVWs ON', 'Freeplay Previews ON', 'Color Ratings ON', 'Fullscreen ON', 'FPS Counter ON', 'Downscroll', 'Override Song Speed ON', 'Miss Stun OFF', 'Miss Sounds ON'];

	var OptionsOFF:Array<String> = ['Clean Mode OFF', 'Preload Freeplay PRVWs OFF', 'Freeplay Previews OFF', 'Color Ratings OFF', 'Fullscreen OFF', 'FPS Counter OFF', 'Upscroll', 'Override Song Speed OFF', 'Miss Stun ON', 'Miss Sounds OFF'];

	var numberOptions:Array<Bool> = [false,false,false,false,false,false,false,true,false,false];
	
	#if html5
	var DisabledOptions:Array<Bool> = [false,true,true,false,true,false,false,false,false];
	#else
	var DisabledOptions:Array<Bool> = [false,false,false,false,false,false,false,false,false];
	#end

	var VisibleOptions:Array<String> = [];

	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<Alphabet>;

	var descriptiontxt:FlxText;

	var numtxt:FlxText;

	var timer:FlxTimer = new FlxTimer();

	var songspeed:Float = 0.1;

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		descriptiontxt = new FlxText(100, 0, 0, "", 15);
		descriptiontxt.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		add(descriptiontxt);

		numtxt = new FlxText(0, 0, 0, "sus", 30);
		numtxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		numtxt.visible = false;
		numtxt.screenCenter();
		numtxt.y += 250;
		add(numtxt);

		grpOptionsTexts = new FlxTypedGroup<Alphabet>();
		add(grpOptionsTexts);

		regenVisibleOptions();

		for (i in 0...VisibleOptions.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, VisibleOptions[i], true, false);
			// optionText.ID = i;
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpOptionsTexts.add(optionText);
		}

		if (FlxG.save.data.scrollspeed != null)
			songspeed = FlxG.save.data.scrollspeed;

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.LEFT_P)
			if (FlxG.save.data.overridespeed && Options[curSelected] == "Override Song Scroll Speed" && songspeed > 0.1)
			{
				songspeed -= 0.1;
				if (FlxG.keys.pressed.SHIFT && songspeed - 0.4 > 0.1)
					songspeed -= 0.4;
				else if (FlxG.keys.pressed.SHIFT && songspeed - 0.4 < 0.1)
					songspeed = 0.1;
			}
					

		if (controls.RIGHT_P)
			if (FlxG.save.data.overridespeed && Options[curSelected] == "Override Song Scroll Speed" && songspeed < 10)
			{
				songspeed += 0.1;
				if (FlxG.keys.pressed.SHIFT && songspeed + 0.4 < 10)
					songspeed += 0.4;
				else if (FlxG.keys.pressed.SHIFT && songspeed + 0.4 > 10)
					songspeed = 10;
			}

		if (songspeed < 0.1)
			songspeed = 0.1;
		if (songspeed > 10)
			songspeed = 10;

		numtxt.text = Std.string(songspeed);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if (FlxG.save.data.overridespeed)
			{
				FlxG.save.data.scrollspeed = songspeed;
				FlxG.save.flush();
			}
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch (Options[curSelected])
			{
				case "Clean Mode":
					FlxG.save.data.cleanmode = !FlxG.save.data.cleanmode;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenVisibleOptions();
					regenOptions();
				case "Freeplay Previews":
				#if desktop
					FlxG.save.data.freeplaypreviews = !FlxG.save.data.freeplaypreviews;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenVisibleOptions();
					regenOptions();
				#else
					if (descriptiontxt.text == descriptions[curSelected])
					{
						FlxG.sound.play(Paths.sound('error'));
						descriptiontxt.text = "This option is not available on the web version.";
						timer.start(3, function(tmr:FlxTimer)
						{
							if (descriptiontxt.text == "This option is not available on the web version.")
								descriptiontxt.text = descriptions[curSelected];
						});
					}
				#end
				case "Preload Freeplay Previews":
				#if desktop
					FlxG.save.data.preloadfreeplaypreviews = !FlxG.save.data.preloadfreeplaypreviews;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenVisibleOptions();
					regenOptions();
				#else
					if (descriptiontxt.text == descriptions[curSelected])
					{
						FlxG.sound.play(Paths.sound('error'));
						descriptiontxt.text = "This option is not available on the web version.";
						timer.start(3, function(tmr:FlxTimer)
						{
							if (descriptiontxt.text == "This option is not available on the web version.")
								descriptiontxt.text = descriptions[curSelected];
						});
					}
				#end
				case "Color Ratings":
					FlxG.save.data.colorratings = !FlxG.save.data.colorratings;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenVisibleOptions();
					regenOptions();
				case "Fullscreen":
				#if desktop
					FlxG.save.data.fullscreen = !FlxG.fullscreen;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
        			FlxG.fullscreen = !FlxG.fullscreen;
					regenVisibleOptions();
					regenOptions();
				#else
					if (descriptiontxt.text == descriptions[curSelected])
					{
						FlxG.sound.play(Paths.sound('error'));
						descriptiontxt.text = "This option is not available on the web version.";
						timer.start(3, function(tmr:FlxTimer)
						{
							if (descriptiontxt.text == "This option is not available on the web version.")
								descriptiontxt.text = descriptions[curSelected];
						});
					}
				#end
				case "FPS Counter":
					FlxG.save.data.fpscounter = !FlxG.save.data.fpscounter;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					(cast (Lib.current.getChildAt(0), Main)).toggleFPSCounter(FlxG.save.data.fpscounter);
					regenVisibleOptions();
					regenOptions();
				case "Downscroll":
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenVisibleOptions();
					regenOptions();
				case "Override Song Scroll Speed":
					FlxG.save.data.overridespeed = !FlxG.save.data.overridespeed;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenVisibleOptions();
					regenOptions();
				case "Miss Stun":
					FlxG.save.data.disabledmissstun = !FlxG.save.data.disabledmissstun;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenVisibleOptions();
					regenOptions();
				case "Miss Sounds":
					FlxG.save.data.misssounds = !FlxG.save.data.misssounds;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenVisibleOptions();
					regenOptions();
			}
		}

		#if desktop
		if (FlxG.keys.justPressed.F11 || FlxG.keys.justPressed.F)
        {
			FlxG.save.data.fullscreen = !FlxG.fullscreen;
			FlxG.save.flush();	
        	FlxG.fullscreen = !FlxG.fullscreen;
			regenVisibleOptions();
			regenOptions();
        }
		#end
	}

	public function regenVisibleOptions()
	{
		VisibleOptions = [];
		var i = 0;
		if (FlxG.save.data.cleanmode)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.preloadfreeplaypreviews)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.freeplaypreviews)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.colorratings)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.fullscreen)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.fpscounter)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.downscroll)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.overridespeed)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.disabledmissstun)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}

		i++;

		if (FlxG.save.data.misssounds)
		{
			VisibleOptions.push(OptionsON[i]);
		}
		else
		{
			VisibleOptions.push(OptionsOFF[i]);
		}
	}

	public function regenOptions()
	{
		grpOptionsTexts.clear();
		for (i in 0...VisibleOptions.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, VisibleOptions[i], true, false);
			// optionText.ID = i;
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpOptionsTexts.add(optionText);
		}
		changeSelection(0, false);
	}

	function changeSelection(change:Int = 0, sound:Bool = true):Void
	{
		curSelected += change;

		if (sound)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = Options.length - 1;
		if (curSelected >= Options.length)
			curSelected = 0;

		timer.cancel();
		descriptiontxt.text = descriptions[curSelected];

		var bullShit:Int = 0;

		for (item in grpOptionsTexts.members)
		{
			item.targetY = bullShit - curSelected;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
				if (numberOptions[bullShit])
					numtxt.visible = true;
				else
					numtxt.visible = false;
			}
			if (DisabledOptions[bullShit] && item.targetY != 0)
			{
				item.alpha = 0.4;
			}
			
			bullShit++;
		}
	}
}
