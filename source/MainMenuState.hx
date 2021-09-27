package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Lib;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = OG.SelectedMainMenu;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'kickstarter', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var fnfversion:String = '0.2.7.1';

	public static var transition = '';

	var canAccept:Bool = true;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.17;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.17;
		magenta.setGraphicSize(Std.int(bg.width));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('main_menu');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Mr Meowzz's FNF v" + Application.current.meta.get('version') + " Using FNF v" + fnfversion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		switch (transition)
		{
			case 'zoomtilt':
				FlxG.camera.angle = 45;
				FlxG.camera.zoom = 0.75;
				FlxTween.tween(FlxG.camera, { zoom: 1, angle: 0}, 0.5, {ease: FlxEase.quadIn });
			case 'zoom':
				FlxG.camera.zoom = 0.1;
				FlxTween.tween(FlxG.camera, { zoom: 1}, 0.5, {ease: FlxEase.quadIn });
		}
		transition = '';

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		var fps = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());
		FlxG.updateFramerate = Std.int(fps);

		FlxG.camera.followLerp = FlxG.elapsed / .016666666666666666 * (0.06 * (60 / fps));
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				canAccept = false;
				OG.SelectedMainMenu = curSelected;
				FlxTween.tween(FlxG.camera, { x: FlxG.width, zoom: 0.5 }, 1, { ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
				{
					FlxG.switchState(new TitleState());
				} });
			}

			if (controls.ACCEPT && canAccept)
			{
				OG.SelectedMainMenu = curSelected;
				if (optionShit[curSelected] == 'kickstarter' || optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game", "&"]);
					#else
					FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false);
							var daChoice:String = optionShit[curSelected];

							//FlxG.camera.focusOn(menuItems.members[curSelected].getGraphicMidpoint());

							var daZoom:Float = 1.5;
							var daY:Float = 0;
							var daAngle:Float = 0;
							
							switch (daChoice)
							{
								case 'story mode':
									daZoom = 0.5;
									daY = FlxG.height;
								case 'options':
									daZoom = 0.5;
									daY = FlxG.height * -1;
								case 'freeplay':
									daAngle = -45;
							}

							FlxTween.tween(FlxG.camera, { zoom: daZoom, y: daY, angle: daAngle }, 1, { ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										// FlxTransitionableState.skipNextTransIn = true;
										// FlxTransitionableState.skipNextTransOut = true;
										FlxG.switchState(new OptionsState());
								}
								FlxTween.tween(FlxG.camera, { zoom: 1 }, 1.5, { ease: FlxEase.quadIn });
							} });
						}
					});
				}
			}
		}

		if (FlxG.keys.justPressed.SEVEN && PlayState.SONG != null)
		{
			OG.SelectedMainMenu = curSelected;
			FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		var i = 0;
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			if (optionShit[i] == 'kickstarter')
				spr.y = 380;
			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				if (optionShit[curSelected] == 'kickstarter')
					spr.y -= 40;
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
			i++;
		});
	}
}
