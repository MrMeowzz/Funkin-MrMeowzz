package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			curWacky = ["ITS", "SPOOKY DAY"];
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			curWacky = ["ITS", "THE HOLIDAYS"];

		// DEBUG BULLSHIT

		super.create();

		FlxG.save.bind('funkin', 'Mr Meowzz');

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		OptionSaveData.SetDefaultOptions();

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			#if desktop
			if (FlxG.save.data.preloadfreeplaypreviews && !OG.preloadedSongs) {
			OG.preloadedSongs = true;
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
				if (!i.contains('.txt')) //dont include the ducking txt file
					OG.music.push(i);
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs/b-side")))
				OG.bsidemusic.push(i);
			sys.thread.Thread.create(() -> {
			for (i in OG.music)
			{
				FlxG.sound.cache(Paths.inst(i));
				FreeplayState.loadedSongs.push(Std.string(i));
			}
			for (i in OG.bsidemusic)
			{
				FlxG.sound.cache(Paths.bsideinst(i));
				FreeplayState.loadedSongs.push(Std.string(i + "-bside"));
			}
			});
			}
			#end
			startIntro();
			if (FlxG.save.data.fpscounter != null)
				(cast (Lib.current.getChildAt(0), Main)).toggleFPSCounter(FlxG.save.data.fpscounter);
			else
				FlxG.save.data.fpscounter = true;
		});
		#end

		#if desktop
		DiscordClient.initialize();
		
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var titleTextController:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
				FlxG.sound.playMusic(Paths.music('frogMenuSPOOKY'), 0);
			else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
				FlxG.sound.playMusic(Paths.music('frogMenuFESTIVE'));
			else
				FlxG.sound.playMusic(Paths.music('frogMenuRemix'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			logoBl.frames = Paths.getSparrowAtlas('logoBumpinSPOOKY');
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			logoBl.frames = Paths.getSparrowAtlas('logoBumpinFESTIVE');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
		{
			gfDance = new FlxSprite(FlxG.width * 0.5, FlxG.height * 0.07);
			gfDance.frames = Paths.getSparrowAtlas('spookyDance');
			gfDance.animation.addByIndices('danceLeft', 'spooky dance', [16, 0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
			gfDance.animation.addByIndices('danceRight', 'spooky dance', [8, 9, 10, 11, 12, 13, 14, 15], "", 24, false);
			gfDance.antialiasing = true;
		}
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
		{
			gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
			gfDance.frames = Paths.getSparrowAtlas('gfChristmasDanceTitle');
			gfDance.animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			gfDance.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
			gfDance.antialiasing = true;
		}
		else
		{
			gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
			gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
			gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
			gfDance.antialiasing = true;
		}
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();

		titleTextController = new FlxSprite(100, FlxG.height * 0.8);
		titleTextController.frames = Paths.getSparrowAtlas('titleStart');
		titleTextController.animation.addByPrefix('idle', "Press Start to Begin", 24);
		titleTextController.animation.addByPrefix('press', "START PRESSED", 24);
		titleTextController.antialiasing = true;
		titleTextController.animation.play('idle');
		titleTextController.updateHitbox();
		titleTextController.visible = false;
		// titleText.screenCenter(X);
		add(titleText);
		add(titleTextController);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er\nMr Meowzz", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('dababy'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);

		FlxG.updateFramerate = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}
		if (Date.now().getMonth() == 9)
			swagGoodArray.push(["ITS", "SPOOKY MONTH"]);

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);
		
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
			if (gamepad.justPressed.ANY)
			{
				titleText.visible = false;
				titleTextController.visible = true;
			}
		}

		if (FlxG.keys.justPressed.ANY)
		{
			titleText.visible = true;
			titleTextController.visible = false;
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			titleText.animation.play('press');
			titleTextController.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			// FlxG.switchState(new MainMenuState());
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			var http = new haxe.Http("https://api.github.com/repos/MrMeowzz/Funkin-MrMeowzz/releases/latest");
			http.addHeader('User-Agent', 'request'); //needed because github stuf
			if (Application.current.meta.get('version').contains('PRE')) {
				OutdatedSubState.prerelease = true;
				FlxG.switchState(new OutdatedSubState());
			}
			else {
			http.onData = function (tempdata:String)
			{
				var data = haxe.Json.parse(tempdata).tag_name.substring(1);
				trace('LATEST VER: ' + data);
				if (Application.current.meta.get('version') != data)
				{
					OutdatedSubState.latestver = data;
					OutdatedSubState.data = tempdata;
					FlxG.switchState(new OutdatedSubState());
				}
				else
				{
					if (FlxG.save.data.menutransitions) {
					FlxTween.tween(FlxG.camera, { zoom: 1.25}, 0.5, {ease: FlxEase.quadIn });
					MainMenuState.transition = 'zoomout';
					FlxG.switchState(new MainMenuState());
					}
					else
						FlxG.switchState(new MainMenuState());
				}
			} 
			}
				
			http.onError = function (error) {
				trace('error: $error');
				if (FlxG.save.data.menutransitions) {
				FlxTween.tween(FlxG.camera, { zoom: 1.25}, 0.5, {ease: FlxEase.quadIn });
				MainMenuState.transition = 'zoomout';
				FlxG.switchState(new MainMenuState());
				}
				else
					FlxG.switchState(new MainMenuState());
			}
			
			//limit requests since github has rate limit
			if (!Application.current.meta.get('version').contains('PRE') && !OG.httpRequested)
			{
				//request on dif thread so it doesnt cause big ass nuke sized lag spike (totally not exaggerating)
				#if desktop
				sys.thread.Thread.create(() -> {
				http.request();
				});
				#else
				http.request();
				#end
				trace('SENT HTTP REQUEST');
				OG.httpRequested = true;
			}
			else
			{
				if (FlxG.save.data.menutransitions) {
				FlxTween.tween(FlxG.camera, { zoom: 1.25}, 0.5, {ease: FlxEase.quadIn });
				MainMenuState.transition = 'zoomout';
				FlxG.switchState(new MainMenuState());
				}
				else
					FlxG.switchState(new MainMenuState());
			}
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			if (textArray[i] == 'Mr Meowzz')
				money.color = FlxColor.YELLOW;
			if (textArray[i].toLowerCase().contains('spooky'))
				money.color = FlxColor.ORANGE;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (skippedIntro)
			logoBl.animation.play('bump');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er', 'Mr Meowzz']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 6:
				createCoolText(['In association', 'with']);
			case 7:
				addMoreText('dababy');
				ngSpr.visible = true;
			// credTextShit.text += '\nNewgrounds';
			case 8:
				addMoreText('jk lol haha funny');
			case 9:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 10:
				createCoolText([curWacky[0]]);
				if (curWacky[0] == 'pico said dababy' && !skippedIntro)
					FlxG.sound.play(Paths.sound('dababypico'));
			// credTextShit.visible = true;
			case 12:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 13:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 14:
				addMoreText('Mr Meowzzs Friday');
			// credTextShit.visible = true;
			case 15:
				addMoreText('Night');
			// credTextShit.text += '\nNight';
			case 16:
				addMoreText('Funkin'); // credTextShit.text += '\nFunkin';

			case 17:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
	
	override function stepHit()
	{
		super.stepHit();
		// makes gf dance faster
		if (curStep % 2 == 1 && skippedIntro)
		{
			danceLeft = !danceLeft;

			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}
	}
}
