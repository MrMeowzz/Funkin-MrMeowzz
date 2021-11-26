package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
import openfl.Lib;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.input.gamepad.FlxGamepad;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var sections:Array<SectionMetadata> = [];
	var songs:Array<SongMetadata> = [];
	var bsidesongs:Array<SongMetadata> = [];

	var selector:FlxText;

	public static var rate:Float = 1.0;

	var curSelected:Int = OG.SelectedFreeplay;
	var curDifficulty:Int = OG.DifficultyFreeplay;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var previewtext:FlxText;
	var controlstext:FlxText;

	private var grpVisible:FlxTypedGroup<Alphabet>;
	private var iconArray:FlxTypedGroup<HealthIcon>;
	private var curPlaying:Bool = false;

	//private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));

	public static var loadedSongs:Array<String> = [];

	override function create()
	{
		#if html5
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
		#end
		#if desktop
		if (!FlxG.save.data.freeplaypreviews)
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
		}
		#end

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
			bsidesongs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus - Freeplay", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		if (Date.now().getMonth() == 9)
			addSection(['Normal', 'BSide'], ['spooky', 'spooky-bside']);
		else
			addSection(['Normal', 'BSide'], ['bf', 'bf-bside']);

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Test', 'Ridge'], 1, ['bf-pixel', 'dad']);

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Bopeebo', 'Old Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Spookeez', 'South', 'Shiver', 'Monster'], 2, ['spooky', 'spooky', 'spooky', 'monster']);

		if (StoryMenuState.weekUnlocked[3] || isDebug)
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		if (StoryMenuState.weekUnlocked[4] || isDebug)
			if (!FlxG.save.data.cleanmode)
				addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);
			else
				addWeek(['Satin-Pants', 'High', 'Mom'], 4, ['mom']);

		if (StoryMenuState.weekUnlocked[5] || isDebug)
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);

		if (StoryMenuState.weekUnlocked[6] || isDebug)
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai-angry', 'spirit']);
			
		if (StoryMenuState.weekUnlocked[7] || isDebug)
			addWeek(['Ugh', 'High Effort Ugh', 'Guns', 'Stress'], 7, ['tankman']);
		
		if (StoryMenuState.weekUnlocked[8] || isDebug)
			addWeek(['iPhone', 'No Among Us', 'H.E. No Among Us', 'Among Us Drip'], 8, ['monster', 'tankmannoamongus', 'tankmannoamongus', 'amogusguy']);


		addBSideWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);

		addBSideWeek(['Spookeez', 'South'], 2, ['spooky']);

		addBSideWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		if (!FlxG.save.data.cleanmode)
			addBSideWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);
		else
			addBSideWeek(['Satin-Pants', 'High', 'Mom'], 4, ['mom']);

		addBSideWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);

		addBSideWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai-angry', 'spirit']);

		// LOAD MUSIC

		// LOAD CHARACTERS

		add(bg);

		grpVisible = new FlxTypedGroup<Alphabet>();
		iconArray = new FlxTypedGroup<HealthIcon>();
		add(grpVisible);
		add(iconArray);

		if (OG.FreeplayMenuType == 'section')
			regenSections();
		else
			regenSongs();

		// prevent freeplay lag when playing songs (not anymore)
		/*
		for (i in 0...bsidesongs.length)
		{
			#if PRELOAD_ALL
			if (FlxG.save.data.preloadfreeplaypreviews && FlxG.save.data.freeplaypreviews)
				FlxG.sound.cache(Paths.bsideinst(bsidesongs[i].songName));
			#end
		}
		for (i in 0...songs.length)
		{
			#if PRELOAD_ALL
			if (FlxG.save.data.preloadfreeplaypreviews && FlxG.save.data.freeplaypreviews)
				if (FlxG.save.data.cleanmode && (songs[i].songName.toLowerCase() == 'no among us' || songs[i].songName.toLowerCase() == 'h.e. no among us'))
					FlxG.sound.cache(Paths.cleaninst(songs[i].songName));
				else
					FlxG.sound.cache(Paths.inst(songs[i].songName));
			#end
		}
		*/

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			scoreText.color = FlxColor.ORANGE;
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			scoreText.color = FlxColor.CYAN;
		// scoreText.alignment = RIGHT;

		#if desktop
		var scoreBGHeight = 105;
		#else
		var scoreBGHeight = 66;
		#end

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), scoreBGHeight, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			diffText.color = FlxColor.ORANGE;
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			diffText.color = FlxColor.CYAN;

		rate = PlayState.songMultiplier;

		previewtext = new FlxText(scoreText.x, scoreText.y + 66, 0, "Rate: " + rate + "x", 24);
		previewtext.font = scoreText.font;
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			previewtext.color = FlxColor.ORANGE;
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			previewtext.color = FlxColor.CYAN;
		
		controlstext = new FlxText(scoreText.x, scoreText.y + 96, 0, "", 16);
		#if desktop
		controlstext.text = "Press the -> and <- keys to toggle difficulty.\nHold shift to toggle the rate.";
		#else
		controlstext.text = "Press the -> and <- keys to toggle difficulty.";
		controlstext.y -= 30;
		#end
		controlstext.x = FlxG.width - controlstext.width;
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			controlstext.color = FlxColor.ORANGE;
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			controlstext.color = FlxColor.CYAN;

		add(diffText);

		#if desktop
		add(previewtext);
		#end
		add(controlstext);

		add(scoreText);

		changeSelection();
		if (OG.FreeplayMenuType != 'section')
			changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		if (FlxG.save.data.menutransitions)
		{
			FlxG.camera.angle = -45;
			FlxG.camera.zoom = 1.5;
			FlxTween.tween(FlxG.camera, { zoom: 1, angle: 0}, 0.75, {ease: FlxEase.quadIn });
		}

		super.create();
	}

	public function addCertainSection(section:String, Character:String)
	{
		sections.push(new SectionMetadata(section, Character));
	}

	public function addSection(sections:Array<String>, ?Character:Array<String>)
	{
		if (Character == null)
			Character = ['bf'];

		var num:Int = 0;
		for (section in sections)
		{
			addCertainSection(section, Character[num]);

			if (Character.length != 1)
				num++;
		}
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	public function addBSideSong(songName:String, weekNum:Int, songCharacter:String)
	{
		bsidesongs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addBSideWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf-bside'];

		var num:Int = 0;
		for (song in songs)
		{
			addBSideSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	var uptimer = new FlxTimer();
	var downtimer = new FlxTimer();
	var randomtimer = new FlxTimer();

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		FlxG.updateFramerate = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		if (OG.FreeplayMenuType == 'section')
		{
			scoreText.visible = false;
			diffText.visible = false;
			controlstext.visible = false;
			#if desktop
			scoreBG.setGraphicSize(Std.int(FlxG.width * 0.35), 45);
			scoreBG.y = -31;
			#else
			scoreBG.visible = false;
			#end
			previewtext.y = 5;
		}
		else
		{
			scoreText.visible = true;
			diffText.visible = true;
			controlstext.visible = true;
			#if desktop
			scoreBG.setGraphicSize(Std.int(FlxG.width * 0.35), 105);
			scoreBG.y = 0;
			#else
			scoreBG.visible = true;
			#end
			previewtext.y = scoreText.y + 66;
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var up = controls.UP;
		var down = controls.DOWN;
		var upR = controls.UP_R;
		var downR = controls.DOWN_R;
		var accepted = controls.ACCEPT;


		if (upP)
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

		if (downP)
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

		if (upR)
		{
			uptimer.cancel();
		}

		if (downR)
		{
			downtimer.cancel();
		}

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		#if desktop
		if (gamepad != null && gamepad.justPressed.ANY)
			controlstext.text = "Press the -> and <- keys to toggle difficulty.\nHold left shoulder to toggle the rate.";
		else if (FlxG.keys.justPressed.ANY)
			controlstext.text = "Press the -> and <- keys to toggle difficulty.\nHold shift to toggle the rate.";

		controlstext.x = FlxG.width - controlstext.width;
		#end

		#if desktop
		if (FlxG.keys.pressed.SHIFT || (gamepad != null && gamepad.pressed.LEFT_SHOULDER))
		{
			if (controls.LEFT_P)
			{
				rate -= 0.05;
			}
			if (controls.RIGHT_P)
			{
				rate += 0.05;
			}

			if (rate > 3)
			{
				rate = 3;
			}
			else if (rate < 0.5)
			{
				rate = 0.5;
			}

			previewtext.text = "Rate: " + rate + "x";
		}
		else
		{
			if (controls.LEFT_P && OG.FreeplayMenuType != 'section')
				changeDiff(-1);
			if (controls.RIGHT_P && OG.FreeplayMenuType != 'section')
				changeDiff(1);
		}
		#else
		if (controls.LEFT_P && OG.FreeplayMenuType != 'section')
			changeDiff(-1);
		if (controls.RIGHT_P && OG.FreeplayMenuType != 'section')
			changeDiff(1);
		#end

		#if desktop
		@:privateAccess
		{
			if (FlxG.sound.music.playing)
				lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, rate);
		}
		#end

		if (FlxG.keys.justPressed.ESCAPE || (gamepad != null && gamepad.pressed.RIGHT_SHOULDER && gamepad.justPressed.BACK))
		{
			OG.SelectedFreeplay = curSelected;
			OG.DifficultyFreeplay = curDifficulty;
			FlxG.switchState(new MainMenuState());
			#if desktop
			if (FlxG.save.data.freeplaypreviews)
			{
				if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
					FlxG.sound.playMusic(Paths.music('frogMenuSPOOKY'));
				else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
					FlxG.sound.playMusic(Paths.music('frogMenuFESTIVE'));
				else
					FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
				FlxG.sound.music.time = 10448;
			}
			#end
			if (FlxG.save.data.menutransitions) 
			{
				FlxTween.tween(FlxG.camera, { zoom: 0.1 }, 1, { ease: FlxEase.quadIn });
				MainMenuState.transition = 'zoom';
			}
		}
		if (FlxG.keys.justPressed.BACKSPACE || (gamepad != null && !gamepad.pressed.RIGHT_SHOULDER && gamepad.justPressed.BACK))
		{
			if (OG.FreeplayMenuType != 'section') {
				regenSections();
			}
			else
			{
				OG.SelectedFreeplay = curSelected;
				OG.DifficultyFreeplay = curDifficulty;
				FlxG.switchState(new MainMenuState());
				#if desktop
				if (FlxG.save.data.freeplaypreviews)
				{
					if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
						FlxG.sound.playMusic(Paths.music('frogMenuSPOOKY'));
					else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
						FlxG.sound.playMusic(Paths.music('frogMenuFESTIVE'));
					else
						FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
						FlxG.sound.music.time = 10448;
				}
				#end
				if (FlxG.save.data.menutransitions)
				{
					FlxTween.tween(FlxG.camera, { zoom: 0.1 }, 1, { ease: FlxEase.quadIn });
					MainMenuState.transition = 'zoom';
				}
			}
		}

		if (accepted || FlxG.keys.justPressed.SEVEN)
		{
			PlayState.songMultiplier = rate;
			if (OG.FreeplayMenuType == 'section') {
			if (!FlxG.keys.justPressed.SEVEN) {
			switch (sections[curSelected].section.toLowerCase())
			{
				case 'bside':				
					OG.FreeplayMenuType = 'bside';
				default:
					OG.FreeplayMenuType = 'normal';
			}
			curSelected = 0;
			regenSongs();
			changeDiff();
			}
			}
			else if (OG.FreeplayMenuType == 'bside')
			{
				var poop:String = Highscore.formatSong(bsidesongs[curSelected].songName.toLowerCase(), curDifficulty);

				trace(poop);

				var folder = 'b-side/' + bsidesongs[curSelected].songName.toLowerCase();

				PlayState.SONG = Song.loadFromJson(poop, folder);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = if (curDifficulty >= 4) curDifficulty - 4 else curDifficulty;

				PlayState.storyWeek = bsidesongs[curSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				OG.SelectedFreeplay = curSelected;
				OG.DifficultyFreeplay = curDifficulty;
				if (FlxG.save.data.menutransitions)
					FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
				if (FlxG.keys.justPressed.SEVEN) {
					LoadingState.loadAndSwitchState(new ChartingState());
				}
				else
					LoadingState.loadAndSwitchState(new PlayState());
			}
			else {
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			var folder = songs[curSelected].songName.toLowerCase();

			PlayState.SONG = Song.loadFromJson(poop, folder);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = if (curDifficulty >= 4) curDifficulty - 4 else curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			OG.SelectedFreeplay = curSelected;
			OG.DifficultyFreeplay = curDifficulty;
			if (FlxG.save.data.menutransitions)
				FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
			if (FlxG.keys.justPressed.SEVEN) {
				LoadingState.loadAndSwitchState(new ChartingState());
			}
			else
				LoadingState.loadAndSwitchState(new PlayState());
			}
		}

		if (FlxG.keys.justPressed.R && FlxG.save.data.leftBind != "R" && FlxG.save.data.downBind != "R" && FlxG.save.data.upBind != "R" && FlxG.save.data.rightBind != "R")
		{
			var totalsongs:Int = 0;

			for (i in grpVisible.members)
			{
				totalsongs++;
			}

			curSelected = FlxG.random.int(0, totalsongs);
			changeSelection();

			randomtimer.start(0.3, function(tmr:FlxTimer)
			{
				randomtimer.start(0.08, function(tmr:FlxTimer)
				{
						curSelected = FlxG.random.int(0, totalsongs);
						changeSelection();
				}, 0);
			});
		}

		if (FlxG.keys.justReleased.R)
		{
			randomtimer.cancel();
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		if (OG.FreeplayMenuType == 'bside')
		{
			switch (curDifficulty)
			{
				case 0:
					diffText.text = "< EASIER >";
				case 1:
					diffText.text = '< STANDARD >';
				case 2:
					diffText.text = "< FLIP >";
				case 3:
					diffText.text = "< FLIP PLUS >";
			}
		}
		else
		{
			switch (curDifficulty)
			{
				case 0:
					diffText.text = "< EASY >";
				case 1:
					diffText.text = '< NORMAL >';
				case 2:
					diffText.text = "< HARD >";
				case 3:
					diffText.text = "< HARD PLUS >";
			}
		}
	}

	function iconColors(icon:String)
	{
		switch (icon)
		{
			case 'bf' | 'bf-car' | 'bf-christmas' | 'bf-pixel':
				return 0xFF149DFF;
			case 'bf-holding-gf':
				var random:Int;
				random = FlxG.random.int(0, 1);
				if (random == 1)
					return 0xFFA5004D;
				else
					return 0xFF149DFF;
			case 'amogusguy' | 'bf-amogus':
				return 0xFFD8D8D8;
			case 'dad':
				return 0xFFAF66CE;
			case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | 'gf-tankmen':
				return 0xFFA5004D;
			case 'monster' | 'monster-christmas':
				return 0xFFF2D046;
			case 'parents-christmas':
				var random:Int;
				random = FlxG.random.int(0, 1);
				if (random == 1)
					return 0xFFAF66CE;
				else
					return 0xFFD8558E;
			case 'pico' | 'pico-speaker':
				return 0xFFB7D855;
			case 'senpai' | 'senpai-angry':
				return 0xFFFA86C4;
			case 'spirit':
				return 0xFF320691;
			case 'spooky' | 'spooky-bside':
				var random:Int;
				random = FlxG.random.int(0, 1);
				if (random == 1)
					return 0xFFFD9013;
				else
					return 0xFFC3C3C3;
			case 'mom' | 'mom-car':
				return 0xFFD8558E;
			case 'tankman' | 'tankmannoamongus':
				return 0xFFF9B03A;
			case 'bf-old':
				return 0xFFE9FF48;
			case 'face':
				return 0xFFA1A1A1;
			case 'gf-amogus':
				return 0xFFFBE30C;
			case 'bf-bside':
				return 0xFFE86ACB;
			default:
				return FlxColor.WHITE;
		}
	}

	function bsideiconColors(icon:String)
	{
		switch (icon)
		{
			case 'bf' | 'bf-pixel':
				return 0xFFE86ACB;
			case 'dad' | 'mom' | 'mom-car' | 'parents-christmas':
				return 0xFFD8558E;
			case 'spooky':
				var random:Int;
				random = FlxG.random.int(0, 1);
				if (random == 1)
					return 0xFFFD9013;
				else
					return 0xFFC3C3C3;
			case 'pico':
				return 0xFF8978CC;
			case 'spirit':
				return 0xFF201672;
			case 'bf-old':
				return 0xFFE65355;
			case 'senpai' | 'senpai-angry':
				return 0xFFC3C3C3;
			case 'monster' | 'monster-christmas':
				return 0xFF78FF71;
			case 'face':
				return 0xFFA1A1A1;
			case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel':
				return 0xFF6800A5;
			default:
				return FlxColor.WHITE;
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;
		if (OG.FreeplayMenuType == 'section') 
		{
			if (curSelected < 0)
				curSelected = sections.length - 1;
			if (curSelected >= sections.length)
				curSelected = 0;
		}
		else if (OG.FreeplayMenuType == 'bside')
		{
			if (curSelected < 0)
				curSelected = bsidesongs.length - 1;
			if (curSelected >= bsidesongs.length)
				curSelected = 0;
		}
		else
		{
			if (curSelected < 0)
				curSelected = songs.length - 1;
			if (curSelected >= songs.length)
				curSelected = 0;
		}

		

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		if (OG.FreeplayMenuType == 'bside')
			intendedScore = Highscore.getScore(bsidesongs[curSelected].songName, curDifficulty);
		else
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		if (FlxG.save.data.freeplaypreviews)
		{
			if (OG.FreeplayMenuType == 'section')
			{
				switch (curSelected)
				{
					case 0:
						if (Date.now().getMonth() == 9)
						{
							if (loadedSongs.contains(songs[7].songName.toLowerCase()) || !FlxG.save.data.preloadfreeplaypreviews)
								FlxG.sound.playMusic(Paths.inst(songs[7].songName), 0);
						}
						else
						{
							if (loadedSongs.contains(songs[3].songName.toLowerCase()) || !FlxG.save.data.preloadfreeplaypreviews)
								FlxG.sound.playMusic(Paths.inst(songs[3].songName), 0);
						}
					case 1:
						if (Date.now().getMonth() == 9)
						{
							if (loadedSongs.contains(bsidesongs[4].songName.toLowerCase() + '-bside') || !FlxG.save.data.preloadfreeplaypreviews)
								FlxG.sound.playMusic(Paths.bsideinst(bsidesongs[4].songName), 0);
						}
						else
						{
							if (loadedSongs.contains(bsidesongs[1].songName.toLowerCase() + '-bside') || !FlxG.save.data.preloadfreeplaypreviews)
								FlxG.sound.playMusic(Paths.bsideinst(bsidesongs[1].songName), 0);
						}
				}
			}
			else if (OG.FreeplayMenuType == 'bside' && (loadedSongs.contains(bsidesongs[curSelected].songName.toLowerCase() + '-bside') || !FlxG.save.data.preloadfreeplaypreviews))
			{
				FlxG.sound.playMusic(Paths.bsideinst(bsidesongs[curSelected].songName), 0);
			}
			else if (OG.FreeplayMenuType == 'normal' && (loadedSongs.contains(songs[curSelected].songName.toLowerCase()) || !FlxG.save.data.preloadfreeplaypreviews))
			{
				if (FlxG.save.data.cleanmode && (songs[curSelected].songName.toLowerCase() == 'no among us' || songs[curSelected].songName.toLowerCase() == 'h.e no among us') && OG.FreeplayMenuType != 'section')
					FlxG.sound.playMusic(Paths.cleaninst(songs[curSelected].songName), 0);
				else
					FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			}
			FlxG.sound.music.endTime = FlxG.sound.music.length / 2;
		}
		#end

		var bullShit:Int = 0;
		var i = 0;
		for (icon in iconArray.members)
		{
			icon.alpha = 0.6;
			if (i == curSelected)
				icon.alpha = 1;
			i++;
		}

		for (item in grpVisible.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		if (OG.FreeplayMenuType == 'section')
		{
			FlxTween.color(bg, 0.5, bg.color, iconColors(Std.string(sections[curSelected].Character)));
		}
		else if (OG.FreeplayMenuType == 'bside')
			FlxTween.color(bg, 0.5, bg.color, bsideiconColors(Std.string(bsidesongs[curSelected].songCharacter)));
		else
			FlxTween.color(bg, 0.5, bg.color, iconColors(Std.string(songs[curSelected].songCharacter)));

	}
	public function regenSections()
	{
		grpVisible.clear();
		iconArray.clear();
		OG.BSIDE = false;
		OG.FreeplayMenuType = 'section';
		for (i in 0...sections.length)
		{
			var optionText:Alphabet;
			optionText = new Alphabet(0, (70 * i) + 30, sections[i].section, true, false);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpVisible.add(optionText);
			var bsideicon:Bool = false;
			var daIcon:String = sections[i].Character;
			if (sections[i].Character.contains('-bside'))
			{
				bsideicon = true;
				daIcon = sections[i].Character.replace('-bside','');
			}

			var icon:HealthIcon = new HealthIcon(daIcon, false, false, bsideicon);
			icon.sprTracker = optionText;

			iconArray.add(icon);
			//add(icon);
		}
		changeSelection();
	}
	public function regenSongs()
	{
		grpVisible.clear();
		iconArray.clear();
		OG.BSIDE = false;
		if (OG.FreeplayMenuType == 'bside') {
		OG.BSIDE = true;
		for (i in 0...bsidesongs.length)
		{
			var songText:Alphabet;
			songText = new Alphabet(0, (70 * i) + 30, bsidesongs[i].songName, true, false);
			if (bsidesongs[i].songCharacter == 'spooky' && Date.now().getMonth() == 9)
				songText.color = FlxColor.ORANGE;
			else if (bsidesongs[i].songCharacter.contains('christmas') && Date.now().getMonth() == 11)
				songText.color = FlxColor.CYAN;
			songText.isMenuItem = true;
			songText.targetY = i;
			grpVisible.add(songText);
			var bsideicon:Bool = true;

			var icon:HealthIcon = new HealthIcon(bsidesongs[i].songCharacter, false, false, bsideicon);
			icon.sprTracker = songText;
						
			iconArray.add(icon);
			//add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		changeSelection();
		}
		else {
		for (i in 0...songs.length)
		{
			var songText:Alphabet;
			if (songs[i].songName.toLowerCase() == 'h.e. no among us')
				songText = new Alphabet(0, (70 * i) + 30, 'High Effort No Among Us', true, false);
			else
				songText = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			if (songs[i].songCharacter == 'spooky' && Date.now().getMonth() == 9)
				songText.color = FlxColor.ORANGE;
			else if (songs[i].songCharacter.contains('christmas') && Date.now().getMonth() == 11)
				songText.color = FlxColor.CYAN;
			songText.isMenuItem = true;
			songText.targetY = i;
			grpVisible.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter, false, false);
			icon.sprTracker = songText;
					
			iconArray.add(icon);
			//add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		changeSelection();
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
class SectionMetadata
{
	public var section:String = "";
	public var Character:String = "";

	public function new(section:String, Character:String)
	{
		this.section = section;
		this.Character = Character;
	}
}
