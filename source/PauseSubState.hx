package;

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

using StringTools;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Toggle One Shot Mode', 'Toggle Practice Mode', 'Change Character', 'Exit to menu'];
	var originalmenuItems:Array<String> = [];
	
	var curSelected:Int = 0;
	var modeText:FlxText;
	

	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		if (!PlayState.isStoryMode)
		{
			menuItems.remove("Skip Song");
		}

		originalmenuItems = menuItems;

		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

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

		var bpmlevelInfo:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		bpmlevelInfo.text += "BPM:" + PlayState.SONG.bpm;
		bpmlevelInfo.scrollFactor.set();
		bpmlevelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		bpmlevelInfo.updateHitbox();
		add(bpmlevelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var deathMenuCounter:FlxText = new FlxText(20, 15 + 96, 0, "", 32);
		deathMenuCounter.text = "Blue balled: " + PlayState.deathCounter;
		deathMenuCounter.scrollFactor.set();
		deathMenuCounter.setFormat(Paths.font('vcr.ttf'), 32);
		deathMenuCounter.updateHitbox();
		add(deathMenuCounter);

		// I KNOW HOW TO SPELL PRACTICE
		modeText = new FlxText(20, 15 + 128, 0, "", 32);
		modeText.scrollFactor.set();
		modeText.setFormat(Paths.font('vcr.ttf'), 32);
		modeText.updateHitbox();
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

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		bpmlevelInfo.alpha = 0;
		deathMenuCounter.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		bpmlevelInfo.x = FlxG.width - (bpmlevelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		deathMenuCounter.x = FlxG.width - (deathMenuCounter.width + 20);
		modeText.x = FlxG.width - (modeText.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(bpmlevelInfo, {alpha: 1, y: bpmlevelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(deathMenuCounter, {alpha: 1, y: deathMenuCounter.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});

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
			close();
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			var lastOpponent:String = PlayState.SONG.player2;
			var lastCharacter:String = PlayState.SONG.player1;
			var lastStage:String = PlayState.curStage;
			var difficulty:String = "";
			var gfVersion:String = "gf";
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
				case 'amogus':
					gfVersion = 'gf-amogus';
			}

			switch (daSelected)
			{
				case "BACK":
					menuItems = originalmenuItems;
					regenMenu();
					curSelected = 0;
				case "Skip Song":
					var difficulty = "";
					PlayState.deathCounter = 0;
					PlayState.storyPlaylist.remove(PlayState.storyPlaylist[0]);
					switch (PlayState.storyDifficulty)
					{
						case 0:
							difficulty = "-easy";
					
						case 2:
							difficulty = "-hard";
						
						case 3:
							difficulty = "-hardplus";
					}
					if (PlayState.storyPlaylist.length <= 0) 
					{
						FlxG.sound.playMusic(Paths.music('frogMenu'));
						FlxG.switchState(new StoryMenuState());
					}
					else
					{
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0].toLowerCase());
						if (!lastCharacter.startsWith("bf"))
							PlayState.SONG.player1 = lastCharacter;
						if (lastOpponent.startsWith("bf") && lastStage == "tank")
							PlayState.SONG = Song.loadFromJson("tank" + PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0].toLowerCase());
						if (lastOpponent.startsWith("bf") && lastStage == "philly")
							PlayState.SONG = Song.loadFromJson("play" + PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0].toLowerCase());
						LoadingState.loadAndSwitchState(new PlayState());
					}
				case "Resume":
					close();
				case "Restart Song":
					FlxG.resetState();
				case "Exit to menu":
					PlayState.deathCounter = 0;
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
					menuItems = CoolUtil.difficultyArray;
					if (!menuItems.contains("BACK"))
						menuItems.push("BACK");
					regenMenu();
					curSelected = 0;
				case "Change Character":
					menuItems = ['bf', 'amog us', 'tankman', 'pico', 'gf', 'BACK'];
					if (gfVersion != "gf-christmas" && gfVersion != "gf" && PlayState.SONG.player2 != "gf")
						menuItems.remove('gf');
					if (PlayState.SONG.song.toLowerCase() == "among us drip")
						menuItems.remove('bf');
					if (menuItems.contains(PlayState.SONG.player1))
						menuItems.remove(PlayState.SONG.player1);
					if (PlayState.SONG.player1 == 'bf-amogus' || PlayState.curStage.startsWith('school'))
						menuItems.remove('amog us');
					regenMenu();
					curSelected = 0;
				case "EASY" | "NORMAL" | "HARD" | "HARD PLUS":
					switch (daSelected)
					{
						case "EASY":
							difficulty = '-easy';						
						case "HARD":
							difficulty = '-hard';
						case "HARD PLUS":
							difficulty = '-hardplus';
					}

					PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					if (!lastCharacter.startsWith("bf"))
						PlayState.SONG.player1 = lastCharacter;
					if (lastOpponent.startsWith("bf") && lastStage == "tank")
						PlayState.SONG = Song.loadFromJson("tank" + PlayState.SONG.song.toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("gftutorial" + difficulty, "tutorial");
					if (lastOpponent.startsWith("bf") && lastStage == "philly")
						PlayState.SONG = Song.loadFromJson("play" + PlayState.SONG.song.toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = curSelected;
					LoadingState.loadAndSwitchState(new PlayState());
				case "tankman":
					if (PlayState.curStage == "school" || PlayState.curStage == "schoolEvil")
					{
						PlayState.SONG.player1 = "tankman-pixel";
					}
					else
					{
						PlayState.SONG.player1 = "tankman";
					}
					switch (PlayState.storyDifficulty)
					{
						case 0:
							difficulty = '-easy';						
						case 2:
							difficulty = '-hard';
						case 3:
							difficulty = '-hardplus';
					}
					if (PlayState.curStage == 'tank' && PlayState.SONG.song.toLowerCase() != "no among us")
						PlayState.SONG = Song.loadFromJson("tank" + PlayState.SONG.song.toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					LoadingState.loadAndSwitchState(new PlayState());
				case "bf":
					switch (PlayState.storyDifficulty)
					{
						case 0:
							difficulty = '-easy';						
						case 2:
							difficulty = '-hard';
						case 3:
							difficulty = '-hardplus';
					}
					var CurrentSong:SwagSong = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					if (lastOpponent.startsWith("bf") && lastStage == "tank")
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.replace("tank","").toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, "tutorial");
					if (lastOpponent.startsWith("bf") && lastStage == "philly")
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.replace("play","").toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					PlayState.SONG.player1 = CurrentSong.player1;
					LoadingState.loadAndSwitchState(new PlayState());
				case "pico":
					if (PlayState.curStage == "school" || PlayState.curStage == "schoolEvil")
					{
						PlayState.SONG.player1 = "pico-pixel";
					}
					else
					{
						PlayState.SONG.player1 = "pico";
					}
					switch (PlayState.storyDifficulty)
					{
						case 0:
							difficulty = '-easy';						
						case 2:
							difficulty = '-hard';
						case 3:
							difficulty = '-hardplus';
					}
					if (PlayState.curStage == 'philly')
						PlayState.SONG = Song.loadFromJson("play" + PlayState.SONG.song.toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					LoadingState.loadAndSwitchState(new PlayState());
				case "gf":
					PlayState.SONG.player1 = gfVersion;
					switch (PlayState.storyDifficulty)
					{
						case 0:
							difficulty = '-easy';						
						case 2:
							difficulty = '-hard';
						case 3:
							difficulty = '-hardplus';
					}
					if (PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("gftutorial" + difficulty, "tutorial");
					if (PlayState.curStage == "philly" && PlayState.SONG.player2 == 'bf')
						PlayState.SONG.player2 == 'pico';
					LoadingState.loadAndSwitchState(new PlayState());
				case "amog us":
					switch (PlayState.storyDifficulty)
					{
						case 0:
							difficulty = '-easy';						
						case 2:
							difficulty = '-hard';
						case 3:
							difficulty = '-hardplus';
					}
					if (lastOpponent.startsWith("bf") && lastStage == "tank")
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.replace("tank","").toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					if (lastOpponent.startsWith("bf") && PlayState.SONG.song.toLowerCase() == "tutorial")
						PlayState.SONG = Song.loadFromJson("tutorial" + difficulty, "tutorial");
					if (lastOpponent.startsWith("bf") && lastStage == "philly")
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.replace("play","").toLowerCase() + difficulty, PlayState.SONG.song.toLowerCase());
					PlayState.SONG.player1 = "bf-amogus";
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
