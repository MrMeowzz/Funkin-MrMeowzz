package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import flixel.input.gamepad.FlxGamepad;

using StringTools;

class OptionsState extends MusicBeatState
{
	var Options:Array<String> = ['Reset Options to Default',
	'Remove Song Scores',
	'Clean Mode', 
	'Preload Freeplay Previews', 
	'Freeplay Previews', 
	'Color Ratings', 
	'Fullscreen', 
	'FPS Counter', 
	'Downscroll', 
	'Middlescroll', 
	'Override Song Scroll Speed', 
	'Miss Stun', 
	'Miss Sounds', 
	'Hit Sounds',
	'Enemy Hit Sounds', 
	'Instant Restart', 
	'Note Splashes', 
	'New Hit Timings', 
	'Rating Location', 
	'Notestyle', 
	'Tabi Notes Shake', 
	'Note Timing', 
	'Key Bindings',
	'Skip Countdown',
	'Story Mode Dialog',
	'Freeplay Dialog',
	'Menu Transitions',
	'Enemy Extra Effects',
	'Enemy Strums',
	'Safe Frames'];

	var descriptions:Array<String> = ['Resets ALL options to default.'];

	var OptionsON:Array<String> = ['Reset Options to Default',
	'Remove Song Scores',
	'Clean Mode ON', 
	'Preload Freeplay PRVWs ON', 
	'Freeplay Previews ON', 
	'Color Ratings ON', 
	'Fullscreen ON', 
	'FPS Counter ON', 
	'Downscroll', 
	'Using Middlescroll', 
	'Override Song Speed ON', 
	'Miss Stun OFF', 
	'Miss Sounds ON', 
	'Hit Sounds ON',
	'Enemy Hit Sounds ON', 
	'Instant Restart ON', 
	'Note Splashes ON', 
	'New Hit Timings ON', 
	'Follows Camera', 
	'Notestyle', 
	'Tabi Notes Shake ON', 
	'Show Note Timing', 
	'Key Bindings',
	'Skip Countdown',
	'Story Mode Dialog ON',
	'Freeplay Dialog ON',
	'Menu Transitions ON',
	'Extra Enemy Effects',
	'Showing Enemy Strums',
	'Safe Frames'];

	var OptionsOFF:Array<String> = ['Reset Options to Default',
	'Remove Song Scores',
	'Clean Mode OFF', 
	'Preload Freeplay PRVWs OFF', 
	'Freeplay Previews OFF', 
	'Color Ratings OFF', 
	'Fullscreen OFF', 
	'FPS Counter OFF', 
	'Upscroll', 
	'Not Using Middlescroll', 
	'Override Song Speed OFF', 
	'Miss Stun ON', 
	'Miss Sounds OFF', 
	'Hit Sounds OFF',
	'Enemy Hit Sounds OFF', 
	'Instant Restart OFF', 
	'Note Splashes OFF', 
	'New Hit Timings OFF', 
	'By GF', 
	'Notestyle', 
	'Tabi Notes Shake OFF', 
	'Do not Show Note Timing', 
	'Key Bindings',
	'Do not Skip Countdown',
	'Story Mode OFF',
	'Freeplay Dialog OFF',
	'Menu Transitions OFF',
	'No Extra Enemy Effects',
	'No Enemy Strums',
	'Safe Frames'];

	#if html5
	var DisabledOptions:Array<Bool> = [false,false,true,true,false,true];
	#else
	var DisabledOptions:Array<Bool> = [];
	#end

	var VisibleOptions:Array<String> = [];

	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<Alphabet>;

	var descriptiontxt:FlxText;

	var numtxt:FlxText;

	var notestyletxt:FlxText;

	var timer:FlxTimer = new FlxTimer();

	var songspeed:Float = 0.1;
	var safeframes:Int = 10;

	var noteStyles:Array<String> = CoolUtil.coolTextFile(Paths.txt('noteStyles'));

