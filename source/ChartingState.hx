package;

import Conductor.BPMChangeEvent;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;
import lime.app.Application;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class ChartingState extends MusicBeatState
{
	var _file:FileReference;

	var UI_box:FlxUITabMenu;

	/**
	 * Array of notes showing when each section STARTS in STEPS
	 * Usually rounded up??
	 */
	var curSection:Int = 0;

	public static var lastSection:Int = 0;

	var bpmTxt:FlxText;

	var strumLine:FlxSprite;
	var curSong:String = 'Dadbattle';
	var amountSteps:Int = 0;
	var bullshitUI:FlxGroup;

	var highlight:FlxSprite;

	var GRID_SIZE:Int = 40;

	var dummyArrow:FlxSprite;

	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;

	var gridBG:FlxSprite;

	var _song:SwagSong;

	var typingShit:FlxInputText;
	/*
	 * WILL BE THE CURRENT / LAST PLACED NOTE
	**/
	var curSelectedNote:Array<Dynamic>;

	var tempBpm:Int = 0;

	var vocals:FlxSound;

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;
	var gfIcon:HealthIcon;

	var hitsounds:Array<Note> = [];

	var playHitsounds:Bool = true;

	var HitsoundsPlayer:Int = 0;

	var notetypeDropDown:FlxUIDropDownMenu;
	var notetypeDropDownPixel:FlxUIDropDownMenu;

	var stepperRate:FlxUINumericStepper;

	var notePlacedType:String = 'normal';

	public var rate:Float = 1.0;

	override function create()
	{
		curSection = lastSection;

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);
		add(gridBG);

		leftIcon = new HealthIcon('bf');
		rightIcon = new HealthIcon('dad');
		gfIcon = new HealthIcon('gf');
		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);
		gfIcon.scrollFactor.set(1, 1);

		leftIcon.setGraphicSize(0, 45);
		rightIcon.setGraphicSize(0, 45);
		gfIcon.setGraphicSize(0, 45);

		add(leftIcon);
		add(rightIcon);
		add(gfIcon);

		leftIcon.setPosition(0, -100);
		rightIcon.setPosition(gridBG.width / 2, -100);
		gfIcon.setPosition(gridBG.width / 4, -150);

		var gridBlackLine:FlxSprite = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();

		if (PlayState.SONG != null)
			_song = PlayState.SONG;
		else
		{
			_song = {
				song: 'Test',
				stage: 'stage',
				notes: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				gf: 'gf',
				player2badnotes: false,
				speed: 1,
				notestyle: 'normal',
				notestyleOverride: false,
				validScore: false
			};
		}

		FlxG.mouse.visible = true;
		FlxG.save.bind('funkin', 'Mr Meowzz');

		tempBpm = Std.int(_song.bpm);

		addSection();

		// sections = _song.notes;

		updateGrid();

		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		bpmTxt = new FlxText(1000, 50, 0, "", 16);
		bpmTxt.scrollFactor.set();
		add(bpmTxt);

		strumLine = new FlxSprite(0, 50).makeGraphic(Std.int(FlxG.width / 2), 4);
		add(strumLine);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		var tabs = [
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Note", label: 'Note'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2;
		UI_box.y = 20;
		add(UI_box);

		addSongUI();
		addSectionUI();
		addNoteUI();

		add(curRenderedNotes);
		add(curRenderedSustains);

		updateSectionUI();
		updateHeads();

		FlxG.camera.zoom = 1.5;
		FlxG.camera.x = FlxG.width * -1;

		if (FlxG.save.data.menutransitions)
			FlxTween.tween(FlxG.camera, { zoom: 1, x: 0}, 1, {ease: FlxEase.quadIn });

		super.create();
	}

	function addSongUI():Void
	{
		var UI_songTitle = new FlxUIInputText(10, 10, 70, _song.song, 8);
		typingShit = UI_songTitle;

		var check_voices = new FlxUICheckBox(10, 25, null, null, "Has voice track", 100);
		check_voices.checked = _song.needsVoices;
		// _song.needsVoices = check_voices.checked;
		check_voices.callback = function()
		{
			_song.needsVoices = check_voices.checked;
			trace('CHECKED!');
		};

		var check_mute_inst = new FlxUICheckBox(10, 200, null, null, "Mute Instrumental (in editor)", 100);
		check_mute_inst.checked = false;
		check_mute_inst.callback = function()
		{
			var vol:Float = 1;

			if (check_mute_inst.checked)
				vol = 0;

			FlxG.sound.music.volume = vol;
		};

		var check_mute_voices = new FlxUICheckBox(10, 225, null, null, "Mute Voices (in editor)", 100);
		check_mute_voices.checked = false;
		check_mute_voices.callback = function()
		{
			var vol:Float = 1;

			if (check_mute_voices.checked)
				vol = 0;

			vocals.volume = vol;
		};

		var check_hitsounds = new FlxUICheckBox(125, 200, null, null, "Play hitsounds (in editor)", 100);
		check_hitsounds.checked = true;
		check_hitsounds.callback = function()
		{
			playHitsounds = check_hitsounds.checked;
		};

		var hitsoundsPlayerDropDown = new FlxUIDropDownMenu(125, 225, FlxUIDropDownMenu.makeStrIdLabelArray(["both", "player1", "player2"], true), function(player:String)
		{
			HitsoundsPlayer = Std.parseInt(player);
		});
		hitsoundsPlayerDropDown.selectedLabel = "both";

		var stages:Array<String> = CoolUtil.coolTextFile(Paths.txt('stages'));

		var stageDropDown = new FlxUIDropDownMenu(125, 350, FlxUIDropDownMenu.makeStrIdLabelArray(stages, true), function(stage:String)
		{
			_song.stage = stages[Std.parseInt(stage)];
		});
		stageDropDown.selectedLabel = _song.stage;

		var stageTxt:FlxText = new FlxText(stageDropDown.x, stageDropDown.y - 25, 0, "Stage");

		var saveButton:FlxButton = new FlxButton(110, 8, "Save", function()
		{
			saveLevel();
		});

		var reloadSong:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Reload Audio", function()
		{
			loadSong(_song.song);
		});

		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, saveButton.y + 30, "Reload JSON", function()
		{
			var difficulty:String = '';
			switch (PlayState.storyDifficulty)
			{
				case 0:
					difficulty = '-easy';
				case 2:
					difficulty = '-hard';
				case 3:
					difficulty = '-hardplus';
			}
			loadJson(_song.song.toLowerCase(), difficulty);
		});

		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'load autosave', loadAutosave);

		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(10, 75, 0.1, 1, 0.1, 10, 1);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(10, 65, 1, 1, 1, 339, 0);
		stepperBPM.value = Conductor.bpm / PlayState.songMultiplier;
		stepperBPM.name = 'song_bpm';

		var stepperSpeedTxt:FlxText = new FlxText(stepperSpeed.x + 75, stepperSpeed.y, 0, "Song Speed");
		var stepperBPMTxt:FlxText = new FlxText(stepperBPM.x + 75, stepperBPM.y, 0, "Song BPM");

		var characters:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
		var gfs:Array<String> = CoolUtil.coolTextFile(Paths.txt('gfList'));

		var player1DropDown = new FlxUIDropDownMenu(10, 125, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player1 = characters[Std.parseInt(character)];
			updateHeads();
		});
		player1DropDown.selectedLabel = _song.player1;

		var player2DropDown = new FlxUIDropDownMenu(140, 125, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player2 = characters[Std.parseInt(character)];
			updateHeads();
		});

		player2DropDown.selectedLabel = _song.player2;

		var gfDropDown = new FlxUIDropDownMenu(10, 275, FlxUIDropDownMenu.makeStrIdLabelArray(gfs, true), function(gf:String)
		{
			_song.gf = gfs[Std.parseInt(gf)];
			updateHeads();
		});
		gfDropDown.selectedLabel = _song.gf;

		var Player1Txt:FlxText = new FlxText(player1DropDown.x, player1DropDown.y - 25, 0, "Player 1");

		var Player2Txt:FlxText = new FlxText(player2DropDown.x, player2DropDown.y - 25, 0, "Player 2");

		var gfTxt:FlxText = new FlxText(gfDropDown.x, gfDropDown.y - 25, 0, "Gf");

		var check_player2hitsbadnotes = new FlxUICheckBox(Player2Txt.x + 50, Player2Txt.y, null, null, "Hit Bad Notes", 100);
		check_player2hitsbadnotes.checked = _song.player2badnotes;
		check_player2hitsbadnotes.callback = function()
		{
			_song.player2badnotes = check_player2hitsbadnotes.checked;
		};

		var switchingDifficultytxt:String = '';

		var difficultyarray:Array<String> = CoolUtil.difficultyArray.copy();
		if (OG.BSIDE)
		{
			difficultyarray = CoolUtil.bsidedifficultyArray.copy();
		}

		var difficultyDropDown = new FlxUIDropDownMenu(270, 125, FlxUIDropDownMenu.makeStrIdLabelArray(difficultyarray, true), function(difficulty:String)
		{
			switch (Std.parseInt(difficulty))
			{
				case 0:
					switchingDifficultytxt = '-easy';
				case 2:
					switchingDifficultytxt = '-hard';
				case 3:
					switchingDifficultytxt = '-hardplus';
			}

			PlayState.storyDifficulty = Std.parseInt(difficulty);
		});

		difficultyDropDown.selectedLabel = CoolUtil.difficultyString();

		var difficultyTxt:FlxText = new FlxText(difficultyDropDown.x + 10, difficultyDropDown.y - 25, 0, "Difficulty");

		var noteStyles:Array<String> = CoolUtil.coolTextFile(Paths.txt('noteStyles'));

		var notestyleDropDown = new FlxUIDropDownMenu(270, 250, FlxUIDropDownMenu.makeStrIdLabelArray(noteStyles, true), function(style:String)
		{
			_song.notestyle = noteStyles[Std.parseInt(style)];
			PlayState.SONG.notestyle = noteStyles[Std.parseInt(style)];
			if (_song.notestyle == 'pixel')
				notePlacedType = notetypeDropDownPixel.selectedLabel;
			else
				notePlacedType = notetypeDropDown.selectedLabel;

			updateGrid();
		});

		notestyleDropDown.selectedLabel = _song.notestyle;

		var check_notestyleOverride:FlxUICheckBox = new FlxUICheckBox(400, 250, null, null, "Override User Notestyle", 100);
		check_notestyleOverride.checked = _song.notestyleOverride;
		check_notestyleOverride.callback = function()
		{
			_song.notestyleOverride = check_notestyleOverride.checked;
		};

		var notestyleTxt:FlxText = new FlxText(notestyleDropDown.x, notestyleDropDown.y - 25, 0, "Note Style");

		var tab_group_song = new FlxUI(null, UI_box);
		tab_group_song.name = "Song";
		tab_group_song.add(UI_songTitle);

		tab_group_song.add(check_voices);
		tab_group_song.add(check_mute_inst);
		tab_group_song.add(check_mute_voices);
		tab_group_song.add(check_hitsounds);
		tab_group_song.add(saveButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);
		tab_group_song.add(stepperBPM);
		tab_group_song.add(stepperSpeed);
		tab_group_song.add(gfDropDown);
		tab_group_song.add(gfTxt);
		tab_group_song.add(hitsoundsPlayerDropDown);
		tab_group_song.add(stageDropDown);
		tab_group_song.add(stageTxt);
		tab_group_song.add(player1DropDown);
		tab_group_song.add(player2DropDown);
		tab_group_song.add(check_player2hitsbadnotes);
		tab_group_song.add(difficultyDropDown);
		tab_group_song.add(difficultyTxt);
		tab_group_song.add(Player2Txt);
		tab_group_song.add(Player1Txt);
		tab_group_song.add(stepperBPMTxt);
		tab_group_song.add(stepperSpeedTxt);
		tab_group_song.add(notestyleDropDown);
		tab_group_song.add(notestyleTxt);
		tab_group_song.add(check_notestyleOverride);

		UI_box.addGroup(tab_group_song);
		UI_box.scrollFactor.set();

		FlxG.camera.follow(strumLine);
	}

	var stepperLength:FlxUINumericStepper;
	var check_mustHitSection:FlxUICheckBox;
	var check_changeBPM:FlxUICheckBox;
	var stepperSectionBPM:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;
	var altAnimPlayerDropDown:FlxUIDropDownMenu;

	function addSectionUI():Void
	{
		var tab_group_section = new FlxUI(null, UI_box);
		tab_group_section.name = 'Section';

		stepperLength = new FlxUINumericStepper(10, 10, 4, 0, 0, 999, 0);
		stepperLength.value = _song.notes[curSection].lengthInSteps;
		stepperLength.name = "section_length";

		var stepperLengthTxt:FlxText = new FlxText(stepperLength.x + 75, stepperLength.y, 0, "Section Length");

		stepperSectionBPM = new FlxUINumericStepper(10, 75, 1, Conductor.bpm, 0, 999, 0);
		stepperSectionBPM.value = Conductor.bpm;
		stepperSectionBPM.name = 'section_bpm';

		var stepperSectionBPMTxt:FlxText = new FlxText(stepperSectionBPM.x + 75, stepperSectionBPM.y, 0, "Section BPM");

		var stepperCopy:FlxUINumericStepper = new FlxUINumericStepper(110, 130, 1, 1, -999, 999, 0);

		var stepperCopyTxt:FlxText = new FlxText(stepperCopy.x + 75, stepperCopy.y, 0, "Section to Copy");

		var copyButton:FlxButton = new FlxButton(10, 130, "Copy last section", function()
		{
			copySection(Std.int(stepperCopy.value));
		});

		var clearSectionButton:FlxButton = new FlxButton(10, 150, "Clear", clearSection);

		var swapSection:FlxButton = new FlxButton(10, 170, "Swap section", function()
		{
			for (i in 0..._song.notes[curSection].sectionNotes.length)
			{
				var note = _song.notes[curSection].sectionNotes[i];
				note[1] = (note[1] + 4) % 8;
				_song.notes[curSection].sectionNotes[i] = note;
				updateGrid();
			}
		});

		check_mustHitSection = new FlxUICheckBox(10, 30, null, null, "Must hit section", 100);
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = true;
		// _song.needsVoices = check_mustHit.checked;

		check_altAnim = new FlxUICheckBox(10, 400, null, null, "Alt Animation", 100);
		check_altAnim.name = 'check_altAnim';

		check_changeBPM = new FlxUICheckBox(10, 60, null, null, 'Change BPM', 100);
		check_changeBPM.name = 'check_changeBPM';

		altAnimPlayerDropDown = new FlxUIDropDownMenu(130, 400, FlxUIDropDownMenu.makeStrIdLabelArray(["both", "player1", "player2"], true), function(player:String)
		{
			_song.notes[curSection].altAnimPlayer = Std.parseInt(player);
		});


		var notetypes:Array<String> = CoolUtil.coolTextFile(Paths.txt('noteTypeList'));
		var notetypespixel:Array<String> = CoolUtil.coolTextFile(Paths.txt('noteTypeList-pixel'));
		notetypeDropDown = new FlxUIDropDownMenu(10, 30, FlxUIDropDownMenu.makeStrIdLabelArray(notetypes, true), function(type:String)
		{
			notePlacedType = notetypes[Std.parseInt(type)];
			updateNoteUI();
			updateGrid();
		});
		notetypeDropDownPixel = new FlxUIDropDownMenu(10, 30, FlxUIDropDownMenu.makeStrIdLabelArray(notetypespixel, true), function(type:String)
		{
			notePlacedType = notetypespixel[Std.parseInt(type)];
			updateNoteUI();
			updateGrid();
		});
		if (FlxG.save.data.fpscounter)
		{
			notetypeDropDown.y += 25;
			notetypeDropDownPixel.y += 25;
		}
		var notetypeTxt:FlxText = new FlxText(notetypeDropDown.x, notetypeDropDown.y - 25, 0, "Note Type");

		notetypeDropDown.selectedLabel = 'normal';
		notetypeDropDownPixel.selectedLabel = 'normal';

		notetypeDropDown.scrollFactor.set();
		notetypeDropDownPixel.scrollFactor.set();
		notetypeTxt.scrollFactor.set();

		stepperRate = new FlxUINumericStepper(135, 35, 0.05, 1, 0.5, 3, 2);
		stepperRate.name = 'song_rate';
		stepperRate.value = PlayState.songMultiplier;
		rate = PlayState.songMultiplier;
		var stepperRateTxt:FlxText = new FlxText(stepperRate.x, stepperRate.y - 25, 0, "Rate");
		stepperRate.scrollFactor.set();
		stepperRateTxt.scrollFactor.set();

		add(notetypeTxt);
		#if desktop
		add(stepperRateTxt);
		#end
		updateGrid();

		tab_group_section.add(stepperLength);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(check_mustHitSection);
		tab_group_section.add(check_altAnim);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearSectionButton);
		tab_group_section.add(swapSection);
		tab_group_section.add(altAnimPlayerDropDown);
		tab_group_section.add(stepperLengthTxt);
		tab_group_section.add(stepperSectionBPMTxt);
		tab_group_section.add(stepperCopyTxt);

		UI_box.addGroup(tab_group_section);
	}

	var stepperSusLength:FlxUINumericStepper;
	var check_altnote:FlxUICheckBox;

	function addNoteUI():Void
	{
		var tab_group_note = new FlxUI(null, UI_box);
		tab_group_note.name = 'Note';

		stepperSusLength = new FlxUINumericStepper(10, 10, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * 16);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';

		var stepperSusTxt:FlxText = new FlxText(stepperSusLength.x + 75, stepperSusLength.y, 0, "Note Length");

		check_altnote = new FlxUICheckBox(10, 30, null, null, "Alt note", 100);
		check_altnote.name = 'altnote';
		check_altnote.checked = false;

		tab_group_note.add(stepperSusLength);
		tab_group_note.add(check_altnote);
		tab_group_note.add(stepperSusTxt);

		UI_box.addGroup(tab_group_note);
	}

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
			// vocals.stop();
		}
		
		if (OG.BSIDE)
		{
			FlxG.sound.playMusic(Paths.bsideinst(daSong), 0.6);
		}
		else
		{
			if (FlxG.save.data.cleanmode && (daSong == 'no among us' || daSong == 'h.e. no among us'))
				FlxG.sound.playMusic(Paths.cleaninst(daSong), 0.6);
			else
				FlxG.sound.playMusic(Paths.inst(daSong), 0.6);
		}

		// WONT WORK FOR TUTORIAL OR TEST SONG!!! REDO LATER
		vocals = new FlxSound().loadEmbedded(Paths.voices(daSong));
		if (OG.BSIDE)
		{
			vocals = new FlxSound().loadEmbedded(Paths.bsidevoices(daSong));
		}
		FlxG.sound.list.add(vocals);

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.onComplete = function()
		{
			vocals.pause();
			vocals.time = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
			changeSection();
		};
	}

	function generateUI():Void
	{
		while (bullshitUI.members.length > 0)
		{
			bullshitUI.remove(bullshitUI.members[0], true);
		}

		// general shit
		var title:FlxText = new FlxText(UI_box.x + 20, UI_box.y + 20, 0);
		bullshitUI.add(title);
		/* 
			var loopCheck = new FlxUICheckBox(UI_box.x + 10, UI_box.y + 50, null, null, "Loops", 100, ['loop check']);
			loopCheck.checked = curNoteSelected.doesLoop;
			tooltips.add(loopCheck, {title: 'Section looping', body: "Whether or not it's a simon says style section", style: tooltipType});
			bullshitUI.add(loopCheck);

		 */
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUICheckBox.CLICK_EVENT)
		{
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;
			switch (label)
			{
				case 'Must hit section':
					_song.notes[curSection].mustHitSection = check.checked;

					updateHeads();

				case 'Change BPM':
					_song.notes[curSection].changeBPM = check.checked;
					FlxG.log.add('changed bpm shit');
				case "Alt Animation":
					_song.notes[curSection].altAnim = check.checked;
					if (_song.notes[curSection].altAnimPlayer == null && check.checked == true)
					{
						_song.notes[curSection].altAnimPlayer = Std.parseInt(altAnimPlayerDropDown.selectedId);
					}
				
				case "Alt note":
					if (curSelectedNote != null)
						curSelectedNote[3] = check.checked;
					else
						check.checked = !check.checked;
			}
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			FlxG.log.add(wname);
			if (wname == 'section_length')
			{
				_song.notes[curSection].lengthInSteps = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_speed')
			{
				_song.speed = nums.value;
			}
			else if (wname == 'song_bpm')
			{
				tempBpm = Std.int(nums.value);
				Conductor.mapBPMChanges(_song);
				Conductor.changeBPM(Std.int(nums.value));
			}
			else if (wname == 'note_susLength')
			{
				if (curSelectedNote != null && (curSelectedNote[4] == 'normal' || curSelectedNote[4] == 'poisonmusthit' || curSelectedNote[4] == 'warning' || curSelectedNote[4] == 'stun' || curSelectedNote[4] == null))
				{
					curSelectedNote[2] = nums.value;
					updateGrid();
				}
				else
					stepperSusLength.value = 0;
			}
			else if (wname == 'section_bpm')
			{
				_song.notes[curSection].bpm = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_rate')
			{
				rate = nums.value;
			}
		}

		// FlxG.log.add(id + " WEED " + sender + " WEED " + data + " WEED " + params);
	}

	var updatedSection:Bool = false;

	/* this function got owned LOL
		function lengthBpmBullshit():Float
		{
			if (_song.notes[curSection].changeBPM)
				return _song.notes[curSection].lengthInSteps * (_song.notes[curSection].bpm / _song.bpm);
			else
				return _song.notes[curSection].lengthInSteps;
	}*/
	function sectionStartTime():Float
	{
		var daBPM:Int = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSection)
		{
			if (_song.notes[i].changeBPM)
			{
				daBPM = _song.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	override function update(elapsed:Float)
	{
		curStep = recalculateSteps();

		Conductor.songPosition = FlxG.sound.music.time;
		_song.song = typingShit.text;

		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps));

		if (playHitsounds)
		{
			curRenderedNotes.forEach(function(note:Note)
			{
				if (FlxG.sound.music.playing)
				{
					if (strumLine.overlaps(note))
					{
						if (!hitsounds.contains(note) && note.noteType != "fire" && note.noteType != "halo" && note.noteType != "poison")
						{
							if ((note.noteInfo < 4 && (HitsoundsPlayer == 1 || HitsoundsPlayer == 0) && _song.notes[curSection].mustHitSection) || (note.noteInfo > 3 && (HitsoundsPlayer == 1 || HitsoundsPlayer == 0) && !_song.notes[curSection].mustHitSection))
							{
								hitsounds.push(note);
								FlxG.sound.play(Paths.sound('hitsound'));
							}
							if ((note.noteInfo > 3 && (HitsoundsPlayer == 2 || HitsoundsPlayer == 0) && _song.notes[curSection].mustHitSection) || (note.noteInfo < 4 && (HitsoundsPlayer == 2 || HitsoundsPlayer == 0) && !_song.notes[curSection].mustHitSection))
							{
								hitsounds.push(note);
								FlxG.sound.play(Paths.sound('enemyhitsound'));
							}
						}
					}
				}
			});
		}
		#if desktop
		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.playing)
			{
				@:privateAccess
				{
					lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, rate);
					try
					{
						if (vocals != null && vocals.length / 2 > 0)
						{
							lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, rate);
						}
					}
					catch(e)
					{
						trace("failed to pitch vocals");
					}
			
				}	
			}
		}
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.endTime = FlxG.sound.music.length / 2;
		#end

		if (curBeat % 4 == 0 && curStep >= 16 * (curSection + 1))
		{
			trace(curStep);
			trace((_song.notes[curSection].lengthInSteps) * (curSection + 1));
			trace('DUMBSHIT');

			if (_song.notes[curSection + 1] == null)
			{
				addSection();
			}

			changeSection(curSection + 1, false);
		}

		FlxG.watch.addQuick('daBeat', curBeat);
		FlxG.watch.addQuick('daStep', curStep);

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(curRenderedNotes))
			{
				curRenderedNotes.forEach(function(note:Note)
				{
					if (FlxG.mouse.overlaps(note))
					{
						if (FlxG.keys.pressed.CONTROL)
						{
							selectNote(note);
						}
						else
						{
							trace('tryin to delete note...');
							deleteNote(note);
						}
					}
				});
			}
			else
			{
				if (FlxG.mouse.x > gridBG.x
					&& FlxG.mouse.x < gridBG.x + gridBG.width
					&& FlxG.mouse.y > gridBG.y
					&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
				{
					FlxG.log.add('added note');
					addNote();
				}
			}
		}

		if (FlxG.mouse.x > gridBG.x
			&& FlxG.mouse.x < gridBG.x + gridBG.width
			&& FlxG.mouse.y > gridBG.y
			&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
		{
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;
			if (FlxG.keys.pressed.SHIFT)
				dummyArrow.y = FlxG.mouse.y;
			else
				dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			lastSection = curSection;

			PlayState.SONG = _song;
			FlxG.sound.music.stop();
			vocals.stop();

			if (FlxG.save.data.menutransitions)
				FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width}, 1, {ease: FlxEase.quadIn });
			PlayState.songMultiplier = stepperRate.value;
			FlxG.switchState(new PlayState());
		}

		if (controls.BACK && !typingShit.hasFocus)
		{
			OG.currentCutsceneEnded = false;
			FlxG.switchState(new MainMenuState());
			FlxG.sound.music.stop();
			vocals.stop();
			if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
				FlxG.sound.playMusic(Paths.music('frogMenuSPOOKY'));
			else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
				FlxG.sound.playMusic(Paths.music('frogMenuFESTIVE'));
			else
				FlxG.sound.playMusic(Paths.music('frogMenuRemix'));
			FlxG.sound.music.time = 10448;
			if (FlxG.save.data.menutransitions)
			{
				FlxTween.tween(FlxG.camera, { zoom: 0.1 }, 1, { ease: FlxEase.quadIn });
				MainMenuState.transition = 'zoom';
			}
			PlayState.songMultiplier = stepperRate.value;
		}

		if (FlxG.keys.justPressed.E && !typingShit.hasFocus)
		{
			changeNoteSustain(Conductor.stepCrochet);
		}
		if (FlxG.keys.justPressed.Q && !typingShit.hasFocus)
		{
			changeNoteSustain(-Conductor.stepCrochet);
		}

		if (FlxG.keys.justPressed.TAB)
		{
			if (FlxG.keys.pressed.SHIFT)
			{
				UI_box.selected_tab -= 1;
				if (UI_box.selected_tab < 0)
					UI_box.selected_tab = 2;
			}
			else
			{
				UI_box.selected_tab += 1;
				if (UI_box.selected_tab >= 3)
					UI_box.selected_tab = 0;
			}
		}

		if (!typingShit.hasFocus)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				if (FlxG.sound.music.playing)
				{
					FlxG.sound.music.pause();
					vocals.pause();
					hitsounds.splice(0, hitsounds.length);
				}
				else
				{
					vocals.play();
					FlxG.sound.music.play();
				}
			}

			if (FlxG.keys.justPressed.R)
			{
				if (FlxG.keys.pressed.SHIFT)
					resetSection(true);
				else
					resetSection();
			}

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				hitsounds.splice(0, hitsounds.length);

				FlxG.sound.music.time -= (FlxG.mouse.wheel * Conductor.stepCrochet * 0.4);
				vocals.time = FlxG.sound.music.time;
			}

			if (!FlxG.keys.pressed.SHIFT)
			{
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = 700 * FlxG.elapsed;

					if (FlxG.keys.pressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
			else
			{
				if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();
					hitsounds.splice(0, hitsounds.length);

					var daTime:Float = Conductor.stepCrochet * 2;

					if (FlxG.keys.justPressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
		}

		_song.bpm = tempBpm;

		/* if (FlxG.keys.justPressed.UP)
				Conductor.changeBPM(Conductor.bpm + 1);
			if (FlxG.keys.justPressed.DOWN)
				Conductor.changeBPM(Conductor.bpm - 1); */

		var shiftThing:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftThing = 4;
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
			changeSection(curSection + shiftThing);
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
			changeSection(curSection - shiftThing);

		bpmTxt.text = bpmTxt.text = Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2))
			+ " / "
			#if desktop
			+ Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 2 / 1000, 2))
			#else
			+ Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2))
			#end
			+ "\nSection: "
			+ curSection
			+ "\nCurStep: "
			+ curStep
			+ "\nCurBeat: "
			+ curBeat
			+ "\nDifficulty: "
			+ CoolUtil.difficultyString()
			+ "\nRate: "
			+ rate
			+ "\n\n\nMr Meowzz's FNF\nChart Editor\nv" 
			+ Application.current.meta.get('version');


		super.update(elapsed);
	}

	function changeNoteSustain(value:Float):Void
	{
		if (curSelectedNote != null && (curSelectedNote[4] == 'normal' || curSelectedNote[4] == 'poisonmusthit' || curSelectedNote[4] == 'warning' || curSelectedNote[4] == 'stun' || curSelectedNote[4] == null))
		{
			if (curSelectedNote[2] != null)
			{
				curSelectedNote[2] += value;
				curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
			}
		}

		updateNoteUI();
		updateGrid();
	}

	function recalculateSteps():Int
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (FlxG.sound.music.time > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((FlxG.sound.music.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();

		return curStep;
	}

	function resetSection(songBeginning:Bool = false):Void
	{
		updateGrid();

		FlxG.sound.music.pause();
		vocals.pause();

		// Basically old shit from changeSection???
		FlxG.sound.music.time = sectionStartTime();

		if (songBeginning)
		{
			FlxG.sound.music.time = 0;
			curSection = 0;
		}

		vocals.time = FlxG.sound.music.time;
		updateCurStep();

		updateGrid();
		updateSectionUI();
	}

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void
	{
		trace('changing section' + sec);

		if (_song.notes[sec] != null)
		{
			curSection = sec;

			updateGrid();

			if (updateMusic)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				/*var daNum:Int = 0;
					var daLength:Float = 0;
					while (daNum <= sec)
					{
						daLength += lengthBpmBullshit();
						daNum++;
				}*/

				FlxG.sound.music.time = sectionStartTime();
				vocals.time = FlxG.sound.music.time;
				updateCurStep();
			}

			updateGrid();
			updateSectionUI();
		}
	}

	function copySection(?sectionNum:Int = 1)
	{
		var daSec = FlxMath.maxInt(curSection, sectionNum);

		for (note in _song.notes[daSec - sectionNum].sectionNotes)
		{
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);

			var copiedNote:Array<Dynamic> = [strum, note[1], note[2]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}

		updateGrid();
	}

	function updateSectionUI():Void
	{
		var sec = _song.notes[curSection];

		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_altAnim.checked = sec.altAnim;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;
		altAnimPlayerDropDown.selectedId = Std.string(sec.altAnimPlayer);

		updateHeads();
	}

	function updateHeads():Void
	{
		if (check_mustHitSection.checked)
		{
			leftIcon.animation.play(_song.player1);
			rightIcon.animation.play(_song.player2);
		}
		else
		{
			leftIcon.animation.play(_song.player2);
			rightIcon.animation.play(_song.player1);
		}
		gfIcon.animation.play(_song.gf);
	}

	function updateNoteUI():Void
	{
		if (curSelectedNote != null)
		{
			if (curSelectedNote[2] != null)
				stepperSusLength.value = curSelectedNote[2];
			if (curSelectedNote[3] != null)
				check_altnote.checked = curSelectedNote[3];
		}
	}

	function updateGrid():Void
	{
		while (curRenderedNotes.members.length > 0)
		{
			curRenderedNotes.remove(curRenderedNotes.members[0], true);
		}

		while (curRenderedSustains.members.length > 0)
		{
			curRenderedSustains.remove(curRenderedSustains.members[0], true);
		}

		var sectionInfo:Array<Dynamic> = _song.notes[curSection].sectionNotes;

		if (_song.notes[curSection].changeBPM && _song.notes[curSection].bpm > 0)
		{
			Conductor.changeBPM(_song.notes[curSection].bpm);
			FlxG.log.add('CHANGED BPM!');
		}
		else
		{
			// get last bpm
			var daBPM:Int = _song.bpm;
			for (i in 0...curSection)
				if (_song.notes[i].changeBPM)
					daBPM = _song.notes[i].bpm;
			Conductor.changeBPM(daBPM);
		}

		/* // PORT BULLSHIT, INCASE THERE'S NO SUSTAIN DATA FOR A NOTE
			for (sec in 0..._song.notes.length)
			{
				for (notesse in 0..._song.notes[sec].sectionNotes.length)
				{
					if (_song.notes[sec].sectionNotes[notesse][2] == null)
					{
						trace('SUS NULL');
						_song.notes[sec].sectionNotes[notesse][2] = 0;
					}
				}
			}
		 */
		remove(notetypeDropDown);
		remove(notetypeDropDownPixel);
		 if (_song.notestyle == 'pixel')
		 {
			add(notetypeDropDownPixel);
		 }
		 else
		 {
			 add(notetypeDropDown);
		 }
		 #if desktop
		 add(stepperRate);
		 #end

		for (i in sectionInfo)
		{
			var daNoteInfo = i[1];
			var daStrumTime = i[0];
			var daSus = i[2];
			var daAltnote = i[3];
			var daNotetype = i[4];
			var note:Note = new Note(daStrumTime, daNoteInfo % 4, null, false, daNotetype, true);
			note.sustainLength = daSus;
			note.altNote = daAltnote;
			note.noteType = daNotetype;
			note.noteInfo = daNoteInfo;
			note.setGraphicSize(GRID_SIZE, GRID_SIZE);
			note.updateHitbox();
			note.x = Math.floor(daNoteInfo * GRID_SIZE);
			note.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));

			if (!CoolUtil.coolTextFile(Paths.txt('noteTypeList-pixel')).contains(daNotetype) && daNotetype != null && _song.notestyle == 'pixel')
			{
				daNotetype = 'normal';
			}
			if (daNotetype == 'fire')
			{
				if (_song.notestyle != 'pixel')
				{
					note.setGraphicSize(GRID_SIZE * 2, GRID_SIZE * 4);
					if (FlxG.save.data.downscroll)
						note.offset.y += 30;
					else
						note.offset.y -= 30;
				}
				else
				{
					note.setGraphicSize(GRID_SIZE, GRID_SIZE * 2);
					if (FlxG.save.data.downscroll)
						note.offset.y += 10;
					else
						note.offset.y -= 10;				
				}	
			}
			if (daNotetype == 'halo')
			{
				note.setGraphicSize(GRID_SIZE * 4, GRID_SIZE * 2);
				note.offset.y += 20;
			}
			if (daNotetype == 'poisonmusthit')
			{
				note.setGraphicSize(GRID_SIZE, GRID_SIZE + 10);
				note.updateHitbox();
			}
			if (daNotetype == 'poison')
			{
				note.setGraphicSize(GRID_SIZE, GRID_SIZE + 5);
				note.updateHitbox();
			}

			curRenderedNotes.add(note);

			if (daSus > 0)
			{
				var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2),
					note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * 16, 0, gridBG.height)));
				curRenderedSustains.add(sustainVis);
			}
		}
	}

	private function addSection(lengthInSteps:Int = 16):Void
	{
		var sec:SwagSection = {
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: true,
			sectionNotes: [],
			typeOfSection: 0,
			altAnim: false,
			altAnimPlayer: 3
		};

		_song.notes.push(sec);
	}

	function selectNote(note:Note):Void
	{
		var swagNum:Int = 0;

		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i.strumTime == note.strumTime && i.noteData % 4 == note.noteData && i.noteType == note.noteType)
			{
				curSelectedNote = _song.notes[curSection].sectionNotes[swagNum];
			}

			swagNum += 1;
		}

		updateGrid();
		updateNoteUI();
	}

	function deleteNote(note:Note):Void
	{
		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i[0] == note.strumTime && i[1] % 4 == note.noteData && i[4] == note.noteType)
			{
				FlxG.log.add('FOUND EVIL NUMBER');
				_song.notes[curSection].sectionNotes.remove(i);
			}
		}

		updateGrid();
	}

	function clearSection():Void
	{
		_song.notes[curSection].sectionNotes = [];

		updateGrid();
	}

	function clearSong():Void
	{
		for (daSection in 0..._song.notes.length)
		{
			_song.notes[daSection].sectionNotes = [];
		}

		updateGrid();
	}

	private function addNote():Void
	{
		var noteStrum = getStrumTime(dummyArrow.y) + sectionStartTime();
		var noteData = Math.floor(FlxG.mouse.x / GRID_SIZE);
		var noteSus = 0;

		_song.notes[curSection].sectionNotes.push([noteStrum, noteData, noteSus]);

		curSelectedNote = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];

		if (FlxG.keys.pressed.CONTROL)
		{
			_song.notes[curSection].sectionNotes.push([noteStrum, (noteData + 4) % 8, noteSus]);
		}

		trace('placed note type: ' + notePlacedType);
		curSelectedNote[4] = notePlacedType;

		trace(noteStrum);
		trace(curSection);

		updateGrid();
		updateNoteUI();

		autosaveSong();
	}

	function getStrumTime(yPos:Float):Float
	{
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}

	function getYfromStrum(strumTime:Float):Float
	{
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}

	/*
		function calculateSectionLengths(?sec:SwagSection):Int
		{
			var daLength:Int = 0;

			for (i in _song.notes)
			{
				var swagLength = i.lengthInSteps;

				if (i.typeOfSection == Section.COPYCAT)
					swagLength * 2;

				daLength += swagLength;

				if (sec != null && sec == i)
				{
					trace('swag loop??');
					break;
				}
			}

			return daLength;
	}*/
	private var daSpacing:Float = 0.3;

	function loadLevel():Void
	{
		trace(_song.notes);
	}

	function getNotes():Array<Dynamic>
	{
		var noteData:Array<Dynamic> = [];

		for (i in _song.notes)
		{
			noteData.push(i.sectionNotes);
		}

		return noteData;
	}

	function loadJson(song:String, difficulty:String):Void
	{
		var folder = song.toLowerCase();
		PlayState.SONG = Song.loadFromJson(song.toLowerCase() + difficulty, folder);
		FlxG.resetState();
	}

	function loadAutosave():Void
	{
		PlayState.SONG = Song.parseJSONshit(FlxG.save.data.autosave);
		FlxG.resetState();
	}

	function autosaveSong():Void
	{
		FlxG.save.data.autosave = Json.stringify({
			"generatedBy": "Mr Meowzz's FNF Chart Editor v" + Application.current.meta.get('version'),
			"song": _song
		});
		FlxG.save.flush();
	}

	private function saveLevel()
	{
		var json = {
			"generatedBy": "Mr Meowzz's FNF Chart Editor v" + Application.current.meta.get('version'),
			"song": _song
		};

		var data:String = Json.stringify(json);

		var Difficultytxt:String = ''; 

		switch (PlayState.storyDifficulty)
		{
			case 0:
				Difficultytxt = '-easy';
			case 2:
				Difficultytxt = '-hard';
			case 3:
				Difficultytxt = '-hardplus';
		}

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), _song.song.toLowerCase() + Difficultytxt + ".json");
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}
}
