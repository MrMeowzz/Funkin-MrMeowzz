package;

#if desktop
import Discord.DiscordClient;
#end
import Song.SwagSong;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxTimer;

using StringTools;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Toggle One Shot Mode', 'Toggle Practice Mode', 'Toggle Botplay', 'Change Character', 'Swap Sides', 'Options', 'Exit to menu'];
	var originalmenuItems:Array<String> = [];
	
	var curSelected:Int = 0;
	var modeText:FlxText;
	

	var pauseMusic:FlxSound;

	var lastSelected:Int = 0;

	var SelectionScreen:Bool = false;

	var ratelevelInfo:FlxText;

	var speedlevelInfo:FlxText;

	var bpmlevelInfo:FlxText;

	var rate:Float = PlayState.songMultiplier;
	var originalrate:Float = PlayState.songMultiplier;

	var originalpratice:Bool = PlayState.praticemode;
	var originaloneshot:Bool = PlayState.oneshot;
	var originalbotplay:Bool = PlayState.botplay;

	var loadedShit:Bool = false;

	var player:Int = 1;
	var player1Characters = [];
	var player2Characters = [];

	public function new(x:Float, y:Float)
	{
		loadedShit = false;
		if (!PlayState.isStoryMode)
			menuItems.remove("Skip Song");
		else
		{
			menuItems.remove("Swap Sides");
			menuItems.remove("Toggle One Shot Mode");
			menuItems.remove("Toggle Practice Mode");
			menuItems.remove("Toggle Botplay");
		}

		originalmenuItems = menuItems;

		if (OG.currentCutsceneEnded)
		{
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'stress' | 'guns' | 'ugh':
					originalmenuItems.insert(2, 'Restart Cutscene');
				default:
					originalmenuItems.insert(2, 'Restart Song with Dialog');
			}
		}

		super();

		var bside:String = '';
		if (OG.BSIDE)
			bside = 'b-side/';

		pauseMusic = new FlxSound().loadEmbedded(Paths.music(bside + 'breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		rate = PlayState.songMultiplier;
		originalrate = rate;
		originalpratice = PlayState.praticemode;
		originaloneshot = PlayState.oneshot;
		originalbotplay = PlayState.botplay;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		bpmlevelInfo = new FlxText(20, 15 + 32, 0, "", 32);
		bpmlevelInfo.text += "BPM:" + Std.int(PlayState.SONG.bpm * rate);
		bpmlevelInfo.scrollFactor.set();
		bpmlevelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		bpmlevelInfo.updateHitbox();
		add(bpmlevelInfo);

		var scrollspeed = PlayState.SONG.speed;
		if (FlxG.save.data.overridespeed)
			scrollspeed = FlxG.save.data.scrollspeed;

		speedlevelInfo = new FlxText(20, 15 + 64, 0, "", 32);
		speedlevelInfo.text += "SPEED:" + scrollspeed * rate;
		speedlevelInfo.scrollFactor.set();
		speedlevelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		speedlevelInfo.updateHitbox();
		add(speedlevelInfo);

		ratelevelInfo = new FlxText(20, 15 + 96, 0, "", 32);
		ratelevelInfo.text += "RATE:" + rate;
		ratelevelInfo.scrollFactor.set();
		ratelevelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		ratelevelInfo.updateHitbox();
		add(ratelevelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 128, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var deathMenuCounter:FlxText = new FlxText(20, 15 + 160, 0, "", 32);
		if (FlxG.save.data.cleanmode)
			deathMenuCounter.text = "Deaths: " + PlayState.deathCounter;
		else
			deathMenuCounter.text = "Blue balled: " + PlayState.deathCounter;
		deathMenuCounter.scrollFactor.set();
		deathMenuCounter.setFormat(Paths.font('vcr.ttf'), 32);
		deathMenuCounter.updateHitbox();
		add(deathMenuCounter);

		var playingAs:FlxText = new FlxText(20, 15 + 192, 0, "", 32);
		playingAs.text = "Playing as: " + (PlayState.swappedsides ? 'player2' : 'player1');
		playingAs.scrollFactor.set();
		playingAs.setFormat(Paths.font('vcr.ttf'), 32);
		playingAs.updateHitbox();
		add(playingAs);

		modeText = new FlxText(20, 20 + 224, 0, "", 32);
		modeText.scrollFactor.set();
		modeText.setFormat(Paths.font('vcr.ttf'), 32);
		modeText.updateHitbox();
		if (modeText.visible)
			modeText.y -= 5;
		// I KNOW HOW TO SPELL PRACTICE
		if (PlayState.praticemode)
		{
			modeText.visible = true;
			modeText.text = "PRACTICE MODE";
		}
		else if (PlayState.oneshot)
		{
			modeText.visible = true;
			modeText.text = "ONE SHOT MODE";
		}
		else if (PlayState.botplay)
		{
			modeText.visible = true;
			modeText.text = "BOTPLAY ON";
		}
		else
		{
			modeText.visible = false;
		}
		add(modeText);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		bpmlevelInfo.alpha = 0;
		speedlevelInfo.alpha = 0;
		ratelevelInfo.alpha = 0;
		deathMenuCounter.alpha = 0;
		playingAs.alpha = 0;
		if (modeText.visible)
			modeText.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		bpmlevelInfo.x = FlxG.width - (bpmlevelInfo.width + 20);
		speedlevelInfo.x = FlxG.width - (speedlevelInfo.width + 20);
		ratelevelInfo.x = FlxG.width - (ratelevelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		deathMenuCounter.x = FlxG.width - (deathMenuCounter.width + 20);
		modeText.x = FlxG.width - (modeText.width + 20);
		playingAs.x = FlxG.width - (playingAs.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(bpmlevelInfo, {alpha: 1, y: bpmlevelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(speedlevelInfo, {alpha: 1, y: speedlevelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(ratelevelInfo, {alpha: 1, y: ratelevelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.1});
		FlxTween.tween(deathMenuCounter, {alpha: 1, y: deathMenuCounter.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.3});
		FlxTween.tween(playingAs, {alpha: 1, y: playingAs.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.5});
		if (modeText.visible)
			FlxTween.tween(modeText, {alpha: 1, y: modeText.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		new FlxTimer().start(0.25, function(tmr:FlxTimer)
		{
			loadedShit = true;
		});
		if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
		{
			levelInfo.color = FlxColor.ORANGE;
			bpmlevelInfo.color = FlxColor.ORANGE;
			speedlevelInfo.color = FlxColor.ORANGE;
			ratelevelInfo.color = FlxColor.ORANGE;
			levelDifficulty.color = FlxColor.ORANGE;
			deathMenuCounter.color = FlxColor.ORANGE;
			playingAs.color = FlxColor.ORANGE;
			modeText.color = FlxColor.ORANGE;
		}
		else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
		{
			levelInfo.color = FlxColor.CYAN;
			bpmlevelInfo.color = FlxColor.CYAN;
			speedlevelInfo.color = FlxColor.CYAN;
			ratelevelInfo.color = FlxColor.CYAN;
			levelDifficulty.color = FlxColor.CYAN;
			deathMenuCounter.color = FlxColor.CYAN;
			playingAs.color = FlxColor.CYAN;
			modeText.color = FlxColor.CYAN;
		}
	}

	public function regenMenu()
	{
		grpMenuShit.clear();
		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}
	}

	public function toggleResume(canResume:Bool)
	{
		if (!originalmenuItems.contains('Resume') && canResume)
		{
			var Selected = curSelected;					
			originalmenuItems.insert(0, 'Resume');
			lastSelected += 1;
			if (menuItems.contains('Exit to menu'))
			{
				Selected += 1;
				regenMenu();
				curSelected = Selected;
				changeSelection();
			}
		}
		else if (originalmenuItems.contains('Resume') && !canResume)
		{
			var Selected = curSelected;
			originalmenuItems.remove('Resume');
			lastSelected -= 1;
			if (menuItems.contains('Exit to menu'))
			{
				if (Selected > 0)
					Selected -= 1;
				regenMenu();
				curSelected = Selected;
				changeSelection();
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		#if desktop
			if (PlayState.praticemode)
				PlayState.modeText = " - Practice Mode";
			else if (PlayState.oneshot)
				PlayState.modeText = " - One Shot Mode";
			else
				PlayState.modeText = '';
			DiscordClient.changePresence(PlayState.detailsPausedText, PlayState.SONG.song + " (" + PlayState.storyDifficultyText + PlayState.modeText + ") Misses: " + PlayState.misses + " | Score: " + PlayState.songScore + " | Health: " + PlayState.healthTxt.text.substring(7) + " | Accuracy: " + PlayState.accuracyTxt.text.substring(9) + " " + PlayState.ratingTxt.text, PlayState.player2RPC, PlayState.player1RPC);
		#end

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var exit = controls.BACK;
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (exit)
		{
			if (SelectionScreen)
			{
				SelectionScreen = false;
				menuItems = originalmenuItems;
				regenMenu();
				curSelected = lastSelected;
				changeSelection();
			}
			else if (originalmenuItems.contains('Resume'))
			{
				close();
			}
		}

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		#if desktop
		if ((FlxG.keys.pressed.SHIFT || (gamepad != null && gamepad.pressed.LEFT_SHOULDER)) && !PlayState.isStoryMode)
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
			PlayState.songMultiplier = rate;
			if ((controls.LEFT_P || controls.RIGHT_P))
			{
				if (rate == originalrate)
					toggleResume(true);
				else
					toggleResume(false);
			}

			var scrollspeed = PlayState.SONG.speed;
			if (FlxG.save.data.overridespeed)
				scrollspeed = FlxG.save.data.scrollspeed;
			
			ratelevelInfo.text = "RATE:" + rate;
			bpmlevelInfo.text = "BPM:" + Std.int(PlayState.SONG.bpm * rate);
			speedlevelInfo.text = "SPEED:" + scrollspeed * rate;
			bpmlevelInfo.x = FlxG.width - (bpmlevelInfo.width + 20);
			speedlevelInfo.x = FlxG.width - (speedlevelInfo.width + 20);
			ratelevelInfo.x = FlxG.width - (ratelevelInfo.width + 20);
		}
		#end

		if (accepted && loadedShit)
		{
			var daSelected:String = menuItems[curSelected];
			var lastCharacter:String = PlayState.SONG.player1;
			var lastEnemy:String = PlayState.SONG.player2;
			var difficulty:String = "";
			var gfVersion:String = 'gf'; 
			if (PlayState.SONG.gf != null)
				gfVersion = PlayState.SONG.gf;
			SelectionScreen = false;
			var bsidecrap:String = '';

			if (OG.BSIDE)
			{
				bsidecrap = 'b-side/';
			}
			/*
			switch (PlayState.curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';				
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				case 'tank':
					gfVersion = 'gf-tankmen';
					if (PlayState.SONG.song.toLowerCase() == 'stress')
						gfVersion = 'pico-speaker';
				case 'amogus':
					gfVersion = 'gf-amogus';
			}
			*/
			switch (PlayState.storyDifficulty)
			{
				case 0:
					difficulty = '-easy';						
				case 2:
					difficulty = '-hard';
				case 3:
					difficulty = '-hardplus';
				default:
					difficulty = '';
			}

			switch (daSelected)
			{
				case "BACK":
					menuItems = originalmenuItems;
					regenMenu();
					curSelected = lastSelected;
					changeSelection();
				case "Skip Song":
					PlayState.deathCounter = 0;
					PlayState.storyPlaylist.remove(PlayState.storyPlaylist[0]);
					PlayState.campaignScore += PlayState.songScore;
					OG.currentCutsceneEnded = false;
					if (PlayState.storyPlaylist.length <= 0) 
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
						if (PlayState.SONG.validScore)
							Highscore.saveWeekScore(PlayState.storyWeek, PlayState.campaignScore, PlayState.storyDifficulty);

						FlxG.switchState(new StoryMenuState());
					}
					else
					{
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, bsidecrap + PlayState.storyPlaylist[0].toLowerCase());
						if (!lastCharacter.startsWith("bf"))
							PlayState.SONG.player1 = lastCharacter;
						if (lastEnemy != PlayState.SONG.player2)
							PlayState.SONG.player2 = lastEnemy;

						if (FlxG.save.data.menutransitions)
							FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
						LoadingState.loadAndSwitchState(new PlayState());
					}
				case "Resume":
					close();
				case "Restart Song":
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					FlxG.resetState();
				case "Restart Song with Dialog" | "Restart Cutscene":
					OG.currentCutsceneEnded = false;
					OG.forceCutscene = true;
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					FlxG.resetState();
				case "Exit to menu":
					PlayState.deathCounter = 0;
					OG.currentCutsceneEnded = false;
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					if (PlayState.isStoryMode)
						FlxG.switchState(new StoryMenuState());
					else
						FlxG.switchState(new FreeplayState());
				case "Toggle Practice Mode":
					PlayState.praticemode = !PlayState.praticemode;
					modeText.visible = PlayState.praticemode;
					modeText.text = "PRACTICE MODE";
					modeText.x = FlxG.width - (modeText.width + 20);
					PlayState.oneshot = false;
					PlayState.botplay = false;
					if (PlayState.misses > 0 || PlayState.goodnotes > 0) {
					if (PlayState.praticemode == originalpratice)
						toggleResume(true);
					else
						toggleResume(false);
					}
				case "Toggle One Shot Mode":
					PlayState.oneshot = !PlayState.oneshot;
					modeText.visible = PlayState.oneshot;
					modeText.text = "ONE SHOT MODE";
					modeText.x = FlxG.width - (modeText.width + 20);
					PlayState.praticemode = false;
					PlayState.botplay = false;
					if (PlayState.misses > 0 || PlayState.goodnotes > 0) {
					if (PlayState.oneshot == originaloneshot)
						toggleResume(true);
					else
						toggleResume(false);
					}
				case "Toggle Botplay":
					PlayState.botplay = !PlayState.botplay;
					modeText.visible = PlayState.botplay;
					modeText.text = "BOTPLAY ON";
					modeText.x = FlxG.width - (modeText.width + 20);
					PlayState.praticemode = false;
					PlayState.oneshot = false;
					if (PlayState.misses > 0 || PlayState.goodnotes > 0) {
					if (PlayState.botplay == originalbotplay)
						toggleResume(true);
					else
						toggleResume(false);
					}
				case "Change Difficulty":
					lastSelected = curSelected;
					SelectionScreen = true;				
					menuItems = CoolUtil.difficultyArray.copy();
					if (OG.BSIDE)
					{
						menuItems = CoolUtil.bsidedifficultyArray.copy();
					}
					menuItems.push("BACK");
					regenMenu();
					curSelected = 0;
					changeSelection();
				case "Player One" | "Player Two":
					SelectionScreen = true;
					if (daSelected == "Player One")
						player = 1;
					else
						player = 2;
					menuItems = ['amog us', 'amog us guy', 'bf', 'dad', 'gf', 'mom', 'monster', 'parents', 'pico', 'spooky kids', 'tankman', 'BACK'];
					var pixelmenuItems:Array<String> = ['bf', 'pico', 'senpai', 'spirit', 'tankman', 'BACK'];
					if (!PlayState.curStage.startsWith('school'))
					{
						player1Characters = ['bf-amogus', 'amogusguy', 'bf', 'dad', 'gf', 'mom', 'monster', 'parents-christmas', 'pico', 'spooky', 'tankman'];
						player2Characters = player1Characters;
						if (player == 1)
						{
							if (menuItems.contains(PlayState.SONG.player1) || player1Characters.contains(PlayState.SONG.player1))
							{
								menuItems.remove(PlayState.SONG.player1);
								player1Characters.remove(PlayState.SONG.player1);
							}

							if (PlayState.SONG.player1 == 'bf-amogus')
							{
								menuItems.remove('amog us');
								player1Characters.remove('bf-amogus');
							}

							if (PlayState.SONG.player1.startsWith('monster'))
							{
								menuItems.remove('monster');
								player1Characters.remove('monster');
							}

							if (PlayState.SONG.player1.startsWith('mom'))
							{
								menuItems.remove('mom');
								player1Characters.remove('mom');
							}

							if (PlayState.SONG.player1 == gfVersion)
							{
								menuItems.remove('gf');
								player1Characters.remove('gf');
							}

							if (gfVersion != "gf-christmas" && gfVersion != "gf" && PlayState.SONG.player1 != "gf")
							{
								menuItems.remove('gf');
								player1Characters.remove('gf');
							}

							if (PlayState.SONG.player1.startsWith('bf') && PlayState.SONG.player1 != 'bf-amogus' && (PlayState.SONG.song.toLowerCase() == 'test' && PlayState.SONG.player1 != 'bf-pixel'))
							{
								menuItems.remove('bf');
								player1Characters.remove('bf');
							}
						}
						else
						{
							if (menuItems.contains(PlayState.SONG.player2))
							{
								menuItems.remove(PlayState.SONG.player2);
								player2Characters.remove(PlayState.SONG.player2);
							}
								
							if (PlayState.SONG.player2 == 'bf-amogus')
							{
								menuItems.remove('amog us');
								player2Characters.remove('bf-amogus');
							}

							if (PlayState.SONG.player2.startsWith('monster'))
							{
								menuItems.remove('monster');
								player2Characters.remove('mmonster');
							}

							if (PlayState.SONG.player2.startsWith('mom'))
							{
								menuItems.remove('mom');
								player2Characters.remove('mom');
							}

							if (PlayState.SONG.player2 == gfVersion)
							{
								menuItems.remove('gf');
								player2Characters.remove('gf');
							}

							if (gfVersion != "gf-christmas" && gfVersion != "gf" && PlayState.SONG.player2 != "gf")
							{
								menuItems.remove('gf');
								player2Characters.remove('gf');
							}

							if (PlayState.SONG.player2.startsWith('bf') && PlayState.SONG.player2 != 'bf-amogus' && (PlayState.SONG.song.toLowerCase() == 'test' && PlayState.SONG.player2 != 'bf-pixel'))							
							{
								menuItems.remove('bf');
								player2Characters.remove('bf');
							}
						}

						if (PlayState.SONG.song.toLowerCase() == "among us drip")
						{
							menuItems.remove('bf');
							player1Characters.remove('bf');
							player2Characters.remove('bf');
						}

						if (PlayState.SONG.song.toLowerCase() == 'high effort ugh' || PlayState.SONG.song.toLowerCase() == 'h.e. no among us')
						{
							menuItems.remove('tankman');
							player1Characters.remove('tankman');
							player2Characters.remove('tankman');
						}
							
						if (PlayState.SONG.song == 'Old Bopeebo')
						{
							menuItems.remove('gf');
							player1Characters.remove('gf');
							player2Characters.remove('gf');
						}
						if (OG.BSIDE)
						{
							menuItems.remove('tankman');
							menuItems.remove('amog us');
							player1Characters.remove('tankman');
							player2Characters.remove('tankman');
							player1Characters.remove('bf-amogus');
							player2Characters.remove('bf-amogus');
						}
					}
					else
					{
						player1Characters = ['bf-pixel', 'tankman-pixel', 'pico-pixel', 'senpai', 'spirit'];
						player2Characters = player1Characters;
						menuItems = pixelmenuItems;
						var nonpixel:String;
						if (player == 1)
							nonpixel = Std.string(PlayState.SONG.player1);
						else
							nonpixel = Std.string(PlayState.SONG.player2);

						nonpixel = nonpixel.replace("-pixel","");
						if (menuItems.contains(nonpixel))
						{
							menuItems.remove(nonpixel);
							if (player == 1)
								player1Characters.remove(PlayState.SONG.player1);
							else
								player2Characters.remove(PlayState.SONG.player2);
						}

						if (player == 1)
						{
							if (PlayState.SONG.player1 == 'senpai-angry')
							{
								menuItems.remove('senpai');
								player1Characters.remove('senpai');
							}
						}
						else
						{
							if (PlayState.SONG.player2 == 'senpai-angry')
							{
								menuItems.remove('senpai');
								player2Characters.remove('senpai');
							}
						}			

						if (OG.BSIDE)
						{
							menuItems.remove('tankman');
							menuItems.remove('pico');
							player1Characters.remove('tankman-pixel');
							player2Characters.remove('tankman-pixel');
							player1Characters.remove('pico-pixel');
							player2Characters.remove('pico-pixel');
						}
					}
					regenMenu();
					curSelected = 0;
					changeSelection();
				case "Change Character":
					lastSelected = curSelected;
					SelectionScreen = true;
					menuItems = ['Player One', 'Player Two', 'BACK'];
					regenMenu();
					curSelected = 0;
					changeSelection();
				case "EASY" | "NORMAL" | "HARD" | "HARD PLUS" | "EASIER" | "STANDARD" | "FLIP" | "FLIP PLUS":
					switch (daSelected)
					{
						case "EASY" | "EASIER":
							difficulty = '-easy';						
						case "HARD" | "FLIP":
							difficulty = '-hard';
						case "HARD PLUS" | "FLIP PLUS":
							difficulty = '-hardplus';
						default:
							difficulty = '';
					}
					if (CoolUtil.difficultyString() == daSelected && originalmenuItems.contains('Resume'))
					{
						close();
						return;
					}
					var folder = bsidecrap + PlayState.SONG.song.toLowerCase();
					PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, folder);
					if (!lastCharacter.startsWith("bf"))
						PlayState.SONG.player1 = lastCharacter;
					if (lastEnemy != PlayState.SONG.player2)
						PlayState.SONG.player2 = lastEnemy;

					PlayState.storyDifficulty = curSelected;
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "amog us" | "amog us guy" | "bf" | "dad" | "gf" | "mom" | "monster" | "parents" | "pico" | "spooky kids" | "tankman":
					if (player == 1)
						PlayState.SONG.player1 = player1Characters[curSelected];
					else
						PlayState.SONG.player2 = player2Characters[curSelected];
					//extra char stuf
					switch (daSelected)
					{
						case "tankman":
							if (player == 1)
							{
								if (PlayState.curStage.startsWith('school'))
									PlayState.SONG.player1 += "-pixel";
								else if (PlayState.SONG.song.toLowerCase() == 'no among us')
									PlayState.SONG.player1 += "noamongus";
							}
							else
							{
								if (PlayState.curStage.startsWith('school'))
									PlayState.SONG.player2 += "-pixel";
								else if (PlayState.SONG.song.toLowerCase() == 'no among us')
									PlayState.SONG.player2 += "noamongus";
							}
						case "bf":
							var placeholderSong:SwagSong = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
							if (placeholderSong.player1.startsWith('bf')) {
							if (player == 1)
								PlayState.SONG.player1 = placeholderSong.player1;
							else
								PlayState.SONG.player2 = placeholderSong.player1;
							}
						case "pico":
							if (PlayState.curStage == "school" || PlayState.curStage == "schoolEvil")
							{
								if (player == 1)
									PlayState.SONG.player1 += "-pixel";
								else
									PlayState.SONG.player2 += "-pixel";
							}
						case "gf":
							if (player == 1)
								PlayState.SONG.player1 = gfVersion;
							else
								PlayState.SONG.player2 = gfVersion;
						case "monster":
							if (PlayState.curStage.startsWith('mall'))
							{
								if (player == 1)
									PlayState.SONG.player1 += "-christmas";
								else
									PlayState.SONG.player2 += "-christmas";
							}
						case "mom":
							if (PlayState.curStage == 'limo')
							{
								if (player == 1)
									PlayState.SONG.player1 += "-car";
								else
									PlayState.SONG.player2 += "-car";
							}
						case "senpai":
							if (PlayState.SONG.song.toLowerCase() == 'roses')
							{
								if (player == 1)
									PlayState.SONG.player1 += "-angry";
								else
									PlayState.SONG.player2 += "-angry";
							}
					}
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				/*				
				case "tankman":
					if (player == 1)
					{
						if (PlayState.curStage == "school" || PlayState.curStage == "schoolEvil")
						{
							PlayState.SONG.player1 = "tankman-pixel";
						}
						else if (PlayState.SONG.song.toLowerCase() == 'no among us')
						{
							PlayState.SONG.player1 = "tankmannoamongus";
						}
						else
						{
							PlayState.SONG.player1 = "tankman";
						}
					}
					else
					{
						if (PlayState.curStage == "school" || PlayState.curStage == "schoolEvil")
						{
							PlayState.SONG.player2 = "tankman-pixel";
						}
						else if (PlayState.SONG.song.toLowerCase() == 'no among us')
						{
							PlayState.SONG.player2 = "tankmannoamongus";
						}
						else
						{
							PlayState.SONG.player2 = "tankman";
						}
					}
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "bf":
					var placeholderSong:SwagSong = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					if (player == 1)
						PlayState.SONG.player1 = placeholderSong.player1;
					else
						PlayState.SONG.player2 = placeholderSong.player1;
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "pico":
					if (player == 1)
					{
						if (PlayState.curStage == "school" || PlayState.curStage == "schoolEvil")
						{
							PlayState.SONG.player1 = "pico-pixel";
						}
						else
						{
							PlayState.SONG.player1 = "pico";
						}
					}
					else
					{
						if (PlayState.curStage == "school" || PlayState.curStage == "schoolEvil")
						{
							PlayState.SONG.player2 = "pico-pixel";
						}
						else
						{
							PlayState.SONG.player2 = "pico";
						}
					}
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "gf":
					if (player == 1)
						PlayState.SONG.player1 = gfVersion;
					else
						PlayState.SONG.player2 = gfVersion;
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "amog us":
					if (player == 1)
						PlayState.SONG.player1 = "bf-amogus";
					else
						PlayState.SONG.player2 = "bf-amogus";
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "monster":
					if (player == 1) 
					{
						PlayState.SONG.player1 = "monster";
						if (PlayState.curStage.startsWith('mall'))
							PlayState.SONG.player1 += "-christmas";
					}
					else
					{
						PlayState.SONG.player2 = "monster";
						if (PlayState.curStage.startsWith('mall'))
							PlayState.SONG.player2 += "-christmas";
					}
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "mom":
					if (player == 1)
					{
						PlayState.SONG.player1 = "mom";
						if (PlayState.curStage == 'limo')
							PlayState.SONG.player1 += "-car";
					}
					else
					{
						PlayState.SONG.player2 = "mom";
						if (PlayState.curStage == 'limo')
							PlayState.SONG.player2 += "-car";
					}
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "senpai":
					if (player == 1)
					{
						PlayState.SONG.player1 = "senpai";
						if (PlayState.SONG.song.toLowerCase() == 'roses')
							PlayState.SONG.player1 += "-angry";
					}
					else
					{
						PlayState.SONG.player2 = "senpai";
						if (PlayState.SONG.song.toLowerCase() == 'roses')
							PlayState.SONG.player2 += "-angry";
					}
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "spirit":
					if (player == 1)
						PlayState.SONG.player1 = "spirit";
					else
						PlayState.SONG.player2 = "spirit";
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				*/
				case "Swap Sides":
					PlayState.swappedsides = !PlayState.swappedsides;
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					FlxG.resetState();
				case "Options":
					OptionsState.pauseMenu = true;
					FlxG.switchState(new OptionsState());
					if (FlxG.save.data.menutransitions)
						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}
	
	


	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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
	}
}