	public static var pauseMenu:Bool = false;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
				FlxG.sound.playMusic(Paths.music('frogMenuSPOOKY'));
			else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
				FlxG.sound.playMusic(Paths.music('frogMenuFESTIVE'));
			else
				FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
			FlxG.sound.music.time = 10448;
		}

		noteStyles.insert(0, 'default');
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			menuBG.color = FlxColor.ORANGE;
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			menuBG.color = FlxColor.CYAN;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		descriptiontxt = new FlxText(75, 0, 0, "", 15);
		descriptiontxt.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			descriptiontxt.color = FlxColor.ORANGE;
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			descriptiontxt.color = FlxColor.CYAN;
		add(descriptiontxt);

		numtxt = new FlxText(0, 0, 0, "sus", 30);
		numtxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		numtxt.visible = false;
		numtxt.screenCenter();
		numtxt.y += 250;
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			numtxt.color = FlxColor.ORANGE;
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			numtxt.color = FlxColor.CYAN;
		add(numtxt);

		notestyletxt = new FlxText(0, 0, 0, "woah", 30);
		notestyletxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		notestyletxt.visible = false;
		notestyletxt.screenCenter();
		notestyletxt.y += 250;
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			notestyletxt.color = FlxColor.ORANGE;
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			notestyletxt.color = FlxColor.CYAN;
		add(notestyletxt);

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
		if (FlxG.save.data.safeframes != null)
			safeframes = FlxG.save.data.safeframes;

		changeSelection();

		if (FlxG.save.data.menutransitions) 
		{
			FlxG.camera.zoom = 1.5;
			FlxG.camera.y = FlxG.height;
			FlxTween.tween(FlxG.camera, { zoom: 1, y: 0}, 1, { ease: FlxEase.quadIn });
		}

		super.create();
	}

	var uptimer = new FlxTimer();
	var downtimer = new FlxTimer();

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
		{
			changeSelection(-1);

			uptimer.start(0.3, function(tmr:FlxTimer)
			{
				uptimer.start(0.1, function(tmr:FlxTimer)
				{
						changeSelection(-1);
				}, 0);
			});
		}

		if (controls.DOWN_P)
		{
			changeSelection(1);

			downtimer.start(0.3, function(tmr:FlxTimer)
			{
				downtimer.start(0.1, function(tmr:FlxTimer)
				{
						changeSelection(1);
				}, 0);
			});
		}

		if (controls.UP_R)
		{
			uptimer.cancel();
		}

		if (controls.DOWN_R)
		{
			downtimer.cancel();
		}

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (FlxG.keys.justPressed.ANY)
        {
            KeyBinds.gamepad = false;
			updateDescription();
        }
		else if (gamepad != null && gamepad.justPressed.ANY)
		{
			KeyBinds.gamepad = true;
			updateDescription();
		}

		if (controls.LEFT_P)
		{
			if (FlxG.save.data.overridespeed && Options[curSelected] == "Override Song Scroll Speed" && songspeed > 0.1)
			{
				songspeed -= 0.1;
				if ((FlxG.keys.pressed.SHIFT || (gamepad != null && gamepad.pressed.LEFT_SHOULDER)))
					if (songspeed - 0.4 > 0.1)
						songspeed -= 0.4;
			}
			else if (Options[curSelected] == 'Notestyle' && (noteStyles.indexOf(FlxG.save.data.notestyle) - 1) >= 0)
			{
				FlxG.save.data.notestyle = noteStyles[noteStyles.indexOf(FlxG.save.data.notestyle) - 1];
			}
			else if (Options[curSelected] == "Safe Frames" && safeframes > 1)
			{
				safeframes -= 1;
				if ((FlxG.keys.pressed.SHIFT || (gamepad != null && gamepad.pressed.LEFT_SHOULDER)))
					safeframes -= 1;
			}
			updateDescription();
		}
					

		if (controls.RIGHT_P)
		{
			if (FlxG.save.data.overridespeed && Options[curSelected] == "Override Song Scroll Speed" && songspeed < 10)
			{
				songspeed += 0.1;
				if ((FlxG.keys.pressed.SHIFT || (gamepad != null && gamepad.pressed.LEFT_SHOULDER)))
					songspeed += 0.4;
			}
			else if (Options[curSelected] == 'Notestyle' && (noteStyles.indexOf(FlxG.save.data.notestyle) + 1) < noteStyles.length)
			{
				FlxG.save.data.notestyle = noteStyles[noteStyles.indexOf(FlxG.save.data.notestyle) + 1];
			}
			else if (Options[curSelected] == "Safe Frames" && safeframes < 20)
			{
				safeframes += 1;
				if ((FlxG.keys.pressed.SHIFT || (gamepad != null && gamepad.pressed.LEFT_SHOULDER)))
					safeframes += 1;
			}
			updateDescription();
		}
		
		if (FlxG.keys.justPressed.P || (gamepad != null && gamepad.justPressed.Y))
		{
			if (Options[curSelected] == "Hit Sounds")
				FlxG.sound.play(Paths.sound('hitsound'));
			else if (Options[curSelected] == "Enemy Hit Sounds")
				FlxG.sound.play(Paths.sound('enemyhitsound'));
		}

		if (songspeed < 0.1)
			songspeed = 0.1;
		if (songspeed > 10)
			songspeed = 10;
		if (safeframes < 1)
			safeframes = 1;
		if (safeframes > 20)
			safeframes = 20;

		switch (Options[curSelected])
		{
			case "Override Song Scroll Speed":
				numtxt.text = Std.string(songspeed);
			case "Safe Frames":
				numtxt.text = Std.string(safeframes);
		}
		notestyletxt.text = FlxG.save.data.notestyle;
		if (FlxG.save.data.notestyle == 'camellia')
			notestyletxt.text += '/stepmania';

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if (FlxG.save.data.overridespeed)
			{
				FlxG.save.data.scrollspeed = songspeed;
				FlxG.save.flush();
			}
			if (FlxG.save.data.safeframes != safeframes)
				FlxG.save.data.safeframes = safeframes;
			if (FlxG.save.data.menutransitions)
			{
				FlxTween.tween(FlxG.camera, { zoom: 0.1 }, 1, { ease: FlxEase.quadIn });
				MainMenuState.transition = 'zoom';
			}
			if (pauseMenu)
				FlxG.switchState(new PlayState());
			else
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
					regenStuff();
				case "Freeplay Previews":
				#if desktop
					FlxG.save.data.freeplaypreviews = !FlxG.save.data.freeplaypreviews;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
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
					regenStuff();
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
					regenStuff();
				case "Fullscreen":
				#if desktop
					FlxG.save.data.fullscreen = !FlxG.fullscreen;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
        			FlxG.fullscreen = !FlxG.fullscreen;
					regenStuff();
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
					regenStuff();
				case "Downscroll":
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Middlescroll":
					FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Override Song Scroll Speed":
					FlxG.save.data.overridespeed = !FlxG.save.data.overridespeed;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Miss Stun":
					FlxG.save.data.disabledmissstun = !FlxG.save.data.disabledmissstun;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Miss Sounds":
					FlxG.save.data.misssounds = !FlxG.save.data.misssounds;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Hit Sounds":
					FlxG.save.data.hitsounds = !FlxG.save.data.hitsounds;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Enemy Hit Sounds":
					FlxG.save.data.enemyhitsounds = !FlxG.save.data.enemyhitsounds;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Instant Restart":
					FlxG.save.data.instantrestart = !FlxG.save.data.instantrestart;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Note Splashes":
					FlxG.save.data.notesplashes = !FlxG.save.data.notesplashes;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "New Hit Timings":
					FlxG.save.data.newhittimings = !FlxG.save.data.newhittimings;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Rating Location":
					FlxG.save.data.ratingsfollowcamera = !FlxG.save.data.ratingsfollowcamera;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Tabi Notes Shake":
					FlxG.save.data.tabinotesshake = !FlxG.save.data.tabinotesshake;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Note Timing":
					FlxG.save.data.milliseconds = !FlxG.save.data.milliseconds;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Key Bindings":
					openSubState(new KeyBindMenu());
				case "Skip Countdown":
					FlxG.save.data.skipcountdown = !FlxG.save.data.skipcountdown;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Story Mode Dialog":
					FlxG.save.data.storymodedialog = !FlxG.save.data.storymodedialog;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Freeplay Dialog":
					FlxG.save.data.freeplaydialog = !FlxG.save.data.freeplaydialog;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Menu Transitions":
					FlxG.save.data.menutransitions = !FlxG.save.data.menutransitions;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Enemy Extra Effects":
					FlxG.save.data.enemyextraeffects = !FlxG.save.data.enemyextraeffects;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
				case "Reset Options to Default":
					ResetOptionsState.ResetType = 'options';
					openSubState(new ResetOptionsState());
				case "Remove Song Scores":
					ResetOptionsState.ResetType = 'scores';
					openSubState(new ResetOptionsState());
				case "Enemy Strums":
					FlxG.save.data.enemystrums = !FlxG.save.data.enemystrums;
					FlxG.save.flush();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					regenStuff();
			}
		}

		#if desktop
		if (FlxG.keys.justPressed.F11 || (FlxG.keys.justPressed.F && FlxG.save.data.leftBind != "F" && FlxG.save.data.downBind != "F" && FlxG.save.data.upBind != "F" && FlxG.save.data.rightBind != "F"))
        {
			regenStuff();
        }
		#end
	}

	public function updateDescription()
	{
		descriptions = ['Resets ALL options to default.',
		'Removes ALL song scores (including weeks).', 
		'Changes some assets to make it more appropriate.', 
		'Preloads the freeplay song previews so it does not lag while switching songs. May cause higher memory usage in low-end devices.', 
		'Disables the freeplay song previews.', 
		'Adds color to the ratings.', 
		'Makes the game fullscreen or windowed.', 
		'Toggles the visibility of the FPS Counter in the top left.', 
		'Whether to use downscroll or upscroll.', 
		'Puts the main players strums in the middle.',
		'Whether to override the song scroll speed or not. Press the <- and -> keys if enabled. Hold ${KeyBinds.gamepad ? 'LEFT Shoulder to change faster' : 'shift to increase or decrease faster'}.', 
		'Whether to disable or enable miss stun. Disabling miss stun causes health to drain faster and enables anti-mash.', 
		'Whether to play miss sounds or not.', 
		'Plays a sound when a note is hit. Press ${KeyBinds.gamepad ? 'Y' : 'P'} to play the current hit sound. Replace hitsound.ogg in assets/sounds for a different sound.',
		'Press ${KeyBinds.gamepad ? 'Y' : 'P'} to play the current enemy hit sound. Replace enemyhitsound.ogg in assets/sounds for a different sound.', 
		'Skips the short animation before restarting when enabled.', 
		'Enables note splashes that occur when you get sick rating.', 
		'Changes the hit timings of ratings and notes to be more accurate.', 
		'Whether for the ratings to be by gf or for them to follow the camera.', 
		'Which notestyle should be used. Default uses the songs notestyle. Notestyle will not be changed if the song has notestyle override on.', 
		'Makes Tabi notes shake.', 
		'Shows the note timing in milliseconds for each note pressed.', 
		'Change keybinds for gameplay.',
		'Skips the countdown before the song starts.',
		'Toggles the cutscenes and dialog in story mode.',
		'Toggles the cutscenes and dialog in freeplay.',
		'Toggles the menu transitions between states.',
		'Shows ratings and the combo of the enemy like it is actually pressing the notes.',
		'Shows the strums and notes of the enemy.',
		'Affects the hitbox of a note. Changing this will affect your score. Sick: 0ms ${FlxG.save.data.newhittimings ? 'Good: ' + Math.floor((safeframes / 60) * 1000) * 0.325 + 'ms Bad: ' + Math.floor((safeframes / 60) * 1000) * 0.575 + 'ms ' + '${FlxG.save.data.cleanmode ? 'Terrible: ' : 'Shit: '}: ' + Math.floor((safeframes / 60) * 1000) * 0.8 + 'ms' : 'Good: ' + Math.floor((safeframes / 60) * 1000) * 0.2 + 'ms Bad: ' + Math.floor((safeframes / 60) * 1000) * 0.75 + 'ms ' + '${FlxG.save.data.cleanmode ? 'Terrible: ' : 'Shit: '}: ' + Math.floor((safeframes / 60) * 1000) * 0.9 + 'ms'}'];
		descriptiontxt.text = descriptions[curSelected];
	}

	public function regenStuff()
	{
		regenVisibleOptions();
		regenOptions();
	}

	override function closeSubState()
	{
		if (ResetOptionsState.ResetOptions)
			regenStuff();

		super.closeSubState();
	}

	public function regenVisibleOptions()
	{
		VisibleOptions = [];
		var i = 0;

		VisibleOptions.push(OptionsON[i]);

		i++;

		VisibleOptions.push(OptionsON[i]);

		i++;

		if (FlxG.save.data.cleanmode)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.preloadfreeplaypreviews)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.freeplaypreviews)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.colorratings)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.fullscreen)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.fpscounter)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.downscroll)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.middlescroll)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.overridespeed)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.disabledmissstun)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.misssounds)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.hitsounds)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.enemyhitsounds)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.instantrestart)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.notesplashes)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.newhittimings)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.ratingsfollowcamera)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		VisibleOptions.push(OptionsON[i]);

		i++;

		if (FlxG.save.data.tabinotesshake)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.milliseconds)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		VisibleOptions.push(OptionsON[i]);

		i++;

		if (FlxG.save.data.skipcountdown)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.storymodedialog)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.freeplaydialog)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.menutransitions)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.enemyextraeffects)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		if (FlxG.save.data.enemystrums)
			VisibleOptions.push(OptionsON[i]);
		else
			VisibleOptions.push(OptionsOFF[i]);

		i++;

		VisibleOptions.push(OptionsON[i]);
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
		updateDescription();

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
				if (Options[bullShit] == 'Override Song Scroll Speed' || Options[bullShit] == 'Safe Frames')
					numtxt.visible = true;
				else
					numtxt.visible = false;
				if (Options[bullShit] == 'Notestyle')
					notestyletxt.visible = true;
				else
					notestyletxt.visible = false;
			}
			if (DisabledOptions[bullShit] && item.targetY != 0)
			{
				item.alpha = 0.4;
			}
			
			bullShit++;
		}
	}
}
