package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import openfl.Lib;
import flixel.input.gamepad.FlxGamepad;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var controlstext:FlxText;
	
	var cleanweekData:Array<Dynamic> = [
		['Tutorial'],
		['Bopeebo', 'Fresh', 'Dadbattle'],
		['Spookeez', 'South', 'Monster'],
		['Pico', 'Philly', "Blammed"],
		['Satin-Pants', "High", "Mom"],
		['Cocoa', 'Eggnog', 'Winter-Horrorland'],
		['Senpai', 'Roses', 'Thorns'],
		['Ugh', 'Guns', 'Stress'],
		['iPhone', 'No Among Us', 'Among Us Drip']
	];

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['Bopeebo', 'Fresh', 'Dadbattle'],
		['Spookeez', 'South', 'Monster'],
		['Pico', 'Philly', "Blammed"],
		['Satin-Panties', "High", "Milf"],
		['Cocoa', 'Eggnog', 'Winter-Horrorland'],
		['Senpai', 'Roses', 'Thorns'],
		['Ugh', 'Guns', 'Stress'],
		['iPhone', 'No Among Us', 'Among Us Drip']
	];

	var bsideweekData:Array<Dynamic> = [
		['Tutorial'],
		['Bopeebo', 'Fresh', 'Dadbattle'],
		['Spookeez', 'South'],
		['Pico', 'Philly', "Blammed"],
		['Satin-Panties', "High", "Milf"],
		['Cocoa', 'Eggnog', 'Winter-Horrorland'],
		['Senpai', 'Roses', 'Thorns']
	];

	var cleanbsideweekData:Array<Dynamic> = [
		['Tutorial'],
		['Bopeebo', 'Fresh', 'Dadbattle'],
		['Spookeez', 'South'],
		['Pico', 'Philly', "Blammed"],
		['Satin-Pants', "High", "Mom"],
		['Cocoa', 'Eggnog', 'Winter-Horrorland'],
		['Senpai', 'Roses', 'Thorns']
	];

	var curDifficulty:Int = OG.DifficultyStoryMode;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['dad', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['spooky', 'bf', 'gf'],
		['pico', 'bf', 'gf'],
		['mom', 'bf', 'gf'],
		['parents-christmas', 'bf', 'gf'],
		['senpai', 'bf', 'gf'],
		['tankman', 'bf', 'gf'],
		['tankman', 'bf', 'gf']
	];

	var weekNames:Array<String> = [
		"",
		"Daddy Dearest",
		"Spooky Month",
		"PICO",
		"MOMMY MUST MURDER",
		"RED SNOW",
		"hating simulator ft. moawling",
		"TANKMAN",
		"MEME TIME"
	];

	var weekColors:Array<FlxColor> = [
		0xFFA5004D, // GF
		0xFFAF66CE, // DAD
		0xFFFD9013, // SPOOKY
		0xFFB7D855, // PICO
		0xFFD8558E, // MOM
		0xFF800000, // PARENTS-CHRISTMAS
		0xFFFA86C4, // SENPAI
		0xFFF9B03A, // TANKMAN
		0xFFD8D8D8
	];

	var bsideweekColors:Array<FlxColor> = [
		0xFF6800A5, // GF
		0xFFD8558E, // DAD
		0xFFC3C3C3, // SPOOKY
		0xFF8978CC, // PICO
		0xFFD8558E, // MOM
		0xFFD8558E, // PARENTS-CHRISTMAS
		0xFFC3C3C3 // SENPAI
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var BG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, FlxColor.WHITE);

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				if (OG.StoryMenuType != 'bside')
				{
					if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
						FlxG.sound.playMusic(Paths.music('frogMenuSPOOKY'));
					else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
						FlxG.sound.playMusic(Paths.music('frogMenuFESTIVE'));
					else
						FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
					FlxG.sound.music.time = 10448;
				}
				else
					FlxG.sound.playMusic(Paths.music('freakyMenu-bside'));
			}
		}

		if (FlxG.save.data.cleanmode)
		{
			weekData = cleanweekData;
			bsideweekData = cleanbsideweekData;
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70 SIKEEEE THATS THE WRONG LINE NUMBER");
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus - Story Mode", null);
		#end

		if (OG.StoryMenuType == 'section')
			regenSections();
		else
			regenWeeks();

		trace("Line 96 AGAIN SIKEEEE THATS THE WRONG LINE NUMBER");

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curWeek][char]);
			weekCharacterThing.y += 70;
			weekCharacterThing.antialiasing = true;
				
			switch (weekCharacterThing.character)
			{
				case 'dad':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();

				case 'bf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.x -= 80;
				case 'gf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'pico':
					weekCharacterThing.flipX = true;
				case 'parents-christmas':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
				case 'tankman':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
			}

			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124 SIKEEEE THATS ALSO THE WRONG LINE NUMBER");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('hardplus', 'PLUSHARD');
		sprDifficulty.animation.play('easy');

		controlstext = new FlxText(871, 582, 0, "Press the -> and <- keys to toggle difficulty.", 14);
		add(controlstext);

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		regenDifficultyFrames(OG.StoryMenuType == 'bside');
		changeDifficulty();

		trace("Line 150 SIKEEEE THATS ALSO THE WRONG LINE NUMBER TOO");

		add(BG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, BG.x + BG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);
		curWeek = OG.SelectedStoryMode;
		changeWeek();

		updateText();

		trace("Line 165 IS ALSO THE WRONG LINE NUMBER SO SIKEEEE");

		if (FlxG.save.data.menutransitions)
		{
			FlxG.camera.zoom = 1.5;
			FlxG.camera.y = FlxG.height * -1;
			FlxTween.tween(FlxG.camera, { zoom: 1, y: 0}, 1, { ease: FlxEase.quadIn });
		}

		//OG.BSIDE = false;

		super.create();
	}

	var uptimer = new FlxTimer();
	var downtimer = new FlxTimer();
	var randomtimer = new FlxTimer();

	override function update(elapsed:Float)
	{
		FlxG.updateFramerate = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;
		if (!selectedWeek)
		{
			if (OG.StoryMenuType == 'section')
			{
				scoreText.visible = false;
				txtWeekTitle.visible = false;
				sprDifficulty.visible = false;
				leftArrow.visible = false;
				rightArrow.visible = false;
				controlstext.visible = false;
			}
			else
			{
				scoreText.visible = true;
				txtWeekTitle.visible = true;
				sprDifficulty.visible = true;
				leftArrow.visible = true;
				rightArrow.visible = true;
				controlstext.visible = true;
			}
		}

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);

					uptimer.start(0.3, function(tmr:FlxTimer)
					{
						uptimer.start(0.15, function(tmr:FlxTimer)
						{
							changeWeek(-1);
						}, 0);
					});
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);

					downtimer.start(0.3, function(tmr:FlxTimer)
					{
						downtimer.start(0.15, function(tmr:FlxTimer)
						{
							changeWeek(1);
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

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				if (OG.StoryMenuType != 'section')
					selectWeek();
				else
					selectSection();
			}
		}

		if (FlxG.keys.justPressed.BACKSPACE || (gamepad != null && !gamepad.pressed.RIGHT_SHOULDER && gamepad.justPressed.BACK) && !movedBack && !selectedWeek)
		{
			if (OG.StoryMenuType != 'section') {
				curWeek = 0;
				if (OG.StoryMenuType == 'bside')
				{
					FlxG.sound.music.stop();
					if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
						FlxG.sound.playMusic(Paths.music('frogMenuSPOOKY'));
					else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
						FlxG.sound.playMusic(Paths.music('frogMenuFESTIVE'));
					else
						FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
					FlxG.sound.music.time = 10448;
				}
				regenSections();
				changeWeek();
			}
			else
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				movedBack = true;
				OG.SelectedStoryMode = curWeek;
				OG.DifficultyStoryMode = curDifficulty;
				if (FlxG.save.data.menutransitions)
				{
					FlxTween.tween(FlxG.camera, { zoom: 0.1 }, 1, { ease: FlxEase.quadIn });
					MainMenuState.transition = 'zoom';
				}
				FlxG.switchState(new MainMenuState());
			}
		}

		if (FlxG.keys.justPressed.ESCAPE || (gamepad != null && gamepad.pressed.RIGHT_SHOULDER && gamepad.justPressed.BACK) && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			OG.SelectedStoryMode = curWeek;
			OG.DifficultyStoryMode = curDifficulty;
			if (OG.StoryMenuType == 'bside')
			{
				FlxG.sound.music.stop();
				if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
					FlxG.sound.playMusic(Paths.music('frogMenuSPOOKY'));
				else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
					FlxG.sound.playMusic(Paths.music('frogMenuFESTIVE'));
				else
					FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
				FlxG.sound.music.time = 10448;
			}
			if (FlxG.save.data.menutransitions)
			{
				FlxTween.tween(FlxG.camera, { zoom: 0.1 }, 1, { ease: FlxEase.quadIn });
				MainMenuState.transition = 'zoom';
			}
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.R && FlxG.save.data.leftBind != "R" && FlxG.save.data.downBind != "R" && FlxG.save.data.upBind != "R" && FlxG.save.data.rightBind != "R")
		{
			var totalweeks:Int = 0;

			for (item in grpWeekText.members)
			{
				totalweeks++;
			}

			curWeek = FlxG.random.int(0, totalweeks);
			changeWeek();

			randomtimer.start(0.3, function(tmr:FlxTimer)
			{
				randomtimer.start(0.08, function(tmr:FlxTimer)
				{
						curWeek = FlxG.random.int(0, totalweeks);
						changeWeek();
				}, 0);
			});
		}

		if (FlxG.keys.justReleased.R)
		{
			randomtimer.cancel();
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;
			PlayState.songMultiplier = 1;

			if (OG.StoryMenuType == 'bside')
				PlayState.storyPlaylist = bsideweekData[curWeek];

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
				case 3:
					diffic = '-hardplus';
			}

			PlayState.storyDifficulty = curDifficulty;
			var bsidecrap:String = '';
			if (OG.StoryMenuType == 'bside')
				bsidecrap = 'b-side/';
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, bsidecrap + PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				OG.SelectedStoryMode = curWeek;
				OG.DifficultyStoryMode = curDifficulty;
				if (FlxG.save.data.menutransitions)
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.height * -1}, 1, { ease: FlxEase.quadIn } );
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function selectSection()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}
			
			selectedWeek = true;

			switch (curWeek)
			{
				case 1:
					OG.StoryMenuType = 'bside';
				default:
					OG.StoryMenuType = 'normal';
			}

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				curWeek = 0;
				stopspamming = false;
				selectedWeek = false;
				regenWeeks();
				changeWeek();
				regenDifficultyFrames(OG.StoryMenuType == 'bside');
				changeDifficulty();
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
				sprDifficulty.offset.y = 0;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
				sprDifficulty.offset.y = 0;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
				sprDifficulty.offset.y = 0;
			case 3:
				sprDifficulty.animation.play('hardplus');
				sprDifficulty.offset.x = 40;
				sprDifficulty.offset.y = 5;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;
		switch (OG.StoryMenuType)
		{
			case 'section':
				if (curWeek >= 2)
					curWeek = 0;
				if (curWeek < 0)
					curWeek = 1;
			case 'bside':
				if (curWeek >= 7)
					curWeek = 0;
				if (curWeek < 0)
					curWeek = 6;
			default:
				if (curWeek >= weekData.length)
					curWeek = 0;
				if (curWeek < 0)
					curWeek = weekData.length - 1;
		}

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		switch (OG.StoryMenuType)
		{
			case 'section':
				FlxTween.color(txtTracklist, 0.5, txtTracklist.color, FlxColor.BLACK);
				FlxTween.color(BG, 0.5, BG.color, FlxColor.BLACK);
			case 'normal':
				FlxTween.color(txtTracklist, 0.5, txtTracklist.color, weekColors[curWeek]);
				FlxTween.color(BG, 0.5, BG.color, weekColors[curWeek]);
			case 'bside':
				FlxTween.color(txtTracklist, 0.5, txtTracklist.color, bsideweekColors[curWeek]);
				FlxTween.color(BG, 0.5, BG.color, bsideweekColors[curWeek]);
		}
		

		FlxG.sound.play(Paths.sound('scrollMenu'));

		if (OG.StoryMenuType != 'section')
			updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].animation.play(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].animation.play(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].animation.play(weekCharacters[curWeek][2]);
		txtTracklist.text = "Tracks\n\n";
		grpWeekCharacters.members[0].flipX = false;
		grpWeekCharacters.members[0].visible = true;
		grpWeekCharacters.members[1].visible = true;
		grpWeekCharacters.members[2].visible = true;

		switch (grpWeekCharacters.members[0].animation.curAnim.name)
		{
			case 'parents-christmas':
				grpWeekCharacters.members[0].offset.set(200, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 0.99));

			case 'senpai':
				grpWeekCharacters.members[0].offset.set(130, 0);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1.4));

			case 'mom':
				grpWeekCharacters.members[0].offset.set(100, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			case 'dad':
				grpWeekCharacters.members[0].offset.set(120, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
			
			case 'tankman':
				grpWeekCharacters.members[0].offset.set(60, -20);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
			
			case 'pico':
				grpWeekCharacters.members[0].offset.set(100, 100);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
				grpWeekCharacters.members[0].flipX = true;

			default:
				grpWeekCharacters.members[0].offset.set(100, 100);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
				// grpWeekCharacters.members[0].updateHitbox();
		}

		if (curWeek == 0 || curWeek == 8)
			grpWeekCharacters.members[0].visible = false;
		
		if (OG.StoryMenuType == 'section')
		{
			grpWeekCharacters.members[1].visible = false;
			grpWeekCharacters.members[2].visible = false;
			grpWeekCharacters.members[0].visible = false;
		}

		var stringThing:Array<String> = weekData[curWeek];
		if (OG.StoryMenuType == 'bside')
			stringThing = bsideweekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += i + "\n";
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	function regenSections()
	{
		grpWeekText.clear();
		grpLocks.clear(); // there probably aint any
		OG.BSIDE = false;
		OG.StoryMenuType = 'section';
		for (i in 0...2)
		{
			var weekThing:MenuItem = new MenuItem(0, BG.y + BG.height + 10, i, 'sections');
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}
	}

	function regenWeeks()
	{
		grpWeekText.clear();
		grpLocks.clear(); // there probably aint any
		OG.BSIDE = false;
		if (OG.StoryMenuType == 'bside') {
		OG.BSIDE = true;
		for (i in 0...7)
		{
			var weekThing:MenuItem = new MenuItem(0, BG.y + BG.height + 10, i, 'b-side');
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}
		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('freakyMenu-bside'));
		}
		else {
		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, BG.y + BG.height + 10, i, 'normal');

			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}
		}
	}

	function regenDifficultyFrames(bside:Bool)
	{
		if (bside)
		{
			leftArrow.x = grpWeekText.members[0].x + grpWeekText.members[0].width + 10;
			leftArrow.y = grpWeekText.members[0].y + 10;
			leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets-bside');
			leftArrow.animation.addByPrefix('idle', "arrow left");
			leftArrow.animation.addByPrefix('press', "arrow push left");
			sprDifficulty.x = leftArrow.x + 130;
			sprDifficulty.y = leftArrow.y;
			sprDifficulty.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets-bside');
			sprDifficulty.animation.addByPrefix('easy', 'EASY');
			sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
			sprDifficulty.animation.addByPrefix('hard', 'HARD');
			sprDifficulty.animation.addByPrefix('hardplus', 'PLUSHARD');
			rightArrow.x = sprDifficulty.x + sprDifficulty.width + 50;
			rightArrow.y = leftArrow.y;
			rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets-bside');
			rightArrow.animation.addByPrefix('idle', 'arrow right');
			rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		}
		else
		{
			leftArrow.x = grpWeekText.members[0].x + grpWeekText.members[0].width + 10;
			leftArrow.y = grpWeekText.members[0].y + 10;
			leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
			leftArrow.animation.addByPrefix('idle', "arrow left");
			leftArrow.animation.addByPrefix('press', "arrow push left");
			sprDifficulty.x = leftArrow.x + 130;
			sprDifficulty.y = leftArrow.y;
			sprDifficulty.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
			sprDifficulty.animation.addByPrefix('easy', 'EASY');
			sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
			sprDifficulty.animation.addByPrefix('hard', 'HARD');
			sprDifficulty.animation.addByPrefix('hardplus', 'PLUSHARD');
			rightArrow.x = sprDifficulty.x + sprDifficulty.width + 50;
			rightArrow.y = leftArrow.y;
			rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
			rightArrow.animation.addByPrefix('idle', 'arrow right');
			rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		}
	}
}
