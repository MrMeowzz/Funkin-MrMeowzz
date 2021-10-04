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

using StringTools;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Toggle One Shot Mode', 'Toggle Practice Mode', 'Change Character', 'Exit to menu'];
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

	public function new(x:Float, y:Float)
	{
		if (!PlayState.isStoryMode)
		{
			menuItems.remove("Skip Song");
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

		speedlevelInfo = new FlxText(20, 15 + 64, 0, "", 32);
		speedlevelInfo.text += "SPEED:" + PlayState.SONG.speed * rate;
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

		modeText = new FlxText(20, 15 + 192, 0, "", 32);
		modeText.scrollFactor.set();
		modeText.setFormat(Paths.font('vcr.ttf'), 32);
		modeText.updateHitbox();
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
		else
		{
			modeText.visible = false;
		}
		add(modeText);

		var sicks:FlxText = new FlxText(20, 568, 0, "", 32);
		sicks.text += "SICKS: " + PlayState.sicks;
		sicks.scrollFactor.set();
		sicks.setFormat(Paths.font("vcr.ttf"), 32);
		sicks.updateHitbox();
		add(sicks);

		var goods:FlxText = new FlxText(20, 568 + 32, 0, "", 32);
		goods.text += "GOODS: " + PlayState.goods;
		goods.scrollFactor.set();
		goods.setFormat(Paths.font("vcr.ttf"), 32);
		goods.updateHitbox();
		add(goods);

		var bads:FlxText = new FlxText(20, 568 + 64, 0, "", 32);
		if (PlayState.curStage.startsWith('amogus'))
			bads.text += "SUS: " + PlayState.bads;
		else
			bads.text += "BADS: " + PlayState.bads;
		bads.scrollFactor.set();
		bads.setFormat(Paths.font("vcr.ttf"), 32);
		bads.updateHitbox();
		add(bads);

		var shits:FlxText = new FlxText(20, 568 + 96, 0, "", 32);
		if (PlayState.curStage.startsWith('amogus'))
			shits.text += "SUS!: " + PlayState.shits;
		else if (FlxG.save.data.cleanmode)
			shits.text += "TERRIBLES: " + PlayState.shits;
		else
			shits.text += "SHITS: " + PlayState.shits;
		shits.scrollFactor.set();
		shits.setFormat(Paths.font("vcr.ttf"), 32);
		shits.updateHitbox();
		add(shits);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		bpmlevelInfo.alpha = 0;
		speedlevelInfo.alpha = 0;
		ratelevelInfo.alpha = 0;
		deathMenuCounter.alpha = 0;
		sicks.alpha = 0;
		goods.alpha = 0;
		bads.alpha = 0;
		shits.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		bpmlevelInfo.x = FlxG.width - (bpmlevelInfo.width + 20);
		speedlevelInfo.x = FlxG.width - (speedlevelInfo.width + 20);
		ratelevelInfo.x = FlxG.width - (ratelevelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		deathMenuCounter.x = FlxG.width - (deathMenuCounter.width + 20);
		modeText.x = FlxG.width - (modeText.width + 20);
		sicks.x = FlxG.width - (sicks.width + 20);
		goods.x = FlxG.width - (goods.width + 20);
		bads.x = FlxG.width - (bads.width + 20);
		shits.x = FlxG.width - (shits.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(bpmlevelInfo, {alpha: 1, y: bpmlevelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(speedlevelInfo, {alpha: 1, y: speedlevelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(ratelevelInfo, {alpha: 1, y: ratelevelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.1});
		FlxTween.tween(deathMenuCounter, {alpha: 1, y: deathMenuCounter.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.3});

		FlxTween.tween(sicks, {alpha: 1, y: sicks.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(goods, {alpha: 1, y: goods.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(bads, {alpha: 1, y: bads.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(shits, {alpha: 1, y: shits.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});

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
			if ((controls.LEFT_P || controls.RIGHT_P) && originalmenuItems.contains('Resume'))
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
			else if ((controls.LEFT_P || controls.RIGHT_P) && !originalmenuItems.contains('Resume') && rate == originalrate)
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
			
			ratelevelInfo.text = "RATE:" + rate;
			bpmlevelInfo.text = "BPM:" + Std.int(PlayState.SONG.bpm * rate);
			speedlevelInfo.text = "SPEED:" + PlayState.SONG.speed * rate;
			bpmlevelInfo.x = FlxG.width - (bpmlevelInfo.width + 20);
			speedlevelInfo.x = FlxG.width - (speedlevelInfo.width + 20);
			ratelevelInfo.x = FlxG.width - (ratelevelInfo.width + 20);
		}
		#end

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			var lastOpponent:String = PlayState.SONG.player2;
			var lastCharacter:String = PlayState.SONG.player1;
			var lastStage:String = PlayState.curStage;
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
							FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
						if (PlayState.SONG.validScore)
							Highscore.saveWeekScore(PlayState.storyWeek, PlayState.campaignScore, PlayState.storyDifficulty);

						FlxG.switchState(new StoryMenuState());
					}
					else
					{
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, bsidecrap + PlayState.storyPlaylist[0].toLowerCase());
						if (!lastCharacter.startsWith("bf"))
							PlayState.SONG.player1 = lastCharacter;
						if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter.startsWith("senpai") || lastCharacter == 'spirit'))
							PlayState.SONG = Song.loadFromJson("swap" + PlayState.storyPlaylist[0].toLowerCase() + difficulty, bsidecrap + PlayState.storyPlaylist[0].toLowerCase());

						FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
						LoadingState.loadAndSwitchState(new PlayState());
					}
				case "Resume":
					close();
				case "Restart Song":
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					FlxG.resetState();
				case "Restart Song with Dialog" | "Restart Cutscene":
					OG.currentCutsceneEnded = false;
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					FlxG.resetState();
				case "Exit to menu":
					PlayState.deathCounter = 0;
					OG.currentCutsceneEnded = false;
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width}, 1, {ease: FlxEase.quadIn });
					FlxG.switchState(new MainMenuState());
				case "Toggle Practice Mode":
					PlayState.praticemode = !PlayState.praticemode;
					modeText.visible = PlayState.praticemode;
					modeText.text = "PRACTICE MODE";
					modeText.x = FlxG.width - (modeText.width + 20);
					PlayState.oneshot = false;
				case "Toggle One Shot Mode":
					PlayState.oneshot = !PlayState.oneshot;
					modeText.visible = PlayState.oneshot;
					modeText.text = "ONE SHOT MODE";
					modeText.x = FlxG.width - (modeText.width + 20);
					PlayState.praticemode = false;
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
				case "Change Character":
					lastSelected = curSelected;
					SelectionScreen = true;
					menuItems = ['bf', 'bf-pixel', 'amog us', 'monster', 'tankman', 'pico', 'mom', 'gf', 'BACK'];
					var pixelmenuItems:Array<String> = ['bf', 'tankman', 'pico', 'senpai', 'spirit', 'BACK'];
					if (!PlayState.curStage.startsWith('school'))
					{
						if (menuItems.contains(PlayState.SONG.player1))
							menuItems.remove(PlayState.SONG.player1);

						if (gfVersion != "gf-christmas" && gfVersion != "gf" && PlayState.SONG.player2 != "gf")
							menuItems.remove('gf');

						if (PlayState.SONG.song.toLowerCase() == "among us drip")
							menuItems.remove('bf');

						if (PlayState.SONG.player1 == 'bf-amogus')
							menuItems.remove('amog us');

						if (PlayState.SONG.player1.startsWith('monster'))
							menuItems.remove('monster');

						if (PlayState.SONG.player1.startsWith('mom'))
							menuItems.remove('mom');

						if (PlayState.SONG.player1 == gfVersion)
							menuItems.remove('gf');

						if (PlayState.SONG.player1.startsWith('bf') && PlayState.SONG.player1 != 'bf-amogus' && (PlayState.SONG.song.toLowerCase() == 'test' && PlayState.SONG.player1 != 'bf-pixel'))
							menuItems.remove('bf');

						if (PlayState.SONG.song.toLowerCase() == 'high effort ugh' || PlayState.SONG.song.toLowerCase() == 'h.e. no among us')
							menuItems.remove('tankman');
							
						if (PlayState.SONG.song == 'Old Bopeebo')
							menuItems.remove('gf');

						if (PlayState.SONG.song.toLowerCase() != 'test' || PlayState.SONG.player1 == 'bf-pixel')
							menuItems.remove('bf-pixel');
						if (OG.BSIDE)
						{
							if (menuItems.contains(PlayState.SONG.player2))
								menuItems.remove(PlayState.SONG.player2);
							menuItems.remove('tankman');
							menuItems.remove('amog us');
						}
					}
					else
					{
						menuItems = pixelmenuItems;
						var nonpixel:String = Std.string(PlayState.SONG.player1);
						nonpixel = nonpixel.replace("-pixel","");
						if (menuItems.contains(nonpixel))
							menuItems.remove(nonpixel);

						if (PlayState.SONG.player1 == 'senpai-angry')
							menuItems.remove('senpai');			

						if (OG.BSIDE)
						{
							if (menuItems.contains(PlayState.SONG.player2))
								menuItems.remove(PlayState.SONG.player2);
							if (PlayState.SONG.player2 == 'senpai-angry')
								menuItems.remove('senpai');
							menuItems.remove('tankman');
							menuItems.remove('pico');
						}
					}
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
						
					if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter.startsWith("senpai") || lastCharacter == 'spirit'))
						PlayState.SONG = Song.loadFromJson("swap" + PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("swaptutorial" + difficulty, bsidecrap + "tutorial");

					PlayState.storyDifficulty = curSelected;
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "tankman":
					if (PlayState.curStage == 'tank')
						PlayState.SONG = Song.loadFromJson("swap" + PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastCharacter.startsWith("mom") || lastCharacter.startsWith("senpai") || lastCharacter == 'spirit'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, bsidecrap + "tutorial");

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
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "bf":						
					PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					PlayState.SONG.player1 = PlayState.SONG.player1;
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "pico":
					if (PlayState.curStage == 'philly')
						PlayState.SONG = Song.loadFromJson("swap" + PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter.startsWith("senpai") || lastCharacter == 'spirit' || lastCharacter == 'bf-pixel'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, bsidecrap + "tutorial");
					if (PlayState.curStage == "school" || PlayState.curStage == "schoolEvil")
					{
						PlayState.SONG.player1 = "pico-pixel";
					}
					else
					{
						PlayState.SONG.player1 = "pico";
					}
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "gf":
					if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter.startsWith("senpai") || lastCharacter == 'spirit' || lastCharacter == 'bf-pixel'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("swaptutorial" + difficulty, bsidecrap + "tutorial");
					PlayState.SONG.player1 = gfVersion;
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "amog us":
					if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter.startsWith("senpai") || lastCharacter == 'spirit' || lastCharacter == 'bf-pixel'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, bsidecrap + "tutorial");
					PlayState.SONG.player1 = "bf-amogus";
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "monster":
					if (PlayState.SONG.player2.startsWith('monster'))
						PlayState.SONG = Song.loadFromJson("swap" + PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter == 'spirit' || lastCharacter == 'bf-pixel'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, bsidecrap + "tutorial");
					PlayState.SONG.player1 = "monster";
					if (PlayState.curStage.startsWith('mall'))
						PlayState.SONG.player1 += "-christmas";
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "mom":
					if (PlayState.SONG.player2.startsWith('mom'))
						PlayState.SONG = Song.loadFromJson("swap" + PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("senpai") || lastCharacter == 'spirit' || lastCharacter == 'bf-pixel'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, bsidecrap + "tutorial");
					PlayState.SONG.player1 = "mom";
					if (PlayState.curStage == 'limo')
						PlayState.SONG.player1 += "-car";
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "senpai":
					if (PlayState.SONG.player2.startsWith('senpai'))
						PlayState.SONG = Song.loadFromJson("swap" + PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter == 'spirit' || lastCharacter == 'bf-pixel'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, bsidecrap + "tutorial");
					PlayState.SONG.player1 = "senpai";
					if (PlayState.SONG.song.toLowerCase() == 'roses')
						PlayState.SONG.player1 += "-angry";
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "spirit":
					if (PlayState.SONG.player2 == 'spirit')
						PlayState.SONG = Song.loadFromJson("swap" + PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter == 'spirit' || lastCharacter == 'bf-pixel'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, bsidecrap + "tutorial");
					PlayState.SONG.player1 = "spirit";
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
				case "bf-pixel":
					if (PlayState.SONG.player2 == 'bf-pixel')
						PlayState.SONG = Song.loadFromJson("swap" + PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && (lastCharacter.startsWith("monster") || lastStage == "philly" || lastStage == "tank" || lastCharacter.startsWith("mom") || lastCharacter == 'bf-pixel'))
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, bsidecrap + PlayState.SONG.song.toLowerCase());
					else if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, bsidecrap + "tutorial");
					PlayState.SONG.player1 = "bf-pixel";
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
					LoadingState.loadAndSwitchState(new PlayState());
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
