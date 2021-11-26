package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public static var animationNotes:Array<Dynamic> = [];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;
		var bside:String = '';

		if (OG.BSIDE)
			bside = '/b-side';

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters' + bside + '/GF_assets');
				if (PlayState.SONG.song == 'Old Bopeebo')
					tex = Paths.getSparrowAtlas('characters/OLDGF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);
				animation.addByPrefix('singUPmiss', 'GF UpNote MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'GF DownNote MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'GF RightNote MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'GF leftnote MISS', 24, false);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset("singUPmiss", 0, 4);
				addOffset("singDOWNmiss", 0, -20);
				addOffset("singRIGHTmiss", 0, -19);
				addOffset("singLEFTmiss", 0, -20);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

				if (isPlayer)
				{	
					flipX = true;
					animation.addByPrefix('singLEFT', 'GF Right Note', 24, false);
					animation.addByPrefix('singRIGHT', 'GF left note', 24, false);
					addOffset("singRIGHT", 0, -19);
					addOffset("singLEFT", 0, -20);
				}
				else
				{
					animation.addByPrefix('singLEFT', 'GF left note', 24, false);
					animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
					addOffset("singRIGHT", 0, -20);
					addOffset("singLEFT", 0, -19);
				}
				
			case 'speakers':
				tex = Paths.getSparrowAtlas('characters/Speakers_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters' + bside + '/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

				if (isPlayer)
				{	
					flipX = true;
					animation.addByPrefix('singLEFT', 'GF Right Note', 24, false);
					animation.addByPrefix('singRIGHT', 'GF left note', 24, false);
					addOffset("singRIGHT", 0, -19);
					addOffset("singLEFT", 0, -20);
				}
				else
				{
					animation.addByPrefix('singLEFT', 'GF left note', 24, false);
					animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
					addOffset("singRIGHT", 0, -20);
					addOffset("singLEFT", 0, -19);
				}

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters' + bside + '/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters' + bside + '/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'gf-tankmen':
				tex = Paths.getSparrowAtlas('characters/gfTankmen');
				frames = tex;
				animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				addOffset('sad', -2, -21);

				playAnim('danceRight');

			case 'gf-amogus':
				tex = Paths.getSparrowAtlas('characters/gfAmogus');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters' + bside + '/DADDY_DEAREST');
				if (FlxG.save.data.cleanmode)
					tex = Paths.getSparrowAtlas('characters/DADDY_DEARESTCLEAN');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('singUPmiss', 'Dad SingNote UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Dad SingNote DOWN MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Dad SingNote LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Dad SingNote LEFT MISS', 24, false);

				addOffset('idle');
				if (isPlayer)
				{
					addOffset("singUP", -14, 52);
					addOffset("singRIGHT", -40, 12);
					addOffset("singLEFT", 40, 30);
					addOffset("singDOWN", 40, -30);
					addOffset("singUPmiss", -10, 45);
					addOffset("singLEFTmiss", -40, 10);
					addOffset("singDOWNmiss", 41, -36);
					addOffset("singRIGHTmiss", -35, 10);
				}
				else
				{
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singUPmiss", -10, 40);
					addOffset("singLEFTmiss", 0, 10);
					addOffset("singDOWNmiss", 11, -36);
					addOffset("singRIGHTmiss", -10, 10);
				}

				playAnim('idle');
			case 'amogusguy':
				tex = Paths.getSparrowAtlas('characters/amogusguy');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				if (isPlayer)
				{
					addOffset("singUP", -14, 52);
					addOffset("singRIGHT", -40, 12);
					addOffset("singLEFT", 40, 30);
					addOffset("singDOWN", 40, -30);
					addOffset("singUPmiss", -10, 45);
					addOffset("singLEFTmiss", -40, 10);
					addOffset("singDOWNmiss", 41, -36);
					addOffset("singRIGHTmiss", -35, 10);
				}
				else
				{
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
					addOffset("singUPmiss", -10, 40);
					addOffset("singLEFTmiss", 0, 10);
					addOffset("singDOWNmiss", 11, -36);
					addOffset("singRIGHTmiss", -10, 10);
				}

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters' + bside + '/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);
				animation.addByPrefix('singUPmiss', 'spooky UPNOTE MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'spooky DOWNnote MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'note singleft MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'spooky singright MISS', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				if (isPlayer)
				{
					addOffset("singUP", -50, 26);
					addOffset("singRIGHT", -100, -14);
					addOffset("singLEFT", -40, -10);
					addOffset("singDOWN", 30, -130);
					addOffset("singUPmiss", 0, 30);
					addOffset("singLEFTmiss", -20, -20);
					addOffset("singDOWNmiss", 0, -150);
					addOffset("singRIGHTmiss", 110, -10);
				}
				else
				{
					addOffset("singUP", -20, 26);
					addOffset("singRIGHT", -130, -14);
					addOffset("singLEFT", 130, -10);
					addOffset("singDOWN", -50, -130);
					addOffset("singUPmiss", 0, 30);
					addOffset("singLEFTmiss", 70, -20);
					addOffset("singDOWNmiss", 0, -150);
					addOffset("singRIGHTmiss", -80, -10);
				}

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters' + bside + '/Mom_Assets');
				if (FlxG.save.data.cleanmode)
					tex = Paths.getSparrowAtlas('characters/Mom_AssetsCLEAN');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				animation.addByPrefix('singUPmiss', "Mom UpPose MISS", 24, false);
				animation.addByPrefix('singDOWNmiss', "MOM DOWNPOSE MISS", 24, false);
				animation.addByPrefix('singLEFTmiss', 'Mom LeftPose MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Mom PoseLeft MISS', 24, false);

				addOffset('idle');
				addOffset("singUPmiss", 14, 71);
				addOffset("singRIGHTmiss", 10, -60);
				addOffset("singLEFTmiss", 250, -23);
				addOffset("singDOWNmiss", 20, -160);
				if (isPlayer)
				{
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);
				}
				else
				{
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);
				}

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters' + bside + '/momCar');
				if (FlxG.save.data.cleanmode)
					tex = Paths.getSparrowAtlas('characters/momCarCLEAN');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				animation.addByPrefix('singUPmiss', "Mom UpPose MISS", 24, false);
				animation.addByPrefix('singDOWNmiss', "MOM DOWNPOSE MISS", 24, false);
				animation.addByPrefix('singLEFTmiss', 'Mom LeftPose MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Mom PoseLeft MISS', 24, false);

				addOffset('idle');
				addOffset("singUPmiss", 14, 71);
				addOffset("singRIGHTmiss", 10, -60);
				addOffset("singLEFTmiss", 250, -23);
				addOffset("singDOWNmiss", 20, -160);
				if (isPlayer)
				{
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);
				}
				else
				{
					addOffset("singUP", 14, 71);
					addOffset("singRIGHT", 10, -60);
					addOffset("singLEFT", 250, -23);
					addOffset("singDOWN", 20, -160);
				}

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters' + bside + '/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				animation.addByPrefix('singUPmiss', 'monster upnote MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'monsterdown MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Monster leftnote MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Monster Rightnote MISS', 24, false);

				animation.addByPrefix('hey', 'monster hey', 24, false);

				addOffset('idle');
				addOffset('hey');
				if (isPlayer)
				{
					addOffset("singUP", -40, 80);
					addOffset("singRIGHT", 23);
					addOffset("singLEFT", -41, 10);
					addOffset("singDOWN", 16, -85);
					addOffset("singUPmiss", -40, 80);
					addOffset("singRIGHTmiss", 23);
					addOffset("singLEFTmiss", -41, 10);
					addOffset("singDOWNmiss", 16, -85);
				}
				else
				{
					addOffset("singUP", -20, 94);
					addOffset("singRIGHT", -51, 30);
					addOffset("singLEFT", -30, 20);
					addOffset("singDOWN", -50, -80);
					addOffset("singUPmiss", -20, 100);
					addOffset("singRIGHTmiss", -43, 40);
					addOffset("singLEFTmiss", -41, 20);
					addOffset("singDOWNmiss", -59, -96);
				}
				
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters' + bside + '/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				animation.addByPrefix('singUPmiss', 'monster upnote MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'monsterdown MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Monster leftnote MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Monster Rightnote MISS', 24, false);

				addOffset('idle');
				if (isPlayer)
				{
					addOffset("singUP", -44, 53);
					addOffset("singRIGHT", 20, 5);
					addOffset("singLEFT", -51, 10);
					addOffset("singDOWN", 10, -94);
					addOffset("singUPmiss", -20, 100);
					addOffset("singRIGHTmiss", -40, 5);
					addOffset("singLEFTmiss", 30, -10);
					addOffset("singDOWNmiss", 0, -104);
				}
				else
				{
					addOffset("singUP", -20, 50);
					addOffset("singRIGHT", -51);
					addOffset("singLEFT", -30);
					addOffset("singDOWN", -40, -94);
					addOffset("singUPmiss", -34, 43);
					addOffset("singRIGHTmiss", -20, 5);
					addOffset("singLEFTmiss", -51, -10);
					addOffset("singDOWNmiss", -40, -94);
				}

				playAnim('idle');
			case 'tankmannoamongus':
				tex = Paths.getSparrowAtlas('characters/TankmanNoAmongUs');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('singUP-alt', 'Ugh', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Ugh', 24, false);

				addOffset('idle');

				if (isPlayer)
				{
					addOffset("singUP", 10, 30);
					addOffset("singRIGHT", -20, -20);
					addOffset("singLEFT", 59, -30);
					addOffset("singDOWN", 30, -114);
					addOffset("singUP-alt", 30, -20);
				}
				else
				{
					addOffset("singUP", 70, 30);
					addOffset("singRIGHT", 9, -30);
					addOffset("singLEFT", 110, -20);
					addOffset("singDOWN", 90, -114);
					addOffset("singUP-alt", 110, -20);
				}
				
				playAnim('idle');
			case 'tankman':
				tex = Paths.getSparrowAtlas('characters/tankmanCaptain');
				frames = tex;
				animation.addByPrefix('idle', 'Tankman Idle Dance ', 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note ', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note ', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note ', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left ', 24, false);
				
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH', 24, false);
				animation.addByPrefix('singLEFT-alt', 'TANKMAN UGH', 24, false);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD', 24, false);

				animation.addByPrefix('hey', 'TANKMAN UGH', 24, false);

				

				if (isPlayer)
				{
					addOffset("singUP", 24, 56);
					addOffset("singLEFT", 100, -14);
					addOffset("singRIGHT", -1, -7);
					addOffset("singDOWN", 98, -90);
					addOffset("singUP-alt", -11, -11);
					addOffset("hey", -11, -11);
					addOffset("singDOWN-alt", 100, 15);
				}
				else
				{
					addOffset("singUP", 57, 50);
					addOffset("singLEFT", 80, -14);
					addOffset("singRIGHT", -11, -27);
					addOffset("singDOWN", 78, -100);
					addOffset("singUP-alt", -18, -10);
					addOffset("hey", -18, -10);
					addOffset("singDOWN-alt", 0, 15);
				}


				addOffset('idle');

				
				
				playAnim('idle');

				updateHitbox();

				flipX = true;
			case 'pico':
				tex = Paths.getSparrowAtlas('characters' + bside + '/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				addOffset('idle');
				if (isPlayer)
				{
					addOffset("singUP", 16, 27);
					addOffset("singDOWN", 100, -70);
					addOffset("singRIGHT", 82, -4);
					addOffset("singLEFT", -52, 9);
					addOffset("singUPmiss", 21, 67);
					addOffset("singRIGHTmiss", 80, 30);
					addOffset("singLEFTmiss", -40, 50);
					addOffset("singDOWNmiss", 97, -30);
				}
				else
				{
					addOffset("singUP", -29, 27);
					addOffset("singDOWN", 200, -70);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singUPmiss", -9, 67);
					addOffset("singRIGHTmiss", -60, 30);
					addOffset("singLEFTmiss", 60, 50);
					addOffset("singDOWNmiss", 197, -35);
				}

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters' + bside + '/BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('hit', 'BF hit', 24, false);
				animation.addByPrefix('avoid', 'boyfriend dodge', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);
				addOffset('hit', 16, 19);

				if (!isPlayer && PlayState.SONG.song.toLowerCase() != "tutorial")
				{
					addOffset("singUP", 21, 27);
					addOffset("singRIGHT", -18, -6);
					addOffset("singLEFT", 42, -7);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", 11, 27);
					addOffset("singRIGHTmiss", -58, 24);
					addOffset("singLEFTmiss", 50, 21);
					addOffset("singDOWNmiss", -11, -19);
				}
				else
				{
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
				}

				playAnim('idle');

				flipX = true;

				if (PlayState.SONG.player1 == "gf" && PlayState.SONG.song.toLowerCase() == "tutorial")
					flipX = false;
			case 'bfclean':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIENDCLEAN');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				if (!isPlayer && PlayState.SONG.song.toLowerCase() != "tutorial")
				{
					addOffset("singUP", 21, 27);
					addOffset("singRIGHT", -18, -6);
					addOffset("singLEFT", 42, -7);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", 11, 27);
					addOffset("singRIGHTmiss", -58, 24);
					addOffset("singLEFTmiss", 50, 21);
					addOffset("singDOWNmiss", -11, -19);
				}
				else
				{
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
				}

				playAnim('idle');

				flipX = true;

				if (PlayState.SONG.player1 == "gf" && PlayState.SONG.song.toLowerCase() == "tutorial")
					flipX = false;
			case 'bf-amogus':
				var tex = Paths.getSparrowAtlas('characters/bfAmogus');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				
				if (!isPlayer)
				{
					addOffset("singUPmiss", 1, 27);
					addOffset("singRIGHTmiss", -38, 14);
					addOffset("singLEFTmiss", 20, 21);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", -3, 4);
					addOffset('scared', -4);
					addOffset("singUP", -9, 27);
					addOffset("singRIGHT", -28, -6);
					addOffset("singLEFT", 32, -7);
					addOffset("singDOWN", -40, -50);
				}
				else
				{
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('scared', -4);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
				}

				playAnim('idle');

				flipX = true;

			case 'bf-holding-gf':
				var tex = Paths.getSparrowAtlas('characters/bfAndGF');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance w gf', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				animation.addByPrefix('deathLoop', "BF idle dance w gf", 24, true);

				addOffset('idle');
				if (!isPlayer)
				{
					addOffset("singUP", 31, 10);
					addOffset("singRIGHT", -28, 7);
					addOffset("singLEFT", 9, 23);
					addOffset("singDOWN", 10, -10);
					addOffset("singUPmiss", 51, 10);
					addOffset("singRIGHTmiss", -28, 7);
					addOffset("singLEFTmiss", 29, 23);
					addOffset("singDOWNmiss", -30, -10);
				}
				else
				{
					addOffset("singUP", -29, 10);
					addOffset("singRIGHT", -41, 23);
					addOffset("singLEFT", 12, 7);
					addOffset("singDOWN", -10, -10);
					addOffset("singUPmiss", -29, 10);
					addOffset("singRIGHTmiss", -41, 23);
					addOffset("singLEFTmiss", 12, 7);
					addOffset("singDOWNmiss", -10, -10);
				}

				playAnim('idle');

				flipX = true;

			case 'pico-speaker':
				var tex = Paths.getSparrowAtlas('characters/picoSpeaker');
				frames = tex;
				animation.addByPrefix('shoot1', 'Pico shoot 1', 24, false);
				animation.addByPrefix('shoot2', 'Pico shoot 2', 24, false);
				animation.addByPrefix('shoot3', 'Pico shoot 3', 24, false);
				animation.addByPrefix('shoot4', 'Pico shoot 4', 24, false);

				addOffset('shoot1');
				addOffset("shoot2", -1, -128);
				addOffset("shoot3", 412, -64);


				addOffset("shoot4", 439, -19);

				playAnim('shoot1');
				loadMappedAnims();

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters' + bside + '/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('deathLoop', "BF idle dance", 24, true);

				addOffset('idle', -5);
				addOffset("hey", -3, 4);
				if (isPlayer)
				{
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
				}
				else
				{
					addOffset("singUP", 1, 27);
					addOffset("singRIGHT", -38, -6);
					addOffset("singLEFT", 32, -7);
					addOffset("singDOWN", -20, -50);
					addOffset("singUPmiss", 11, 27);
					addOffset("singRIGHTmiss", -58, 24);
					addOffset("singLEFTmiss", 50, 21);
					addOffset("singDOWNmiss", -11, -19);
				}

				playAnim('idle');

				flipX = true;

			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters' + bside + '/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				animation.addByPrefix('deathLoop', "BF idle dance", 24, true);

				addOffset('idle', -5);
				if (isPlayer)
				{
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
				}
				else
				{
					addOffset("singUP", 21, 27);
					addOffset("singRIGHT", -18, -6);
					addOffset("singLEFT", 42, -7);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", 11, 27);
					addOffset("singRIGHTmiss", -58, 24);
					addOffset("singLEFTmiss", 50, 21);
					addOffset("singDOWNmiss", -11, -19);
				}
				playAnim('idle');

				flipX = true;

			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters' + bside + '/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				animation.addByPrefix('deathLoop', "BF IDLE", 24, true);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'pico-pixel':
				frames = Paths.getSparrowAtlas('characters/picoPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				animation.addByPrefix('deathLoop', "BF IDLE", 24, true);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'tankman-pixel':
				frames = Paths.getSparrowAtlas('characters/tankmanPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				animation.addByPrefix('deathLoop', "BF IDLE", 24, true);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'tankman-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/tankmanPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters' + bside + '/bfPixelsDEAD');
				if (FlxG.save.data.cleanmode)
					frames = Paths.getSparrowAtlas('characters/bfPixelsDEADCLEAN');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'pico-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/picoPixelsDEAD');
				if (FlxG.save.data.cleanmode)
					frames = Paths.getSparrowAtlas('characters/picoPixelsDEADCLEAN');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD');
				animation.addByPrefix('singUP', "BF Dies with GF", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies with GF", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY confirm holding gf", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath', 37, 14);
				addOffset('deathLoop', 37, -3);
				addOffset('deathConfirm', 37, 28);
				updateHitbox();
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters' + bside + '/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'SENPAI UPNOTE MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Senpai LEFTNOTE MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Senpai RIGHTNOTE MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'SENPAI DOWNNOTE MISS', 24, false);

				addOffset('idle');
				addOffset("singUPmiss", 5, 37);
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss", 4);
				if (isPlayer)
				{
					addOffset("singUP", 5, 37);
					addOffset("singRIGHT");
					addOffset("singLEFT");
					addOffset("singDOWN", 4);
				}
				else
				{
					addOffset("singUP", 5, 37);
					addOffset("singRIGHT");
					addOffset("singLEFT", 40);
					addOffset("singDOWN", 14);
				}

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters' + bside + '/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'ANGRY SEnpai UPNOTE MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'ANGRY SeNPai LEFTNOTE MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'ANGRY SeNpai RIGHTNOTE MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'ANGRY SenPai DOWNNOTE MISS', 24, false);

				addOffset('idle');
				addOffset("singUPmiss", 5, 37);
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss", 4);
				if (isPlayer)
				{
					addOffset("singUP", 5, 37);
					addOffset("singRIGHT");
					addOffset("singLEFT");
					addOffset("singDOWN", 4);
				}
				else
				{
					addOffset("singUP", 5, 37);
					addOffset("singRIGHT");
					addOffset("singLEFT", 40);
					addOffset("singDOWN", 14);
				}
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters' + bside + '/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);
				animation.addByPrefix('singUPmiss', "missup_", 24, false);
				animation.addByPrefix('singRIGHTmiss', "missright_", 24, false);
				animation.addByPrefix('singLEFTmiss', "missleft_", 24, false);
				animation.addByPrefix('singDOWNmiss', "missdown_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);
				addOffset('singUPmiss', -220, -240);
				addOffset("singRIGHTmiss", -220, -280);
				addOffset("singLEFTmiss", -200, -280);
				addOffset("singDOWNmiss", -220, -280);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				tex = Paths.getSparrowAtlas('characters' + bside + '/mom_dad_christmas_assets');
				if (FlxG.save.data.cleanmode)
					tex = Paths.getSparrowAtlas('characters/mom_dad_christmas_assetsCLEAN');
				frames = tex;
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				animation.addByPrefix('singUPmiss', 'Parent Up Note MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Parent Down Note MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Parent Left Note MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Parent Right Note MISS', 24, false);
				animation.addByPrefix('singUPmiss-alt', 'Parent Up Note MISS', 24, false);
				animation.addByPrefix('singDOWNmiss-alt', 'Parent Down Note MISS', 24, false);
				animation.addByPrefix('singLEFTmiss-alt', 'Parent Left Note MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss-alt', 'Parent Right Note MISS', 24, false);

				addOffset('idle');
				//warning offset overload
				if (isPlayer)
				{
					addOffset("singUP", -37, 24);
					addOffset("singRIGHT", -61, 17);
					addOffset("singLEFT", 80, -24);
					addOffset("singDOWN", -11, -19);
					addOffset("singUP-alt", -37, 24);
					addOffset("singRIGHT-alt", -61, 16);
					addOffset("singLEFT-alt", 80, -25);
					addOffset("singDOWN-alt", -12, -17);
					addOffset("singUPmiss", -34, 26);
					addOffset("singLEFTmiss", 70, -24);
					addOffset("singDOWNmiss", 0, -40);
					addOffset("singRIGHTmiss", -74, 18);
					addOffset("singUPmiss-alt", -34, 26);
					addOffset("singLEFTmiss-alt", 70, -24);
					addOffset("singDOWNmiss-alt", 0, -40);
					addOffset("singRIGHTmiss-alt", -74, 18);
				}
				else
				{
					addOffset("singUP", -47, 24);
					addOffset("singRIGHT", -1, -23);
					addOffset("singLEFT", -30, 16);
					addOffset("singDOWN", -31, -29);
					addOffset("singUP-alt", -47, 24);
					addOffset("singRIGHT-alt", -1, -24);
					addOffset("singLEFT-alt", -30, 15);
					addOffset("singDOWN-alt", -30, -27);
					addOffset("singUPmiss", -64, 26);
					addOffset("singLEFTmiss", -40, 16);
					addOffset("singDOWNmiss", -40, -40);
					addOffset("singRIGHTmiss", -4, -32);
					addOffset("singUPmiss-alt", -64, 26);
					addOffset("singLEFTmiss-alt", -40, 16);
					addOffset("singDOWNmiss-alt", -40, -40);
					addOffset("singRIGHTmiss-alt", -4, -32);
				}

				playAnim('idle');
		}

		dance();

		if (isPlayer || (curCharacter.startsWith('bf') && !isPlayer && PlayState.SONG.song.toLowerCase() != "tutorial"))
		{
			if (isPlayer)
				flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place??? (unless enemy)
			// Doesn't flip for dead people lol
			if ((!curCharacter.startsWith('bf') || !isPlayer) && !curCharacter.endsWith('dead') && curCharacter != "pico")
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	function loadMappedAnims()
	{
		animationNotes = [];
		for (anim in Song.loadFromJson('picospeaker', 'stress').notes) 
    	{
			for (note in anim.sectionNotes) 
        	{
				animationNotes.push(note);
	   		}
	    	animationNotes.sort(sortAnims);
		}
	}

	function sortAnims(a, b) 
    {
		var aThing = a[0];
		var bThing = b[0];
		return aThing < bThing ? -1 : 1;
	}
	

	override function update(elapsed:Float)
	{
		if (!isPlayer && PlayState.swappedsides)
		{
			if (animation.curAnim.name.startsWith('sing'))
				holdTimer += elapsed;
			else
				holdTimer = 0;

			if (PlayState.curPlayer.color != FlxColor.WHITE && animation.curAnim.finished && !debugMode)
			{
				PlayState.curPlayer.color = FlxColor.WHITE;
				playAnim('idle', true, false, 10);
				if (PlayState.curPlayer.curCharacter.startsWith('gf') || PlayState.curPlayer.curCharacter.startsWith('spooky'))
					PlayState.curPlayer.dance();
			}

			if (animation.curAnim.name.endsWith('alt') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, false, 10);
			}

			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, false, 10);
				if (PlayState.curPlayer.curCharacter.startsWith('gf') || PlayState.curPlayer.curCharacter.startsWith('spooky'))
					PlayState.curPlayer.dance();
			}
		}
		if ((!isPlayer && !PlayState.swappedsides) || (isPlayer && PlayState.swappedsides))
		{
			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
			case 'pico-speaker':
				if (0 < animationNotes.length && Conductor.songPosition > animationNotes[0][0]) 
				{
					var shootnum = 1;
					if (2 <= animationNotes[0][1]) {
						shootnum = 3;				
					}

					shootnum += FlxG.random.int(0, 1);
					playAnim("shoot" + shootnum, true);
					animationNotes.shift();
				}
				if (animation.curAnim != null && animation.curAnim.finished)
				{
					playAnim(animation.curAnim.name, false, false, animation.curAnim.frames.length - 3);
				}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'gf-tankmen' | 'gf-amogus':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'pico-speaker':
					// do nothing, only here so it doesn't play idle animation
				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				case 'tankman':
					if (!animation.curAnim.name.endsWith('DOWN-alt'))
						playAnim('idle');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
		//since im not changing all of the framerates manually
		if (animation.curAnim.frameRate == 24 && !animation.curAnim.name.toLowerCase().contains('death'))
			animation.curAnim.frameRate = Std.int(24 * PlayState.songMultiplier);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
