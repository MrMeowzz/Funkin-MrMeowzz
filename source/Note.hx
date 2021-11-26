package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var altNote:Bool = false;
	public var noteInfo:Int;
	public var noteType:String = 'normal';
	public var prevNote:Note;
	public var noteEffect:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteCreationType:String = 'normal', ?inChartEditor:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		if (sustainNote)
			noteType = noteCreationType;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var notestyle:String = PlayState.SONG.notestyle;
		if (FlxG.save.data.notestyle != 'default' && PlayState.SONG.notestyleOverride != true && !inChartEditor)
			notestyle = FlxG.save.data.notestyle;

		var daStage:String = PlayState.curStage;

			if (notestyle == 'pixel')
			{
				loadGraphic(Paths.image('noteStyles/arrows-pixels'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('noteStyles/arrowEnds-pixels'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				switch (noteCreationType)
				{
					case 'fire':
						loadGraphic(Paths.image('pixelUI/NOTE_fire-pixel'), true, 21, 31);

						if(!FlxG.save.data.downscroll){
							animation.add('blueScroll', [3, 4, 3, 5], 8);
							animation.add('greenScroll', [6, 7, 6, 8], 8);
						}
						else{
							animation.add('blueScroll', [6, 7, 6, 8], 8);
							animation.add('greenScroll', [3, 4, 3, 5], 8);
						}
						animation.add('redScroll', [9, 10, 9, 11], 8);					
						animation.add('purpleScroll', [0, 1 ,0, 2], 8);

						if(FlxG.save.data.downscroll)
							flipY = true;

						x -= 15;
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			}
			else
			{
				switch (notestyle)
				{
					case 'tabi':
						frames = Paths.getSparrowAtlas('noteStyles/Tabi');
					case 'kapi':
						frames = Paths.getSparrowAtlas('noteStyles/Kapi');
					case 'camellia':
						frames = Paths.getSparrowAtlas('noteStyles/Camellia');
					default:
						frames = Paths.getSparrowAtlas('NOTE_assets');
				}		

				animation.addByPrefix('greenScroll', 'green instance');
				animation.addByPrefix('redScroll', 'red instance');
				animation.addByPrefix('blueScroll', 'blue instance');
				animation.addByPrefix('purpleScroll', 'purple instance');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				switch (noteCreationType)
				{
					case 'halo':
						frames = Paths.getSparrowAtlas('noteTypes/NOTE_halo');
						animation.addByPrefix('greenScroll', 'Green Arrow');
						animation.addByPrefix('redScroll', 'Red Arrow');
						animation.addByPrefix('blueScroll', 'Blue Arrow');
						animation.addByPrefix('purpleScroll', 'Purple Arrow');
						x -= 165;
					case 'fire':
						frames = Paths.getSparrowAtlas('noteTypes/NOTE_fire');
						if(!FlxG.save.data.downscroll){
							animation.addByPrefix('blueScroll', 'blue fire');
							animation.addByPrefix('greenScroll', 'green fire');
						}
						else{
							animation.addByPrefix('greenScroll', 'blue fire');
							animation.addByPrefix('blueScroll', 'green fire');
						}
						animation.addByPrefix('redScroll', 'red fire');
						animation.addByPrefix('purpleScroll', 'purple fire');

						if(FlxG.save.data.downscroll)
							flipY = true;

						x -= 50;
					case 'poison':
						frames = Paths.getSparrowAtlas('noteTypes/BobNotes');

						animation.addByPrefix('greenScroll', 'vertedUp');
						animation.addByPrefix('redScroll', 'vertedRight');
						animation.addByPrefix('blueScroll', 'vertedDown');
						animation.addByPrefix('purpleScroll', 'vertedLeft');
					case 'poisonmusthit':
						frames = Paths.getSparrowAtlas('NOTE_assets');
						animation.addByPrefix('purpleholdend', 'poison hold end instance');
						animation.addByPrefix('greenholdend', 'poison hold end instance');
						animation.addByPrefix('redholdend', 'poison hold end instance');
						animation.addByPrefix('blueholdend', 'poison hold end instance');
						animation.addByPrefix('purplehold', 'poison hold piece instance');
						animation.addByPrefix('greenhold', 'poison hold piece instance');
						animation.addByPrefix('redhold', 'poison hold piece instance');
						animation.addByPrefix('bluehold', 'poison hold piece instance');
						if (!sustainNote)
						{
							frames = Paths.getSparrowAtlas('noteTypes/BobNotes');

							animation.addByPrefix('greenScroll', 'hitUp');
							animation.addByPrefix('redScroll', 'hitRight');
							animation.addByPrefix('blueScroll', 'hitDown');
							animation.addByPrefix('purpleScroll', 'hitLeft');
						}
					case 'warning':
						frames = Paths.getSparrowAtlas('NOTE_assets');
						animation.addByPrefix('purpleholdend', 'warning hold end instance');
						animation.addByPrefix('greenholdend', 'warning hold end instance');
						animation.addByPrefix('redholdend', 'warning hold end instance');
						animation.addByPrefix('blueholdend', 'warning hold end instance');
						animation.addByPrefix('purplehold', 'warning hold piece instance');
						animation.addByPrefix('greenhold', 'warning hold piece instance');
						animation.addByPrefix('redhold', 'warning hold piece instance');
						animation.addByPrefix('bluehold', 'warning hold piece instance');
					
						if (!sustainNote)
							loadGraphic(Paths.image('noteTypes/warningNote'));
					case 'stun':
						frames = Paths.getSparrowAtlas('NOTE_assets');
						animation.addByPrefix('purpleholdend', 'stun hold end instance');
						animation.addByPrefix('greenholdend', 'stun hold end instance');
						animation.addByPrefix('redholdend', 'stun hold end instance');
						animation.addByPrefix('blueholdend', 'stun hold end instance');
						animation.addByPrefix('purplehold', 'stun hold piece instance');
						animation.addByPrefix('greenhold', 'stun hold piece instance');
						animation.addByPrefix('redhold', 'stun hold piece instance');
						animation.addByPrefix('bluehold', 'stun hold piece instance');

						if (!sustainNote)
							loadGraphic(Paths.image('noteTypes/stunNote'));	
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
			}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		if (FlxG.save.data.downscroll && isSustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (notestyle == 'pixel')
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				var scrollspeed = PlayState.SONG.speed;
				if (FlxG.save.data.overridespeed)
					scrollspeed = FlxG.save.data.scrollspeed;

				prevNote.scale.y *= Conductor.stepCrochet / PlayState.songMultiplier / 100 * 1.5 * scrollspeed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress && !PlayState.botplay)
		{
			if (noteType == 'halo')
			{
				// these though, REALLY hard to hit.
				if (strumTime > Conductor.songPosition - (166 * 0.3)
					&& strumTime < Conductor.songPosition + (166 * 0.2)) // also they're almost impossible to hit late!
					canBeHit = true;
				else
					canBeHit = false;
			}
			else if (noteType == 'fire')
			{
				// make burning notes a lot harder to accidently hit because they're weirdchamp!
				if (strumTime > Conductor.songPosition - (166 * 0.6)
					&& strumTime < Conductor.songPosition + (166 * 0.4)) // also they're almost impossible to hit late!
					canBeHit = true;
				else
					canBeHit = false;
			}
			else if (prevNote.noteEffect && isSustainNote)
			{
				canBeHit = false;
				tooLate = true;
				noteEffect = true;
			}
			else
			{
				if (strumTime > Conductor.songPosition - 166
					&& strumTime < Conductor.songPosition + (166 * (isSustainNote || !FlxG.save.data.newhittimings ? 0.5 : 1))) // The * 0.5 is so that it's easier to hit them too late, instead of too early (the sustain note i think???????????)
					canBeHit = true;
				else
					canBeHit = false;
				if (strumTime < Conductor.songPosition - 166 * Conductor.timeScale && !wasGoodHit) //&& !FlxG.save.data.newhittimings)
					tooLate = true;
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
