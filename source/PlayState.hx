package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxAngle;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.Lib;
import lime.app.Application;
import flixel.util.FlxAxes;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var deathCounter:Int = 0;
	public static var praticemode:Bool = false;
	public static var oneshot:Bool = false;
	public static var botplay:Bool = false;
	public static var gainmultiplier:Float = 1;
	public static var losemultiplier:Float = 1;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;
	private var tankmansoundthing:FlxSound;

	public static var dad:Character;
	private var gf:Character;
	public static var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var player2Strums:FlxTypedGroup<FlxSprite>;

	private var strumming2:Array<Bool> = [false, false, false, false];
	private var strumming1:Array<Bool> = [false, false, false, false];

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var goodnotes:Float = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var FULLhealthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	private var WasHUDVisible:Bool = true;
	private var wasNOTEHUDVisible:Bool = true;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var pauseCam:FlxCamera;
	private var camHUD:FlxCamera;
	private var ScoreTxtCam:FlxCamera;
	private var ShitsTxtCam:FlxCamera;
	private var BadsTxtCam:FlxCamera;
	private var GoodsTxtCam:FlxCamera;
	private var SicksTxtCam:FlxCamera;
	private var RatingTxtCam:FlxCamera;
	private var AccuracyTxtCam:FlxCamera;
	private var MissesTxtCam:FlxCamera;
	private var HealthTxtCam:FlxCamera;
	private var camGame:FlxCamera;
	private var noteCam:FlxCamera;
	private var ratingCam:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var tank5:FlxSprite;
	var tank4:FlxSprite;
	var tank3:FlxSprite;
	var tank2:FlxSprite;
	var tank1:FlxSprite;
	var tank0:FlxSprite;
	var tank:FlxSprite;
	var runningtank:FlxSprite;
	var tankground:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public static var songScore:Int = 0;
	var lerpScore:Int = 0;
	var songTxt:FlxText;
	public static var accuracyTxt:FlxText;
	public static var ratingTxt:FlxText;
	var scoreTxt:FlxText;
	public static var healthTxt:FlxText;
	var missesTxt:FlxText;
	var lengthTxt:FlxText;
	var modeTxt:FlxText;
	var sickstxt:FlxText;
	var goodstxt:FlxText;
	var badstxt:FlxText;
	var shitstxt:FlxText;

	public static var lengthBG:FlxSprite;
	public static var lengthBar:FlxBar;
	var songName:FlxText;
	private var curSongPos:Float = 0;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	var grpPixelNoteSplashes:FlxTypedGroup<PixelNoteSplash>;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;
	
	public static var storyDifficultyText:String = "";
	var songLength:Float = 0;
	
	#if desktop
	// Discord RPC variables
	public static var player1RPC:String = "";
	public static var player2RPC:String = "";
	var detailsText:String = "";
	public static var detailsPausedText:String = "";
	public static var modeText:String = "";
	#end

	public var timer:FlxTimer;

	var runningTankSpeed:Array<Float> = [];
	var tankGoingRight:Array<Bool> = [];
	var tankStrumTime:Array<Dynamic> = [];
	var endingOffset:Array<Float> = [];
	var runningtanks:FlxTypedGroup<FlxSprite>;

	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var lastBeatHit:Int = 0;

	var pressedreset:Bool = false;

	public static var swappedsides:Bool = false;
	public static var curPlayer:Character = boyfriend;
	public static var curEnemy:Character = dad;

	var notestyle:String;

	override public function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		previousRate = songMultiplier - 0.05;

		if (previousRate < 1.00)
			previousRate = 1;

		timer = new FlxTimer();
		misses = 0;
		goodnotes = 0;
		songScore = 0;
		gainmultiplier = 1;
		losemultiplier = 1;
		sicks = 0;
		goods = 0;
		bads = 0;
		shits = 0;

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		pauseCam = new FlxCamera();
		pauseCam.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		createTxtCams();
		noteCam = new FlxCamera();
		noteCam.bgColor.alpha = 0;
		ratingCam = new FlxCamera();
		ratingCam.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(noteCam);
		FlxG.cameras.add(ratingCam);
		FlxG.cameras.add(ScoreTxtCam);
		FlxG.cameras.add(ShitsTxtCam);
		FlxG.cameras.add(BadsTxtCam);
		FlxG.cameras.add(GoodsTxtCam);
		FlxG.cameras.add(SicksTxtCam);
		FlxG.cameras.add(RatingTxtCam);
		FlxG.cameras.add(AccuracyTxtCam);
		FlxG.cameras.add(MissesTxtCam);
		FlxG.cameras.add(HealthTxtCam);
		FlxG.cameras.add(pauseCam);
		#if (haxe >= "4.9.0")
		FlxG.cameras.setDefaultDrawTarget(camGame, false);
		#else
		FlxCamera.defaultCameras = [camGame];
		#end
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');
		notestyle = SONG.notestyle;
		if (FlxG.save.data.notestyle != 'default' && SONG.notestyleOverride != true)
			notestyle = FlxG.save.data.notestyle;
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		var splash = new NoteSplash(100, 100, 0);
		splash.alpha = 0.1;
		grpNoteSplashes.add(splash);
		grpPixelNoteSplashes = new FlxTypedGroup<PixelNoteSplash>();
		var splashpixel = new PixelNoteSplash(100, 100, 0);
		splashpixel.alpha = 0.1;
		grpPixelNoteSplashes.add(splashpixel);

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		var clean:String = '';

		if (FlxG.save.data.cleanmode)
			clean = 'CLEAN';

		switch (SONG.song.toLowerCase())
		{
			case 'senpai' | 'thorns':
				if (OG.BSIDE)
					dialogue = CoolUtil.coolTextFile(Paths.txt('b-side/' + SONG.song.toLowerCase() + '/Dialogue'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/Dialogue'));
			case 'roses':
				if (OG.BSIDE)
					dialogue = CoolUtil.coolTextFile(Paths.txt('b-side/' + SONG.song.toLowerCase() + '/Dialogue'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/Dialogue' + clean));
			case 'tutorial' | 'bopeebo' | 'fresh' | 'dadbattle' | 'spookeez' | 'south' | 'monster' | 'pico' | 'philly' | 'satin-pants'| 'satin-panties' | 'high' | 'milf' | 'mom' | 'cocoa' | 'eggnog' | 'winter-horrorland': //list every song in weeks 0-5 ._.
				dialogue = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/Dialogue'));
			case 'blammed':
				dialogue = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/Dialogue' + clean));
		}

		if (storyDifficulty == 3)
		{
			if (SONG.song.toLowerCase() != 'ugh')
			{
				gainmultiplier = 0.5;
				losemultiplier = 2;
			}
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		if (OG.BSIDE)
		{
			switch (storyDifficulty)
			{
				case 0:
					storyDifficultyText = "Easier";
				case 1:
					storyDifficultyText = "Standard";
				case 2:
					storyDifficultyText = "Flip";
				case 3:
					storyDifficultyText = "Flip Plus";
			}
		}
		else
		{
			switch (storyDifficulty)
			{
				case 0:
					storyDifficultyText = "Easy";
				case 1:
					storyDifficultyText = "Normal";
				case 2:
					storyDifficultyText = "Hard";
				case 3:
					storyDifficultyText = "Hard Plus";
			}
		}

		player1RPC = SONG.player1;

		switch (player1RPC)
		{
			case 'mom-car':
				player1RPC = 'mom';
			case 'bf-car':
				player1RPC = 'bf';
		}

		player2RPC = SONG.player2;

		switch (player2RPC)
		{
			case 'mom-car':
				player2RPC = 'mom';
			case 'bf-car':
				player2RPC = 'bf';
		}

		if (OG.BSIDE)
		{
			player1RPC += '-bside';
			player2RPC += '-bside';
		}
		
		var bsidepresence:String = '';
		if (OG.BSIDE)
			bsidepresence = ' B-SIDE';
		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			var weektxt:String = "Week " + Std.string(storyWeek);
			if (storyWeek == 0)
				weektxt = 'tutorial';
			if (storyWeek == 8)
				weektxt = 'Week meme';
			detailsText = "in Story Mode" + bsidepresence + ": " + weektxt;
		}
		else
		{
			detailsText = "in Freeplay" + bsidepresence;
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + modeText + ")", player2RPC, player1RPC);
		#end

		curStage = SONG.stage;

		switch (curStage)
		{
                case 'spooky': 
                {
	              halloweenLevel = true;

		            var hallowTex = Paths.getSparrowAtlas('stages/spooky/halloween_bg');

	                halloweenBG = new FlxSprite(-200, -100);
		            halloweenBG.frames = hallowTex;
	                halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	                halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', Std.int(24 * songMultiplier), false);
	                halloweenBG.animation.play('idle');
	                halloweenBG.antialiasing = true;
	                add(halloweenBG);

		            isHalloween = true;
		          }
		          case 'philly': 
                  {

		            var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('stages/philly/sky'));
		            bg.scrollFactor.set(0.1, 0.1);
		            add(bg);

	                var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('stages/philly/city'));
		            city.scrollFactor.set(0.3, 0.3);
		            city.setGraphicSize(Std.int(city.width * 0.85));
		            city.updateHitbox();
		            add(city);

		            phillyCityLights = new FlxTypedGroup<FlxSprite>();
		            add(phillyCityLights);

		            for (i in 0...5)
		            {
		            var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('stages/philly/win' + i));
		            light.scrollFactor.set(0.3, 0.3);
		            light.visible = false;
		            light.setGraphicSize(Std.int(light.width * 0.85));
		            light.updateHitbox();
		            light.antialiasing = true;
		            phillyCityLights.add(light);
		            }

		            var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('stages/philly/behindTrain'));
		            add(streetBehind);

	         	    phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('stages/philly/train'));
		            add(phillyTrain);

		            trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
		            FlxG.sound.list.add(trainSound);

		            // var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

		            var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('stages/philly/street'));
	                add(street);
		          }
		          case 'limo':
		          {
		                  defaultCamZoom = 0.90;

		                  var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('stages/limo/limoSunset'));
		                  skyBG.scrollFactor.set(0.1, 0.1);
		                  add(skyBG);

		                  var bgLimo:FlxSprite = new FlxSprite(-200, 480);
		                  bgLimo.frames = Paths.getSparrowAtlas('stages/limo/bgLimo');
		                  bgLimo.animation.addByPrefix('drive', "background limo pink", Std.int(24 * songMultiplier));
		                  bgLimo.animation.play('drive');
		                  bgLimo.scrollFactor.set(0.4, 0.4);
		                  add(bgLimo);

		                  grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
		                  add(grpLimoDancers);

		                  for (i in 0...5)
		                  {
		                          var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
		                          dancer.scrollFactor.set(0.4, 0.4);
		                          grpLimoDancers.add(dancer);
		                  }

		                  var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('stages/limo/limoOverlay'));
		                  overlayShit.alpha = 0.5;
		                  // add(overlayShit);

		                  // var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

		                  // FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

		                  // overlayShit.shader = shaderBullshit;

		                  var limoTex = Paths.getSparrowAtlas('stages/limo/limoDrive');

		                  limo = new FlxSprite(-120, 550);
		                  limo.frames = limoTex;
		                  limo.animation.addByPrefix('drive', "Limo stage", Std.int(24 * songMultiplier));
		                  limo.animation.play('drive');
		                  limo.antialiasing = true;

		                  fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('stages/limo/fastCarLol'));
		                  // add(limo);
		          }
		          case 'mall':
		          {

		                  defaultCamZoom = 0.80;
						  var bg:FlxSprite;
						  if (FlxG.save.data.cleanmode)
								bg = new FlxSprite(-1000, -500).loadGraphic(Paths.image('stages/mall/bgWallsCLEAN'));
						  	else
		                  		bg = new FlxSprite(-1000, -500).loadGraphic(Paths.image('stages/mall/bgWalls'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
		                  add(bg);

		                  upperBoppers = new FlxSprite(-240, -90);
		                  upperBoppers.frames = Paths.getSparrowAtlas('stages/mall/upperBop');
		                  upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", Std.int(24 * songMultiplier), false);
		                  upperBoppers.antialiasing = true;
		                  upperBoppers.scrollFactor.set(0.33, 0.33);
		                  upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
		                  upperBoppers.updateHitbox();
		                  add(upperBoppers);

		                  var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('stages/mall/bgEscalator'));
		                  bgEscalator.antialiasing = true;
		                  bgEscalator.scrollFactor.set(0.3, 0.3);
		                  bgEscalator.active = false;
		                  bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		                  bgEscalator.updateHitbox();
		                  add(bgEscalator);

		                  var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('stages/mall/christmasTree'));
		                  tree.antialiasing = true;
		                  tree.scrollFactor.set(0.40, 0.40);
		                  add(tree);

		                  bottomBoppers = new FlxSprite(-300, 140);
						  if (FlxG.save.data.cleanmode)
							bottomBoppers.frames = Paths.getSparrowAtlas('stages/mall/bottomBopCLEAN');
						  else
		                  	bottomBoppers.frames = Paths.getSparrowAtlas('stages/mall/bottomBop');
		                  bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', Std.int(24 * songMultiplier), false);
		                  bottomBoppers.antialiasing = true;
	                          bottomBoppers.scrollFactor.set(0.9, 0.9);
	                          bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
		                  bottomBoppers.updateHitbox();
		                  add(bottomBoppers);

		                  var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('stages/mall/fgSnow'));
		                  fgSnow.active = false;
		                  fgSnow.antialiasing = true;
		                  add(fgSnow);

		                  santa = new FlxSprite(-840, 150);
		                  santa.frames = Paths.getSparrowAtlas('stages/mall/santa');
		                  santa.animation.addByPrefix('idle', 'santa idle in fear', Std.int(24 * songMultiplier), false);
		                  santa.antialiasing = true;
		                  add(santa);
		          }
		          case 'mallEvil':
		          {
						  var bg:FlxSprite;
						  if (FlxG.save.data.cleanmode)
							bg = new FlxSprite(-400, -500).loadGraphic(Paths.image('stages/mallEvil/evilBGCLEAN'));
						  else
		                  	bg = new FlxSprite(-400, -500).loadGraphic(Paths.image('stages/mallEvil/evilBG'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
		                  add(bg);

		                  var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('stages/mallEvil/evilTree'));
		                  evilTree.antialiasing = true;
		                  evilTree.scrollFactor.set(0.2, 0.2);
		                  add(evilTree);

		                  var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("stages/mallEvil/evilSnow"));
	                          evilSnow.antialiasing = true;
		                  add(evilSnow);
                        }
		          case 'school':
		          {

		                  // defaultCamZoom = 0.9;

		                  var bgSky = new FlxSprite().loadGraphic(Paths.image('stages/school/weebSky'));
		                  bgSky.scrollFactor.set(0.1, 0.1);
		                  add(bgSky);

		                  var repositionShit = -200;

		                  var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('stages/school/weebSchool'));
		                  bgSchool.scrollFactor.set(0.6, 0.90);
		                  add(bgSchool);

		                  var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('stages/school/weebStreet'));
		                  bgStreet.scrollFactor.set(0.95, 0.95);
		                  add(bgStreet);

		                  var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('stages/school/weebTreesBack'));
		                  fgTrees.scrollFactor.set(0.9, 0.9);
		                  add(fgTrees);

		                  var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
		                  var treetex = Paths.getPackerAtlas('stages/school/weebTrees');
		                  bgTrees.frames = treetex;
		                  bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
		                  bgTrees.animation.play('treeLoop');
		                  bgTrees.scrollFactor.set(0.85, 0.85);
		                  add(bgTrees);

		                  var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
		                  treeLeaves.frames = Paths.getSparrowAtlas('stages/school/petals');
		                  treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', Std.int(24 * songMultiplier), true);
		                  treeLeaves.animation.play('leaves');
		                  treeLeaves.scrollFactor.set(0.85, 0.85);
		                  add(treeLeaves);

		                  var widShit = Std.int(bgSky.width * 6);

		                  bgSky.setGraphicSize(widShit);
		                  bgSchool.setGraphicSize(widShit);
		                  bgStreet.setGraphicSize(widShit);
		                  bgTrees.setGraphicSize(Std.int(widShit * 1.4));
		                  fgTrees.setGraphicSize(Std.int(widShit * 0.8));
		                  treeLeaves.setGraphicSize(widShit);

		                  fgTrees.updateHitbox();
		                  bgSky.updateHitbox();
		                  bgSchool.updateHitbox();
		                  bgStreet.updateHitbox();
		                  bgTrees.updateHitbox();
		                  treeLeaves.updateHitbox();

		                  bgGirls = new BackgroundGirls(-100, 190);
		                  bgGirls.scrollFactor.set(0.9, 0.9);

		                  if (SONG.song.toLowerCase() == 'roses')
	                          {
		                          bgGirls.getScared();
		                  }

		                  bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
		                  bgGirls.updateHitbox();
		                  add(bgGirls);
		          }
		          case 'schoolEvil':
		          {

		                  var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		                  var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

		                  var posX = 400;
	                          var posY = 200;

		                  var bg:FlxSprite = new FlxSprite(posX, posY);
		                  bg.frames = Paths.getSparrowAtlas('stages/schoolEvil/animatedEvilSchool');
		                  bg.animation.addByPrefix('idle', 'background 2', Std.int(24 * songMultiplier));
		                  bg.animation.play('idle');
		                  bg.scrollFactor.set(0.8, 0.9);
		                  bg.scale.set(6, 6);
		                  add(bg);

		                  /* 
		                           var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stages/schoolEvil/evilSchoolBG'));
		                           bg.scale.set(6, 6);
		                           // bg.setGraphicSize(Std.int(bg.width * 6));
		                           // bg.updateHitbox();
		                           add(bg);

		                           var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('stages/schoolEvil/evilSchoolFG'));
		                           fg.scale.set(6, 6);
		                           // fg.setGraphicSize(Std.int(fg.width * 6));
		                           // fg.updateHitbox();
		                           add(fg);

		                           wiggleShit.effectType = WiggleEffectType.DREAMY;
		                           wiggleShit.waveAmplitude = 0.01;
		                           wiggleShit.waveFrequency = 60;
		                           wiggleShit.waveSpeed = 0.8;
		                    */

		                  // bg.shader = wiggleShit.shader;
		                  // fg.shader = wiggleShit.shader;

		                  /* 
		                            var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
		                            var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

		                            // Using scale since setGraphicSize() doesnt work???
		                            waveSprite.scale.set(6, 6);
		                            waveSpriteFG.scale.set(6, 6);
		                            waveSprite.setPosition(posX, posY);
		                            waveSpriteFG.setPosition(posX, posY);

		                            waveSprite.scrollFactor.set(0.7, 0.8);
		                            waveSpriteFG.scrollFactor.set(0.9, 0.8);

		                            // waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
		                            // waveSprite.updateHitbox();
		                            // waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
		                            // waveSpriteFG.updateHitbox();

		                            add(waveSprite);
		                            add(waveSpriteFG);
		                    */
		          }

				  case 'tank':
				  {
					  defaultCamZoom = 0.9;
					  var bg:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('stages/tank/tankSky'));
		              bg.antialiasing = true;
					  bg.scrollFactor.set(0,0);
		              add(bg);

					  var clouds:FlxSprite = new FlxSprite(FlxG.random.int(-700,-100), FlxG.random.int(-20, 20)).loadGraphic(Paths.image('stages/tank/tankClouds'));
					  clouds.active = true;
					  clouds.velocity.x = FlxG.random.float(5,15);
					  clouds.antialiasing = true;
					  clouds.scrollFactor.set(0.1,0.1);
					  add(clouds);

					  var bgmountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('stages/tank/tankMountains'));
					  bgmountains.setGraphicSize(Std.int(bgmountains.width * 1.2));
					  bgmountains.antialiasing = true;
					  bgmountains.updateHitbox();
					  bgmountains.scrollFactor.set(0.2,0.2);
					  add(bgmountains);
					  
					  var bgbuildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('stages/tank/tankBuildings'));
					  bgbuildings.setGraphicSize(Std.int(bgbuildings.width * 1.1));
					  bgbuildings.antialiasing = true;
					  bgbuildings.updateHitbox();
					  bgbuildings.scrollFactor.set(0.3, 0.3);
					  add(bgbuildings);

					  var bgruins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('stages/tank/tankRuins'));
					  bgruins.setGraphicSize(Std.int(bgruins.width * 1.1));
					  bgruins.antialiasing = true;
					  bgruins.updateHitbox();
					  bgruins.scrollFactor.set(0.35,0.35);
					  add(bgruins);

					  var leftsmoke:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('stages/tank/SmokeLeft'));
					  leftsmoke.frames = Paths.getSparrowAtlas('stages/tank/smokeLeft');
		              leftsmoke.animation.addByPrefix('smoke', 'SmokeBlurLeft', Std.int(24 * songMultiplier), true);
					  leftsmoke.antialiasing = true;
					  leftsmoke.animation.play('smoke');
					  leftsmoke.scrollFactor.set(0.4,0.4);
					  add(leftsmoke);

					  var rightsmoke:FlxSprite = new FlxSprite(1100, -100).loadGraphic(Paths.image('stages/tank/SmokeRight'));
					  rightsmoke.frames = Paths.getSparrowAtlas('stages/tank/smokeRight');
		              rightsmoke.animation.addByPrefix('smoke', 'SmokeRight', Std.int(24 * songMultiplier), true);
					  rightsmoke.antialiasing = true;
					  rightsmoke.animation.play('smoke');
					  rightsmoke.scrollFactor.set(0.4,0.4);
					  add(rightsmoke);

					  var bgwatchtower:FlxSprite = new FlxSprite(100, 50).loadGraphic(Paths.image('stages/tank/tankWatchtower'));
					  bgwatchtower.frames = Paths.getSparrowAtlas('stages/tank/tankWatchtower');
		              bgwatchtower.animation.addByPrefix('watchtower', 'watchtower gradient color', Std.int(24 * songMultiplier));
					  bgwatchtower.animation.play('watchtower');
					  bgwatchtower.antialiasing = true;
					  bgwatchtower.scrollFactor.set(0.5,0.5);
					  add(bgwatchtower);

					  tank = new FlxSprite(300, 300).loadGraphic(Paths.image('stages/tank/tankRolling'));
					  tank.frames = Paths.getSparrowAtlas('stages/tank/tankRolling');
		              tank.animation.addByPrefix('tankRolling', 'BG tank w lighting', Std.int(24 * songMultiplier), true);
					  tank.antialiasing = true;
					  tank.animation.play('tankRolling');
					  tank.scrollFactor.set(0.5,0.5);
					  add(tank);

					  runningtanks = new FlxTypedGroup<FlxSprite>();

					  tankground = new FlxSprite(-420, -150).loadGraphic(Paths.image('stages/tank/tankGround'));
					  tankground.setGraphicSize(Std.int(tankground.width * 1.15));
					  tankground.antialiasing = true;
					  tankground.updateHitbox();
					  add(tankground);

					  tank0 = new FlxSprite(-500, 650).loadGraphic(Paths.image('stages/tank/tank0'));
					  tank1  = new FlxSprite(-300, 750).loadGraphic(Paths.image('stages/tank/tank1'));
					  tank2  = new FlxSprite(450, 940).loadGraphic(Paths.image('stages/tank/tank2'));
					  tank3  = new FlxSprite(1300, 1200).loadGraphic(Paths.image('stages/tank/tank3'));
					  tank4  = new FlxSprite(1300, 900).loadGraphic(Paths.image('stages/tank/tank4'));
					  tank5  = new FlxSprite(1620, 700).loadGraphic(Paths.image('stages/tank/tank5'));
					  tank0.antialiasing = true;
					  tank1.antialiasing = true;
					  tank2.antialiasing = true;
					  tank3.antialiasing = true;
					  tank4.antialiasing = true;
					  tank5.antialiasing = true;
					  tank0.frames = Paths.getSparrowAtlas('stages/tank/tank0');
		              tank0.animation.addByPrefix('tank', 'fg', Std.int(24 * songMultiplier));
					  tank1.frames = Paths.getSparrowAtlas('stages/tank/tank1');
		              tank1.animation.addByPrefix('tank', 'fg', Std.int(24 * songMultiplier));
					  tank2.frames = Paths.getSparrowAtlas('stages/tank/tank2');
		              tank2.animation.addByPrefix('tank', 'foreground', Std.int(24 * songMultiplier));
					  tank3.frames = Paths.getSparrowAtlas('stages/tank/tank3');
		              tank3.animation.addByPrefix('tank', 'fg', Std.int(24 * songMultiplier));
					  tank4.frames = Paths.getSparrowAtlas('stages/tank/tank4');
		              tank4.animation.addByPrefix('tank', 'fg', Std.int(24 * songMultiplier));
					  tank5.frames = Paths.getSparrowAtlas('stages/tank/tank5');
		              tank5.animation.addByPrefix('tank', 'fg', Std.int(24 * songMultiplier));
					  tank0.animation.play('tank');
					  tank1.animation.play('tank');
					  tank2.animation.play('tank');
					  tank3.animation.play('tank');
					  tank4.animation.play('tank');
					  tank5.animation.play('tank');
					  tank0.scrollFactor.set(1.7,1.5);
					  tank1.scrollFactor.set(2,0.2);
					  tank2.scrollFactor.set(1.5,1.5);
					  tank3.scrollFactor.set(3.5,2.5);
					  tank4.scrollFactor.set(1.5,1.5);
					  tank5.scrollFactor.set(1.5,1.5);
				  }

				  case 'amogus':
				  {
		                  defaultCamZoom = 0.9;
		                  var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/amogus/amogus_bg'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.9, 0.9);
		                  bg.active = false;
		                  add(bg);

		                  var ground:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stages/amogus/amogusGround'));
		                  ground.setGraphicSize(Std.int(ground.width * 1.1));
		                  ground.updateHitbox();
		                  ground.antialiasing = true;
		                  ground.scrollFactor.set(0.9, 0.9);
		                  ground.active = false;
		                  add(ground);
				  }

		          default:
		          {
		                  defaultCamZoom = 0.9;
		                  curStage = 'stage';
		                  var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/stage/stageback'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.9, 0.9);
		                  bg.active = false;
		                  add(bg);

		                  var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stages/stage/stagefront'));
		                  stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		                  stageFront.updateHitbox();
		                  stageFront.antialiasing = true;
		                  stageFront.scrollFactor.set(0.9, 0.9);
		                  stageFront.active = false;
		                  add(stageFront);

		                  var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stages/stage/stagecurtains'));
		                  stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		                  stageCurtains.updateHitbox();
		                  stageCurtains.antialiasing = true;
		                  stageCurtains.scrollFactor.set(1.3, 1.3);
		                  stageCurtains.active = false;

		                  add(stageCurtains);
		          }
              }
		var gfVersion:String = 'gf';
		if (SONG.gf != null)
			gfVersion = SONG.gf;
		/*
		{
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';		
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				case 'tank':
					gfVersion = 'gf-tankmen';
					if (SONG.song.toLowerCase() == 'stress')
						gfVersion = 'pico-speaker';
				case 'amogus':
					gfVersion = 'gf-amogus';
			}
		}
		*/		
	

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (SONG.song.toLowerCase() == 'stress' && SONG.gf == 'pico-speaker')
		{
			remove(tankground);
			
			runningtank = new FlxSprite(FlxG.width + 1000, 500);
			if (FlxG.save.data.cleanmode)
				runningtank.frames = Paths.getSparrowAtlas('stages/tank/tankmanKilled1CLEAN');
			else
				runningtank.frames = Paths.getSparrowAtlas('stages/tank/tankmanKilled1');

        	runningtank.antialiasing = true;
        	runningtank.animation.addByPrefix("run", "tankman running", Std.int(24 * songMultiplier), true);
        	runningtank.animation.addByPrefix("shot", "John Shot " + FlxG.random.int(1,2), Std.int(24 * songMultiplier), false);
        	// runningtank.setGraphicSize(Std.int(0.8 * runningtank.width));
        	runningtank.updateHitbox();
        	runningtank.animation.play("run");
        	runningTankSpeed.push(0.7);
        	tankGoingRight.push(false);

			tankStrumTime.push(Character.animationNotes[0][0]);
        	endingOffset.push(FlxG.random.float(0.6, 1));
			resetRunningTank(FlxG.width * 1.5, 200 + FlxG.random.int(50, 100), true, runningtank, 0);
			runningtanks.add(runningtank);
			add(runningtank);

			var tanknum = 1;
			for (c in 1...Character.animationNotes.length)
			{
				if (FlxG.random.float(0, 100) < 16)
				{
                	var runningtank2:FlxSprite = runningtank.clone();
                	runningTankSpeed.push(0.7);
                	tankGoingRight.push(false);

                	tankStrumTime.push(Character.animationNotes[c][0]);
                	endingOffset.push(FlxG.random.float(0.6, 1));
                	resetRunningTank(FlxG.width * 1.5, 200 + FlxG.random.int(50, 100),  2 > Character.animationNotes[c][1], runningtank2, tanknum);
					runningtanks.add(runningtank2);
					add(runningtank2);
                	tanknum++;
				}
			}
			add(tankground);
		}

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'gf-tankmen' | 'pico-speaker':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'bf':
				if (curStage == 'philly')
					camPos.x += 600;
			case 'bf-car':
				dad.y += 350;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tankman':
				dad.y += 180;
			case 'tankmannoamongus':
				dad.y += 250;
			case 'bf-pixel':
				dad.y += 550;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		switch (SONG.player1)
		{
			case 'pico':
				boyfriend.y -= 50;
			case 'gf-christmas' | 'gf' | 'pico-speaker':
				if (SONG.song.toLowerCase() == "tutorial")
					dad.setPosition(boyfriend.x, boyfriend.y);
				boyfriend.setPosition(gf.x, gf.y);
				gf.visible = false;
			case 'monster-christmas' | 'monster':
				boyfriend.y -= 250;
			case 'tankman' | 'spooky':
				boyfriend.y -= 150;
			case 'tankmannoamongus':
				boyfriend.y -= 100;
			case 'mom' | 'mom-car':
				boyfriend.y -= 400;
			case 'spirit':
				boyfriend.y -= 500;
			case 'senpai' | 'senpai-angry':
				boyfriend.y -= 250;
			case 'bf-pixel':
				if (SONG.song.toLowerCase() == 'test')
				{
					boyfriend.y += 175;
					boyfriend.x += 200;
				}
			case 'dad' | 'amogusguy' | 'parents-christmas':
				boyfriend.y -= 300;
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'stage':
				if (dad.curCharacter == 'bf-pixel')
					dad.y -= 50;
				else if (dad.curCharacter.startsWith('bf'))
					dad.y += 400;

			case 'philly':
				if (SONG.player2.startsWith('bf'))
				{
					dad.y += 350;
				}

			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;
			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

			case 'tank':
				if (SONG.player2.startsWith("bf"))
				{
					dad.y += 350;
				}
				else
				{
					dad.y += 60;
				}
				dad.x -= 80;
				if (gf.curCharacter == 'pico-speaker')
				{
					gf.y -= 200;
					gf.x -= 50;
				}
				else
				{
					gf.y -= 75;
					gf.x -= 170;
				}
				boyfriend.x += 40;
		}
		// evil spooky trail time
		if (dad.curCharacter == 'spirit' || boyfriend.curCharacter == 'spirit')
		{
			var evilTrail:FlxTrail;
			if (dad.curCharacter == 'spirit')
				evilTrail = new FlxTrail(dad, null, 4, Std.int(24 * songMultiplier), 0.3, 0.069);
			else
				evilTrail = new FlxTrail(boyfriend, null, 4, Std.int(24 * songMultiplier), 0.3, 0.069);
			add(evilTrail);
		}
		
		// Shitty layering but whatev it works LOL

		add(gf);
		if (curStage == 'limo')
			add(limo);
		add(dad);
		add(boyfriend);

		if (curStage == 'tank')
			add(tank0);
			add(tank1);
			add(tank2);
			add(tank3);
			add(tank4);
			add(tank5);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (FlxG.save.data.downscroll)
		{
			strumLine.y = FlxG.height - 165;
		}

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);
		add(grpPixelNoteSplashes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		player2Strums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
		{
			healthBarBG.y = 50;
		}
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (OG.BSIDE)
			healthBar.createFilledBar(bsideiconColors(SONG.player2), bsideiconColors(SONG.player1));
		else
			healthBar.createFilledBar(iconColors(SONG.player2), iconColors(SONG.player1));
		// healthBar
		add(healthBar);

		FULLhealthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		FULLhealthBar.scrollFactor.set();
		FULLhealthBar.createFilledBar(0xFFFFFF00, 0xFFFFFF00);
		FULLhealthBar.visible = false;
		add(FULLhealthBar);

		songTxt = new FlxText(0, healthBarBG.y + 45, 0, "", 20);
		if (FlxG.save.data.downscroll)
			songTxt.y = healthBarBG.y - 45;
		songTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		songTxt.scrollFactor.set();
		add(songTxt);

		accuracyTxt = new FlxText(1150, songTxt.y - 25, 0, "", 20);
		if (FlxG.save.data.downscroll)
			accuracyTxt.y = songTxt.y + 25;
		accuracyTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		accuracyTxt.scrollFactor.set();
		add(accuracyTxt);

		ratingTxt = new FlxText(1235, accuracyTxt.y - 25, 0, "", 20);
		if (FlxG.save.data.downscroll)
			ratingTxt.y = accuracyTxt.y + 25;
		ratingTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		ratingTxt.scrollFactor.set();
		ratingTxt.visible = false;
		add(ratingTxt);

		sickstxt = new FlxText(20, 0, 0, "", 32);
		sickstxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		sickstxt.scrollFactor.set();
		add(sickstxt);

		goodstxt = new FlxText(20, 0, 0, "", 32);
		goodstxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		goodstxt.scrollFactor.set();		
		add(goodstxt);

		badstxt = new FlxText(20, 0, 0, "", 32);
		badstxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		badstxt.scrollFactor.set();
		add(badstxt);

		shitstxt = new FlxText(20, 0, 0, "", 32);
		shitstxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		shitstxt.scrollFactor.set();
		add(shitstxt);


		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 300, healthBarBG.y + 45, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		healthTxt = new FlxText(healthBarBG.x + healthBarBG.width - 150, healthBarBG.y + 45, 0, "", 20);
		healthTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		healthTxt.scrollFactor.set();
		add(healthTxt);

		missesTxt = new FlxText(healthBarBG.x + healthBarBG.width - 450, healthBarBG.y + 45, 0, "", 20);
		missesTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		missesTxt.scrollFactor.set();
		add(missesTxt);

		modeTxt = new FlxText(25, healthBarBG.y, 0, "", 20);
		modeTxt.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		modeTxt.scrollFactor.set();
		add(modeTxt);

		lengthTxt = new FlxText(0, 30, 0, "", 20);
		if (FlxG.save.data.downscroll)
			lengthTxt.y = FlxG.height * 0.9 + 0;
		lengthTxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		lengthTxt.screenCenter(X);
		lengthTxt.x -= (SONG.song.length * (10 / (SONG.song.length / 3))); //no idea how i got this but it works so ok
		//lengthTxt.x -= 30;
		lengthTxt.scrollFactor.set();
		lengthTxt.alpha = 0;
		
		add(lengthTxt);

		lengthTxt.cameras = [camHUD];

		lengthBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			lengthBG.y = FlxG.height * 0.9 + 45;
		lengthBG.screenCenter(X);
		lengthBG.scrollFactor.set();
		lengthBG.alpha = 0;
		add(lengthBG);

		lengthBar = new FlxBar(lengthBG.x + 4, lengthBG.y + 4, LEFT_TO_RIGHT, Std.int(lengthBG.width - 8), Std.int(lengthBG.height - 8), this,
			'curSongPos', 0, 90000);
		lengthBar.scrollFactor.set();
		if (OG.BSIDE)
			lengthBar.createFilledBar(FlxColor.GRAY, bsideiconColors(SONG.player1));
		else
			lengthBar.createFilledBar(FlxColor.GRAY, iconColors(SONG.player1));
		lengthBar.alpha = 0;
		add(lengthBar);

		songName = new FlxText(lengthBG.x + (lengthBG.width / 2) - (SONG.song.length * 5), lengthBG.y, 0, SONG.song, 16);
		if (FlxG.save.data.downscroll)
			songName.y -= 3;
		songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songName.scrollFactor.set();
		songName.alpha = 0;
		add(songName);
		songName.cameras = [camHUD];

		var gftutorialicon = false;
		if (SONG.player1.startsWith("bf") || SONG.player2.startsWith("bf"))
			gftutorialicon = true;
		var bsideicon:Bool = false;
		if (OG.BSIDE)
			bsideicon = true;

		iconP1 = new HealthIcon(SONG.player1, true, false, bsideicon);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false, gftutorialicon, bsideicon);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [noteCam];
		notes.cameras = [noteCam];
		healthBar.cameras = [camHUD];
		FULLhealthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [ScoreTxtCam];
		healthTxt.cameras = [HealthTxtCam];
		missesTxt.cameras = [MissesTxtCam];
		modeTxt.cameras = [camHUD];
		songTxt.cameras = [camHUD];
		accuracyTxt.cameras = [AccuracyTxtCam];
		ratingTxt.cameras = [RatingTxtCam];
		sickstxt.cameras = [SicksTxtCam];
		goodstxt.cameras = [GoodsTxtCam];
		badstxt.cameras = [BadsTxtCam];
		shitstxt.cameras = [ShitsTxtCam];
		doof.cameras = [camHUD];
		lengthBG.cameras = [camHUD];
		lengthBar.cameras = [camHUD];
		grpNoteSplashes.cameras = [noteCam];
		grpPixelNoteSplashes.cameras = [noteCam];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		camHUD.alpha = 0;
		setAlphaTxtCams(0);

		if (((!isStoryMode && FlxG.save.data.freeplaydialog) || (isStoryMode && FlxG.save.data.storymodedialog) || OG.forceCutscene) && !OG.currentCutsceneEnded) //how did my tiny brain compose this
		{
			OG.currentCutsceneEnded = true;
			OG.forceCutscene = false;
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					toggleTxtCams(false);
					noteCam.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							toggleTxtCams(true);
							noteCam.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									if (!OG.BSIDE && SONG.player1.startsWith('bf'))
										schoolIntro(doof);
									else
									{
										OG.currentCutsceneEnded = false;
										startCountdown();
									}
								}
							});
						});
					});

				case 'senpai' | 'thorns':
					if (SONG.player1.startsWith('bf'))
						schoolIntro(doof);
					else
					{
						OG.currentCutsceneEnded = false;
						startCountdown();
					}
				case 'roses':
					if (SONG.player1.startsWith('bf')) {
						FlxG.sound.play(Paths.sound('ANGRY'));
						schoolIntro(doof);
					}
					else
					{
						OG.currentCutsceneEnded = false;
						startCountdown();
					}
				case 'tutorial' | 'bopeebo' | 'fresh' | 'dadbattle' | 'spookeez' | 'south' | 'monster' | 'pico' | 'blammed' | 'philly' | 'satin-pants'| 'satin-panties' | 'high' | 'milf' | 'mom' | 'cocoa' | 'eggnog': //copy and paste go brrrrr
					if (!OG.BSIDE && SONG.player1.startsWith('bf'))
						schoolIntro(doof);
					else
					{
						OG.currentCutsceneEnded = false;
						startCountdown();
					}
				case 'guns':
					inCutscene = true;
					#if desktop
						DiscordClient.changePresence("in Guns Cutscene", SONG.song + " (" + storyDifficultyText + modeText + ")", player2RPC);
					#end
					camHUD.visible = false;
					toggleTxtCams(false);
					noteCam.visible = false;
					var black:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
					add(black);
					black.scrollFactor.set();
					if (FlxG.save.data.cleanmode)
						FlxG.switchState(new VideoState('assets/week7/videos/gunsCutsceneCLEAN.webm', function() {FlxG.switchState(new PlayState());}));
					else
						FlxG.switchState(new VideoState('assets/week7/videos/gunsCutscene.webm', function() {FlxG.switchState(new PlayState());}));
				case 'ugh':
					inCutscene = true;
					#if desktop
						DiscordClient.changePresence("in Ugh Cutscene", SONG.song + " (" + storyDifficultyText + modeText + ")", player2RPC);
					#end
					camHUD.visible = false;
					toggleTxtCams(false);
					noteCam.visible = false;
					var black:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
					add(black);
					black.scrollFactor.set();
					if (FlxG.save.data.cleanmode)
						FlxG.switchState(new VideoState('assets/week7/videos/ughCutsceneCLEAN.webm', function() {FlxG.switchState(new PlayState());}));
					else
						FlxG.switchState(new VideoState('assets/week7/videos/ughCutscene.webm', function() {FlxG.switchState(new PlayState());}));
				case 'stress':
					inCutscene = true;
					#if desktop
						DiscordClient.changePresence("in Stress Cutscene", SONG.song + " (" + storyDifficultyText + modeText + ")", player2RPC);
					#end
					camHUD.visible = false;
					toggleTxtCams(false);
					noteCam.visible = false;
					var black:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
					add(black);
					black.scrollFactor.set();
					if (FlxG.save.data.cleanmode)
						FlxG.switchState(new VideoState('assets/week7/videos/stressCutsceneCLEAN.webm', function() {FlxG.switchState(new PlayState());}));
					else
						FlxG.switchState(new VideoState('assets/week7/videos/stressCutscene.webm', function() {FlxG.switchState(new PlayState());}));
				default:
					OG.currentCutsceneEnded = false;
					startCountdown();
			}
		}
		else
		{	
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland" | 'senpai' | 'thorns' | 'roses' | 'tutorial' | 'bopeebo' | 'fresh' | 'dadbattle' | 'spookeez' | 'south' | 'monster' | 'pico' | 'blammed' | 'philly' | 'satin-pants'| 'satin-panties' | 'high' | 'milf' | 'mom' | 'cocoa' | 'eggnog' |  'guns' | 'ugh' | 'stress':
					if ((!isStoryMode && !FlxG.save.data.freeplaydialog) || (isStoryMode && !FlxG.save.data.storymodedialog))
						OG.currentCutsceneEnded = true;
					startCountdown();
				default:
					OG.currentCutsceneEnded = false;
					startCountdown();
			}
		}
		if (FlxG.camera.zoom == defaultCamZoom && FlxG.save.data.menutransitions)
		{
			FlxG.camera.zoom = 1.5;
			FlxTween.tween(FlxG.camera, { zoom: defaultCamZoom, angle: 0}, 0.5, {ease: FlxEase.quadIn });
		}

		if (isStoryMode)
		{
			songMultiplier = 1;
			swappedsides = false;
			botplay = false;
			oneshot = false;
			praticemode = false;
		}

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var bside:String = '';
		var daColor:FlxColor = 0xFFff1b31;
		if (OG.BSIDE)
		{
			bside = 'b-side/';
			daColor = 0xFF2121C4;
		}
		
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var colorbg:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, daColor);
		colorbg.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/' + bside + 'senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(colorbg);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(colorbg);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function iconColors(icon:String)
	{
		switch (icon)
		{
			case 'bf' | 'bf-car' | 'bf-christmas' | 'bf-pixel':
				return 0xFF149DFF;
			case 'bf-holding-gf':
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
				return 0xFFAF66CE;
			case 'pico' | 'pico-speaker' | 'pico-pixel':
				return 0xFFB7D855;
			case 'senpai' | 'senpai-angry':
				return 0xFFFFAA6F;
			case 'spirit':
				return 0xFFFF3C6E;
			case 'spooky':
				return 0xFFFD9013;
			case 'mom' | 'mom-car':
				return 0xFFD8558E;
			case 'tankman' | 'tankmannoamongus' | 'tankman-pixel':
				return FlxColor.WHITE;
			case 'bf-old':
				return 0xFFE9FF48;
			case 'face':
				return 0xFFA1A1A1;
			case 'gf-amogus':
				return 0xFFFBE30C;
			default:
			if (SONG.player2 == icon)
				return 0xFFFF0000;
			else
				return 0xFF66FF33;
		}
	}

	function bsideiconColors(icon:String)
	{
		switch (icon)
		{
			case 'bf' | 'bf-pixel' | 'bf-car' | 'bf-christmas':
				return 0xFFE86ACB;
			case 'dad' | 'mom' | 'mom-car' | 'parents-christmas':
				return 0xFFFB97C2;
			case 'spooky':
				return 0xFFC3C3C3;
			case 'pico':
				return 0xFF8978CC;
			case 'spirit':
				return 0xFF59B4FF;
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
			if (SONG.player2 == icon)
				return 0xFFFF0000;
			else
				return 0xFF66FF33;
		}
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start((Conductor.crochet / 1000), function(tmr:FlxTimer)
		{
			curEnemy.dance();
			gf.dance();
			curPlayer.playAnim('idle');
			if (curPlayer.color != FlxColor.WHITE)
				curPlayer.color = FlxColor.WHITE;
			if (curPlayer.curCharacter.startsWith('gf') || curPlayer.curCharacter.startsWith('spooky'))
				curPlayer.dance();

			if (FlxG.save.data.skipcountdown)
			{
				startTimer.active = false;
				Conductor.songPosition = -500;
				return;
			}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			if (notestyle == 'pixel')
				introAssets.set('default', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			if (notestyle == 'pixel')
				altSuffix = '-pixel';

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (notestyle == 'pixel')
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'+ altSuffix), 0.6);
					FlxTween.tween(camHUD, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
					tweenAlphaTxtCams(1,1.4);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (notestyle == 'pixel')
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (notestyle == 'pixel')
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	var songStarted = false;

	public static var songMultiplier = 1.0;
	public var previousRate = songMultiplier;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			if (FlxG.save.data.cleanmode && (SONG.song.toLowerCase() == 'no among us' || SONG.song.toLowerCase() == 'h.e. no among us'))
				FlxG.sound.playMusic(Paths.cleaninst(SONG.song), 1, false);
			else
				if (OG.BSIDE)
					FlxG.sound.playMusic(Paths.bsideinst(SONG.song), 1, false);
				else
					FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		#if desktop
		songLength = FlxG.sound.music.length / 2;
		#else
		songLength = FlxG.sound.music.length;
		#end

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC, true, songLength);
		#end
		remove(lengthBG);
		remove(lengthBar);
		remove(songName);

		lengthBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			lengthBG.y = FlxG.height * 0.9 + 45;
		lengthBG.screenCenter(X);
		lengthBG.scrollFactor.set();
		lengthBG.alpha = 0;
		add(lengthBG);

		lengthBar = new FlxBar(lengthBG.x
			+ 4, lengthBG.y
			+ 4, LEFT_TO_RIGHT, Std.int(lengthBG.width - 8), Std.int(lengthBG.height - 8), this,
			'curSongPos', 0, songLength
			- 1000);
		lengthBar.numDivisions = 1000;
		lengthBar.scrollFactor.set();
		lengthBar.alpha = 0;
		if (OG.BSIDE)
			lengthBar.createFilledBar(FlxColor.GRAY, bsideiconColors(curPlayer.curCharacter));
		else
			lengthBar.createFilledBar(FlxColor.GRAY, iconColors(curPlayer.curCharacter));
		add(lengthBar);

		songName = new FlxText(lengthBG.x + (lengthBG.width / 2) - (SONG.song.length * 5), lengthBG.y, 0, SONG.song, 16);
		if (FlxG.save.data.downscroll)
			songName.y -= 3;
		songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songName.scrollFactor.set();
		songName.alpha = 0;
		add(songName);

		lengthBG.cameras = [camHUD];
		lengthBar.cameras = [camHUD];
		songName.cameras = [camHUD];
		FlxTween.tween(lengthTxt, {alpha: 1}, 0.8, {ease: FlxEase.expoInOut});
		FlxTween.tween(lengthBar, {alpha: 1}, 0.8, {ease: FlxEase.expoInOut});
		FlxTween.tween(lengthBG, {alpha: 1}, 0.8, {ease: FlxEase.expoInOut});
		FlxTween.tween(songName, {alpha: 1}, 0.8, {ease: FlxEase.expoInOut});
		#if desktop
		@:privateAccess
		{
			lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);			
			if (vocals.playing)
				lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);
		}
		trace("pitched inst and vocals to " + songMultiplier);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			if (OG.BSIDE)
				vocals = new FlxSound().loadEmbedded(Paths.bsidevoices(SONG.song));
			else
				vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;
				if (swappedsides)
					gottaHitNote = !section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
					if (swappedsides)
						gottaHitNote = section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, songNotes[4]);
				swagNote.sustainLength = songNotes[2];
				swagNote.altNote = songNotes[3];
				swagNote.noteType = songNotes[4];
				swagNote.scrollFactor.set(0, 0);

				if (!CoolUtil.coolTextFile(Paths.txt('noteTypeList-pixel')).contains(swagNote.noteType) && swagNote.noteType != null && notestyle == 'pixel')
				{
					swagNote.noteType = 'normal';
				}

				var susLength:Float = swagNote.sustainLength;

				susLength /= Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, songNotes[4]);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						if (!swappedsides)
							sustainNote.x += FlxG.width / 2; // general offset
						if (FlxG.save.data.middlescroll) {
							if (!swappedsides)
								sustainNote.x -= 275;
							else
								sustainNote.x += 365;
						}
						if (!FlxG.save.data.enemystrums)
							sustainNote.visible = false;
					}
					else 
					{
						if (swappedsides)
							sustainNote.x += FlxG.width / 2; // general offset
						if (FlxG.save.data.middlescroll)
						{
							if (swappedsides)
								sustainNote.x += 275;

							sustainNote.setGraphicSize(Std.int(sustainNote.width * 0.4));
							sustainNote.updateHitbox();
							switch (swagNote.noteData)
							{
								case 0:
									sustainNote.x -= 160 * 0.7 * 0;
									sustainNote.x += 160 * 0.4 * 0;
								case 1:
									sustainNote.x -= 160 * 0.7 * 1;
									sustainNote.x += 160 * 0.4 * 1;
								case 2:
									sustainNote.x -= 160 * 0.7 * 2;
									sustainNote.x += 160 * 0.4 * 2;
								case 3:
									sustainNote.x -= 160 * 0.7 * 3;
									sustainNote.x += 160 * 0.4 * 3;
							}
							sustainNote.x -= 12.5;
							if (notestyle == 'pixel')
								sustainNote.x += 5;
							if (sustainNote.prevNote.isSustainNote)
								sustainNote.prevNote.scale.y *= 2.75;
						}
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					if (!swappedsides)
						swagNote.x += FlxG.width / 2; // general offset
					if (FlxG.save.data.middlescroll) {
					if (!swappedsides)
						swagNote.x -= 275;
					else
						swagNote.x += 365;
					}
					if (!FlxG.save.data.enemystrums)
						swagNote.visible = false;
				}
				else
				{
					if (swappedsides)
						swagNote.x += FlxG.width / 2; // general offset
					if (FlxG.save.data.middlescroll)
					{
						if (swappedsides)
							swagNote.x += 275;

						if (swagNote.noteType == 'halo' || swagNote.noteType == 'fire')
							swagNote.setGraphicSize(Std.int(swagNote.width * 0.5));
						else
							swagNote.setGraphicSize(Std.int(154 * 0.4));
						swagNote.updateHitbox();
						switch (swagNote.noteData)
						{
							case 0:
								swagNote.x -= 160 * 0.7 * 0;
								swagNote.x += 160 * 0.4 * 0;
							case 1:
								swagNote.x -= 160 * 0.7 * 1;
								swagNote.x += 160 * 0.4 * 1;
							case 2:
								swagNote.x -= 160 * 0.7 * 2;
								swagNote.x += 160 * 0.4 * 2;
							case 3:
								swagNote.x -= 160 * 0.7 * 3;
								swagNote.x += 160 * 0.4 * 3;
						}
						if (swagNote.noteType == 'halo')
							swagNote.x += 85;
						if (swagNote.noteType == 'fire')
						{
							if (notestyle == 'pixel')
								swagNote.x += 15;
							else
								swagNote.x += 30;
						}
					}
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			if (notestyle == 'pixel')
			{
				babyArrow.loadGraphic(Paths.image('noteStyles/arrows-pixels'), true, 17, 17);
				babyArrow.animation.add('green', [6]);
				babyArrow.animation.add('red', [7]);
				babyArrow.animation.add('blue', [5]);
				babyArrow.animation.add('purplel', [4]);

				babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
				if (FlxG.save.data.middlescroll && ((player != 1 && !swappedsides) || (player == 1 && swappedsides)))
					babyArrow.setGraphicSize(Std.int(154 * 0.4));
				babyArrow.updateHitbox();
				babyArrow.antialiasing = false;

				switch (Math.abs(i))
				{
					case 0:
						if (!FlxG.save.data.middlescroll || (player == 1 && !swappedsides) || (player != 1 && swappedsides))
							babyArrow.x += Note.swagWidth * 0;
						else
							babyArrow.x += Note.swagWidth / 1.75 * 0;
						babyArrow.animation.add('static', [0]);
						babyArrow.animation.add('pressed', [4, 8], 12, false);
						babyArrow.animation.add('confirm', [12, 16], 24, false);
					case 1:
						if (!FlxG.save.data.middlescroll || (player == 1 && !swappedsides) || (player != 1 && swappedsides))
							babyArrow.x += Note.swagWidth * 1;
						else
							babyArrow.x += Note.swagWidth / 1.75 * 1;
						babyArrow.animation.add('static', [1]);
						babyArrow.animation.add('pressed', [5, 9], 12, false);
						babyArrow.animation.add('confirm', [13, 17], 24, false);
					case 2:
						if (!FlxG.save.data.middlescroll || (player == 1 && !swappedsides) || (player != 1 && swappedsides))
							babyArrow.x += Note.swagWidth * 2;
						else
							babyArrow.x += Note.swagWidth / 1.75 * 2;
						babyArrow.animation.add('static', [2]);
						babyArrow.animation.add('pressed', [6, 10], 12, false);
						babyArrow.animation.add('confirm', [14, 18], 12, false);
					case 3:
						if (!FlxG.save.data.middlescroll || (player == 1 && !swappedsides) || (player != 1 && swappedsides))
							babyArrow.x += Note.swagWidth * 3;
						else
							babyArrow.x += Note.swagWidth / 1.75 * 3;
						babyArrow.animation.add('static', [3]);
						babyArrow.animation.add('pressed', [7, 11], 12, false);
						babyArrow.animation.add('confirm', [15, 19], 24, false);
				}
			}
			else
			{
				switch (notestyle)
				{
					case 'tabi':
						babyArrow.frames = Paths.getSparrowAtlas('noteStyles/Tabi');
					case 'kapi':
						babyArrow.frames = Paths.getSparrowAtlas('noteStyles/Kapi');
					case 'camellia':
						babyArrow.frames = Paths.getSparrowAtlas('noteStyles/Camellia');
					default:
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
				}
	
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

				babyArrow.antialiasing = true;
				babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
				if (FlxG.save.data.middlescroll && ((player != 1 && !swappedsides) || (player == 1 && swappedsides)))
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.4));


				switch (Math.abs(i))
				{
					case 0:
						if (!FlxG.save.data.middlescroll || (player == 1 && !swappedsides) || (player != 1 && swappedsides))
							babyArrow.x += Note.swagWidth * 0;
						else
							babyArrow.x += Note.swagWidth / 1.75 * 0;
						babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
						babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						babyArrow.animation.addByPrefix('ugh', 'left ugh', 24, false);
						babyArrow.animation.addByPrefix('aaa', 'left aaa', 24, false);
					case 1:
						if (!FlxG.save.data.middlescroll || (player == 1 && !swappedsides) || (player != 1 && swappedsides))
							babyArrow.x += Note.swagWidth * 1;
						else
							babyArrow.x += Note.swagWidth / 1.75 * 1;
						babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
						babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						if (!FlxG.save.data.middlescroll || (player == 1 && !swappedsides) || (player != 1 && swappedsides))
							babyArrow.x += Note.swagWidth * 2;
						else
							babyArrow.x += Note.swagWidth / 1.75 * 2;
						babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
						babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						babyArrow.animation.addByPrefix('ugh', 'up ugh', 24, false);
						babyArrow.animation.addByPrefix('aaa', 'up aaa', 24, false);
					case 3:
						if (!FlxG.save.data.middlescroll || (player == 1 && !swappedsides) || (player != 1 && swappedsides))
							babyArrow.x += Note.swagWidth * 3;
						else
							babyArrow.x += Note.swagWidth / 1.75 * 3;
						babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
						babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				player2Strums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			if (FlxG.save.data.middlescroll)
			{
				if (player == 1 && !swappedsides)
					babyArrow.x -= 275;
				else if (player != 1 && swappedsides)
					babyArrow.x += 365;
				else if (player == 1 && swappedsides)
					babyArrow.x += 275;
			}
			if (!FlxG.save.data.enemystrums)
			{
				if ((!swappedsides && player != 1) || (swappedsides && player == 1))
					babyArrow.visible = false;
			}
			player2Strums.forEach(function(spr:FlxSprite)
			{
				if (!swappedsides)
					spr.centerOffsets();
			});
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (swappedsides)
					spr.centerOffsets();
			});


			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			//timer.active = true;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC);
			}
			#end
			/*
			if (!WasHUDVisible)
			{
				camHUD.visible = false;
				toggleTxtCams(false);
			}
			if (!wasNOTEHUDVisible)
				noteCam.visible = false;
			*/
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		@:privateAccess
		{
			lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);			
			if (vocals.playing)
				lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);		
		}
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{
		FlxG.updateFramerate = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());
		#if !debug
		perfectMode = false;
		#end

		var fps = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * ((30 * songMultiplier / (fps / 60)) / fps));

		#if desktop
		if (FlxG.sound.music != null && FlxG.sound.music.playing && !paused)
			FlxG.sound.music.endTime = FlxG.sound.music.length / 2;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name.startsWith('bf'))
				if (iconP1.animation.curAnim.name == 'bf-old')
				{
					iconP1.animation.play(SONG.player1);
					if (OG.BSIDE)
					{
						healthBar.createFilledBar(bsideiconColors(SONG.player2), bsideiconColors(SONG.player1));
						lengthBar.createFilledBar(FlxColor.GRAY, bsideiconColors(curPlayer.curCharacter));
					}
					else
					{
						healthBar.createFilledBar(iconColors(SONG.player2), iconColors(SONG.player1));
						lengthBar.createFilledBar(FlxColor.GRAY, iconColors(curPlayer.curCharacter));
					}
				
					healthBar.updateFilledBar();
					lengthBar.updateFilledBar();
				}
				else
				{
					iconP1.animation.play('bf-old');
					if (OG.BSIDE)
					{
						healthBar.createFilledBar(bsideiconColors(SONG.player2), bsideiconColors('bf-old'));
						if (!swappedsides)
							lengthBar.createFilledBar(FlxColor.GRAY, bsideiconColors('bf-old'));
					}
					else
					{
						healthBar.createFilledBar(iconColors(SONG.player2), iconColors('bf-old'));
						if (!swappedsides)
							lengthBar.createFilledBar(FlxColor.GRAY, iconColors('bf-old'));
					}
					
					healthBar.updateFilledBar();
					lengthBar.updateFilledBar();
				}
			else if (iconP2.animation.curAnim.name.startsWith('bf'))			
				if (iconP2.animation.curAnim.name == 'bf-old')
				{
					iconP2.animation.play(SONG.player2);
					if (OG.BSIDE)
					{
						healthBar.createFilledBar(bsideiconColors(SONG.player2), bsideiconColors(SONG.player1));
					}
					else
					{
						healthBar.createFilledBar(iconColors(SONG.player2), iconColors(SONG.player1));
					}

					healthBar.updateFilledBar();
				}
				else
				{
					iconP2.animation.play('bf-old');
					if (OG.BSIDE)
					{
						healthBar.createFilledBar(bsideiconColors('bf-old'), bsideiconColors(SONG.player1));
					}
					else
					{
						healthBar.createFilledBar(iconColors('bf-old'), iconColors(SONG.player1));
					}

					healthBar.updateFilledBar();
				}					
		}
		if (FlxG.keys.justPressed.SIX && !inCutscene)
		{
			camHUD.visible = !camHUD.visible;
			toggleTxtCams(camHUD.visible);
		}
		if (FlxG.keys.justPressed.FIVE && !inCutscene)
			noteCam.visible = !noteCam.visible;

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			case 'tank':
				moveTank();
				if (SONG.song.toLowerCase() == 'stress') 
				{
					var updatetanknum = 0;
					for (spr in runningtanks.members) 
					{
						if (spr.x >= 1.2 * FlxG.width || spr.x <= -0.5 * FlxG.width)
							spr.visible = false;
						else
							spr.visible = true;
						if (spr.animation.curAnim.name == "run") 
						{
							var cool:Float = 0.74 * FlxG.width + endingOffset[updatetanknum];
							if (tankGoingRight[updatetanknum]) 
							{
								cool = 0.02 * FlxG.width - endingOffset[updatetanknum];
								spr.x = cool + (Conductor.songPosition - tankStrumTime[updatetanknum]) * runningTankSpeed[updatetanknum];
								spr.flipX = true;
							} 
							else 
							{
								spr.x = cool - (Conductor.songPosition - tankStrumTime[updatetanknum]) * runningTankSpeed[updatetanknum];
								spr.flipX = false;
							}
						}
						if (Conductor.songPosition > tankStrumTime[updatetanknum]) 
						{
							spr.animation.play("shot");
							if (tankGoingRight[updatetanknum]) 
							{
								spr.offset.y = 200;
								spr.offset.x = 300;
							}	
						}
						if (spr.animation.curAnim.name == "shot" && spr.animation.curAnim.curFrame >= spr.animation.curAnim.frames.length - 1) 
						{
							spr.kill();
						}
						updatetanknum++;
					}
				}
		}

		super.update(elapsed);
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC);
			}
		}
		#end
		#if desktop
		var min = Math.floor((FlxG.sound.music.length / 2 / songMultiplier - Conductor.songPosition / songMultiplier) / 60000);
		var sec = Math.floor(((FlxG.sound.music.length / 2 / songMultiplier - Conductor.songPosition / songMultiplier) % 60000) / 1000);
		#else
		var min = Math.floor((FlxG.sound.music.length / songMultiplier - Conductor.songPosition / songMultiplier) / 60000);
		var sec = Math.floor(((FlxG.sound.music.length / songMultiplier - Conductor.songPosition / songMultiplier) % 60000) / 1000);
		#end
		var finalsec = '$sec'.lpad("0", 2);
		if (Std.parseFloat(finalsec) <= 0 && min <= 0)
			lengthTxt.text = "0:00";
		else
			lengthTxt.text = Std.string(min + ":" + finalsec);

		songTxt.text = Std.string("M.M. FNF v" + Application.current.meta.get('version') + " " + SONG.song + " " + storyDifficultyText);
		songTxt.x = FlxG.width - (songTxt.width + 10);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, songScore, 0.25));

		if (Math.abs(lerpScore - songScore) <= 10)
			lerpScore = songScore;

		scoreTxt.text = "Score:" + lerpScore;
		if ((health <= 0 && !swappedsides) || (health >= 2 && swappedsides))
			healthTxt.text = "Health:" + healthBar.percent + "% (DEAD)";
		else if (oneshot)
			healthTxt.text = "Health:ONE SHOT";
		else
			healthTxt.text = "Health:" + healthBar.percent + "%";
		missesTxt.text = "Misses:" + misses;
		var accuracy:Float;
		accuracy = FlxMath.roundDecimal(((goodnotes - misses) / (goodnotes + misses + (goods * 0.025) + (bads * 0.35) + (shits * 1.25))) * 100, 2);
		 
		if (accuracy < 0)
		{
			accuracyTxt.text = "Accuracy:0%";
			accuracyTxt.x = FlxG.width - (accuracyTxt.width + 10);
		}
		else if (misses == 0 && goodnotes == 0)
		{
			accuracyTxt.text = "Accuracy:100%";
			accuracyTxt.x = FlxG.width - (accuracyTxt.width + 10);
		}
		else
		{
			accuracyTxt.text = "Accuracy:" + accuracy + "%";
			accuracyTxt.x = FlxG.width - (accuracyTxt.width + 10);
		}
		var oldratingtxt = ratingTxt.text;
		if (misses == 0)
		{
			if (sicks > 0 && goods == 0 && bads == 0 && shits == 0)
				ratingTxt.text = "(MFC)";
			else if (goods > 0 && bads == 0 && shits == 0)
				ratingTxt.text = "(GFC)";
			else
				ratingTxt.text = "(FC)";

			ratingTxt.x = FlxG.width - (ratingTxt.width + 10);
			ratingTxt.visible = true;
			if (oldratingtxt != ratingTxt.text && camZooming)
			{
				RatingTxtCam.zoom += 0.015 / songMultiplier;
				RatingTxtCam.zoom = FlxMath.lerp(1, RatingTxtCam.zoom, 0.95);
			}
		}
		else if (misses < 10)
		{
			ratingTxt.text = "(SDCB)";
			ratingTxt.x = FlxG.width - (ratingTxt.width + 10);
			ratingTxt.visible = true;
			if (oldratingtxt != ratingTxt.text && camZooming)
			{
				RatingTxtCam.zoom += 0.015 / songMultiplier;
				RatingTxtCam.zoom = FlxMath.lerp(1, RatingTxtCam.zoom, 0.95);
			}
		}
		else
		{
			ratingTxt.text = "";
			ratingTxt.visible = false;
		}
		sickstxt.text = "SICKS: " + sicks;

		goodstxt.text = "GOODS: " + goods;

		if (curStage.startsWith('amogus'))
			badstxt.text = "SUS: " + bads;
		else
			badstxt.text = "BADS: " + bads;

		if (curStage.startsWith('amogus'))
			shitstxt.text = "SUS!: " + shits;
		else if (FlxG.save.data.cleanmode)
			shitstxt.text = "TERRIBLES: " + shits;
		else
			shitstxt.text = "SHITS: " + shits;
		
		sickstxt.x = FlxG.width - (sickstxt.width + 10);
		goodstxt.x = FlxG.width - (goodstxt.width + 10);
		badstxt.x = FlxG.width - (badstxt.width + 10);
		shitstxt.x = FlxG.width - (shitstxt.width + 10);
		if (ratingTxt.visible)
			if (FlxG.save.data.downscroll)
				shitstxt.y = ratingTxt.y + 25;
			else
				shitstxt.y = ratingTxt.y - 25;
		else
			shitstxt.y = ratingTxt.y;
		if (FlxG.save.data.downscroll)
		{
			badstxt.y = shitstxt.y + 25;
			goodstxt.y = badstxt.y + 25;
			sickstxt.y = goodstxt.y + 25;
		}
		else
		{
			badstxt.y = shitstxt.y - 25;
			goodstxt.y = badstxt.y - 25;
			sickstxt.y = goodstxt.y - 25;
		}

		#if desktop
			if (praticemode)
				modeText = " - Practice Mode";
			else if (oneshot)
				modeText = " - One Shot Mode";
			else if (botplay)
				modeText = " - Botplay";
			else
				modeText = '';
		#end
		if (!botplay)
		{
			modeTxt.cameras = [camHUD];
			modeTxt.y = healthBar.y;
			modeTxt.x = 25;
		}
		if (praticemode)
			modeTxt.text = 'PRACTICE';
		else if (oneshot)
			modeTxt.text = 'ONE SHOT';
		else if (botplay)
		{
			modeTxt.cameras = [ratingCam];
			modeTxt.text = 'BOTPLAY';
			if (camHUD.visible)
				if (FlxG.save.data.downscroll)
					modeTxt.y = healthBar.y + 85;
				else
					modeTxt.y = healthBar.y - 85;
			else
				modeTxt.y = healthBar.y;
			
			modeTxt.x = healthBar.width;
		}
		else
			modeTxt.text = '';

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			//timer.active = false;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(curPlayer.getScreenPosition().x, curPlayer.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, player2RPC, player1RPC);
			#end
			/*
			if (!camHUD.visible)
			{
				WasHUDVisible = false;
				camHUD.visible = true;
				toggleTxtCams(true);
			}
			else
				WasHUDVisible = true;

			if (!noteCam.visible)
			{
				wasNOTEHUDVisible = false;
				noteCam.visible = true;
			}
			else
				wasNOTEHUDVisible = true;
			*/
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if (FlxG.save.data.menutransitions)
				FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		if (FlxG.keys.justPressed.TWO)
		{
			FlxG.switchState(new GitarooPause());
		}

		if (FlxG.keys.justPressed.U && FlxG.save.data.leftBind != "U" && FlxG.save.data.downBind != "U" && FlxG.save.data.upBind != "U" && FlxG.save.data.rightBind != "U")
		{
			if (curPlayer.curCharacter == 'tankman' || curPlayer.curCharacter == 'tankmannoamongus')
			{
				if (curPlayer.curCharacter == 'tankman')
					tankmansoundthing = new FlxSound().loadEmbedded(Paths.sound('ugh'));
				else
					tankmansoundthing = new FlxSound().loadEmbedded(Paths.sound('aaa'));
				FlxG.sound.list.add(tankmansoundthing);
				curPlayer.playAnim("singUP-alt", true);
				tankmansoundthing.play();
				#if desktop
				@:privateAccess
				{	
					if (tankmansoundthing.playing)	
						lime.media.openal.AL.sourcef(tankmansoundthing._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);					
				}
				trace("pitched the tankman sound thingy to " + songMultiplier);
				#end
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var fps = Std.int(cast (Lib.current.getChildAt(0), Main).currentframerate());
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.80 + (0.05 * (fps / 60)))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.80 + (0.05 * (fps / 60)))));
		//smooth bouncy icons

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if ((health > 2 && !swappedsides) || (health <= 0 && swappedsides))
		{
			if (!swappedsides)
				health = 2;
			else
				health = 0;
			FULLhealthBar.visible = true;
			healthBar.visible = false;
			healthTxt.color = FlxColor.YELLOW;
		}
		else if ((health < 2 && !swappedsides) || (health > 0 && swappedsides))
		{
			FULLhealthBar.visible = false;
			healthBar.visible = true;
			healthTxt.color = FlxColor.WHITE;
		}

		if (health <= 0 && !swappedsides)
			health = 0;

		if (health > 2 && swappedsides)
			health = 2;

		if (oneshot && health > 0)
			health = 0.001;
		if (FULLhealthBar.visible == false) {
		if (healthBar.percent < 20 && !oneshot)
		{
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 3;
			if (swappedsides)
				healthTxt.color = FlxColor.LIME;
			else
				healthTxt.color = FlxColor.RED;
		}
		else if (healthBar.percent < 80 || oneshot)
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
			healthTxt.color = FlxColor.WHITE;		
		}

		if (healthBar.percent > 80)
		{
			iconP1.animation.curAnim.curFrame = 3;
			iconP2.animation.curAnim.curFrame = 1;
			if (swappedsides)
				healthTxt.color = FlxColor.RED;
			else
				healthTxt.color = FlxColor.LIME;
		}
		else if (healthBar.percent > 20)
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
			healthTxt.color = FlxColor.WHITE;
		}
		}

		if (misses == 0)
		{
			missesTxt.color = FlxColor.LIME;
		}
		else if (misses <= 5)
		{
			missesTxt.color = FlxColor.GREEN;
		}
		else if (misses <= 15)
		{
			missesTxt.color = FlxColor.CYAN;
		}
		else if (misses <= 30)
		{
			missesTxt.color = FlxColor.ORANGE;
		}
		else if (misses <= 50)
		{
			missesTxt.color = FlxColor.YELLOW;
		}
		else if (misses >= 50)
		{
			missesTxt.color = FlxColor.RED;
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2, SONG.player1));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000 * songMultiplier;

			curSongPos = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				// bf opponent for philly map camera fix thing yes
				if (curStage == 'philly' && dad.curCharacter == 'bf')
				{
					camFollow.x += 150;
				}
				if (curStage.startsWith('school') && dad.curCharacter == 'bf-pixel')
				{
					camFollow.x += 100;
					camFollow.y -= 150;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
				

				// pico player cam fix
				if (SONG.player1 == "pico" || SONG.player1 == "pico-pixel")
				{
					camFollow.x -= 150;
					if (curStage != 'school' && curStage != 'schoolEvil')
						camFollow.y += 80;
					else
						camFollow.y -= 50;
				}
				// senpai player cam fix
				if (SONG.player1.startsWith('senpai') || SONG.player1 == 'spirit')
				{
					camFollow.x -= 200;
					if (SONG.player1.startsWith('senpai'))
						camFollow.y -= 150;
					else
						camFollow.y += 150;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
			zoomTxtCams();
			noteCam.zoom = FlxMath.lerp(1, noteCam.zoom, 0.95);
			ratingCam.zoom = FlxMath.lerp(1, ratingCam.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET && !inCutscene)
		{
			pressedreset = true;
			if (!swappedsides)
				health = 0;
			else
				health = 2;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (((health <= 0 && !swappedsides) || (health >= 2 && swappedsides)) && (!praticemode || pressedreset))
		{
			boyfriend.stunned = true;
			pressedreset = false;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			deathCounter += 1;

			if (curPlayer.animation.getByName('deathLoop') == null)
			{
				FlxG.switchState(new AltGameOverScreen());
				FlxG.sound.play(Paths.sound('fnf_loss_sfx'));
			}
			else
			{
				openSubState(new GameOverSubstate(curPlayer.getScreenPosition().x, curPlayer.getScreenPosition().y));
			}
			

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			var deadRPC = GameOverSubstate.daBf;

			switch (deadRPC)
			{
				case 'bf' | 'bf-amogus':
					deadRPC += '-dead';
			}
			switch (SONG.player1)
			{
				case 'pico' | 'tankman' | 'monster' | 'gf' | 'tankmannoamongus' | 'mom' | 'senpai' | 'senpai-angry':
					deadRPC = SONG.player1 + '-dead';
				case 'monster-christmas' | 'gf-christmas':
					deadRPC = SONG.player1.replace('-christmas','') + '-dead';
				case 'mom-car':
					deadRPC = SONG.player1.replace('-car','') + '-dead';
			}
			if (OG.BSIDE)
			{
				deadRPC += '-bside';
			}
			
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + modeText + ") Misses: " + misses + " | Score: " + songScore + " | Health: " + healthTxt.text.substring(7) + " | Accuracy: " + accuracyTxt.text.substring(9) + " " + ratingTxt.text, deadRPC, player2RPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		#if desktop
		if (FlxG.sound.music.playing)
			@:privateAccess
			{
				lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);				
			if (vocals.playing)
				lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);
			}
		#end

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height && !FlxG.save.data.downscroll)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					if ((!daNote.mustPress && FlxG.save.data.enemystrums) || daNote.mustPress)
						daNote.visible = true;
					daNote.active = true;
				}

				var scrollspeed = SONG.speed;
				if (FlxG.save.data.overridespeed)
					scrollspeed = FlxG.save.data.scrollspeed;
				
				if (FlxG.save.data.downscroll)
				{
					if (daNote.mustPress)
						daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) / songMultiplier * FlxMath.roundDecimal(scrollspeed, 2));
					else
						daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) / songMultiplier * FlxMath.roundDecimal(scrollspeed, 2));
				}
				else
				{
					if (daNote.mustPress)
						daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) / songMultiplier * FlxMath.roundDecimal(scrollspeed, 2));
					else
						daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) / songMultiplier * FlxMath.roundDecimal(scrollspeed, 2));
				}
				daNote.y -= ((daNote.noteType == 'fire' || daNote.noteType == 'halo') ? ((daNote.noteType != 'halo' && FlxG.save.data.downscroll) ? 185 : 65 ) : 0);
				var middlescrollshit:Float = 2;
				if (FlxG.save.data.middlescroll && !daNote.mustPress)
				{
					middlescrollshit = 3.75;
					daNote.y += (((daNote.noteType == 'fire' || daNote.noteType == 'halo') && notestyle != 'pixel') ? (FlxG.save.data.downscroll ? 85 : 40) : (daNote.noteType == 'fire' && notestyle == 'pixel') ? (FlxG.save.data.downscroll ? 150 : 55) : 0);
				}

				if (FlxG.save.data.downscroll)
				{
					if (daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
					{
						daNote.y += daNote.prevNote.height;
						daNote.y -= 45;
						if (FlxG.save.data.middlescroll && !daNote.mustPress)
						{
							daNote.y += daNote.prevNote.height + 22;
						}
					}
					if (botplay && daNote.isSustainNote && daNote.mustPress)
					{
						var swagRect = new FlxRect(0, 0, daNote.frameWidth * middlescrollshit, daNote.frameHeight * middlescrollshit);
						swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
						swagRect.y = daNote.frameHeight - swagRect.height;

						daNote.clipRect = swagRect;
					}
					else if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) 
					&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2) && daNote.isSustainNote)
					{
						var swagRect = new FlxRect(0, 0, daNote.frameWidth * middlescrollshit, daNote.frameHeight * middlescrollshit);
						swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
						swagRect.y = daNote.frameHeight - swagRect.height;

						daNote.clipRect = swagRect;
					}
				}
				else
				{
					if (daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null && FlxG.save.data.middlescroll && !daNote.mustPress)
					{
						daNote.y -= daNote.prevNote.height;
						if (notestyle == 'pixel')
							daNote.y += 15;
					}
					if (botplay && daNote.isSustainNote && daNote.mustPress)
					{
						var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * middlescrollshit, daNote.height * middlescrollshit);
						swagRect.y /= daNote.scale.y;
						swagRect.height -= swagRect.y;

						daNote.clipRect = swagRect;
					}
					else if (daNote.isSustainNote
						&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * middlescrollshit, daNote.height * middlescrollshit);
						swagRect.y /= daNote.scale.y;
						swagRect.height -= swagRect.y;

						daNote.clipRect = swagRect;
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && ((daNote.noteType != 'fire' && daNote.noteType != 'halo' && daNote.noteType != 'poison') || SONG.player2badnotes))
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					if (FlxG.save.data.enemyextraeffects && !daNote.isSustainNote)
						EnemypopUpScore(daNote);
					
					if (FlxG.save.data.enemyhitsounds && !daNote.isSustainNote)
						FlxG.sound.play(Paths.sound('enemyhitsound'));

					if (daNote.noteType == 'stun' && !daNote.isSustainNote)
					{
						if (curEnemy.animation.getByName("avoid") != null)
							curEnemy.playAnim("avoid", true);
					}
					else if (daNote.noteType == 'warning' && curEnemy.animation.getByName("avoid") != null)
						curEnemy.playAnim("avoid", true);
					else if (daNote.noteType == 'poisonmusthit' && curEnemy.animation.getByName("avoid") != null)
						curEnemy.playAnim("avoid", true);

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							if (SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 0 || ((SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 2 || SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == null) && !swappedsides) || (SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 1 && swappedsides))
								altAnim = '-alt';
					}

					if (daNote.altNote)
					{
						altAnim = '-alt';
					}
					if (curEnemy.animation.curAnim.name != 'avoid') {
					switch (Math.abs(daNote.noteData))
					{
						case 0:
							curEnemy.playAnim('singLEFT' + altAnim, true);
						case 1:
							curEnemy.playAnim('singDOWN' + altAnim, true);
						case 2:
							curEnemy.playAnim('singUP' + altAnim, true);
						case 3:
							curEnemy.playAnim('singRIGHT' + altAnim, true);
					}
					}
					player2Strums.forEach(function(spr:FlxSprite)
					{
						if (!swappedsides)
							pressArrow(spr, spr.ID, daNote);
					});
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (swappedsides)
							pressArrow(spr, spr.ID, daNote);
					});

					curEnemy.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				if (daNote.mustPress && daNote.wasGoodHit && daNote.noteType != 'fire' && daNote.noteType != 'halo' && daNote.noteType != 'poison' && botplay)
				{
					if (camZooming)
					{
						ScoreTxtCam.zoom += 0.015 / songMultiplier;
						ScoreTxtCam.zoom = FlxMath.lerp(1, ScoreTxtCam.zoom, 0.95);
						if (health < 2)
						{
							HealthTxtCam.zoom += 0.015 / songMultiplier;
							HealthTxtCam.zoom = FlxMath.lerp(1, HealthTxtCam.zoom, 0.95);
						}
						if (accuracyTxt.text != "Accuracy:100%") 
						{
							AccuracyTxtCam.zoom += 0.015 / songMultiplier;
							AccuracyTxtCam.zoom = FlxMath.lerp(1, AccuracyTxtCam.zoom, 0.95);
						}
					}
					if (!daNote.isSustainNote)
					{
						popUpScore(daNote);
						combo += 1;
						goodnotes++;
						if (FlxG.save.data.hitsounds)
							FlxG.sound.play(Paths.sound('hitsound'));
						if (daNote.sustainLength > 0)
							sustainLength = daNote.sustainLength / Conductor.stepCrochet;
					}
					else
					{
						goodnotes += 1 / sustainLength;
						var score:Int = 50;
						score = Std.int(score / (Conductor.safeFrames / 10));
						switch (daRating)
						{
							case 'good':
								score = 35;
								score = Std.int(score / (Conductor.safeFrames / 10));
							case 'bad':
								score = 20;
								score = Std.int(score * (Conductor.safeFrames / 10));
							case 'shit':
								score = 5;
								score = Std.int(score * (Conductor.safeFrames / 10));
						}
						if (songMultiplier >= 1.05)
							score = Std.int(getRatesScore(songMultiplier, score));

						songScore += score;
					}
					if (daNote.isSustainNote && daNote.noteType == 'stun')
					{
						var camx = camFollow.x;
						FlxTween.tween(camFollow, {x: camx+100}, 0.3, {ease:FlxEase.sineOut,type:FlxTweenType.BACKWARD});
						FlxG.camera.shake(0.01, 0.15);
						FlxG.camera.scroll.x += 30;
					}
					if (daNote.noteType == 'stun')
					{
						FlxG.sound.play(Paths.sound("noteTypes/laser"), 1);
						var camx = camFollow.x;
						FlxTween.tween(camFollow, {x: camx+100}, 0.3, {ease:FlxEase.sineOut,type:FlxTweenType.BACKWARD});
						FlxG.camera.shake(0.01, 0.15);
						FlxG.camera.scroll.x += 30;
						if (curPlayer.animation.getByName("avoid") != null)
							curPlayer.playAnim("avoid", true);
					}
					else if (daNote.noteType == 'warning' && curPlayer.animation.getByName("avoid") != null)
					{
						curPlayer.playAnim("avoid", true);
					}
					else if (daNote.noteType == 'poisonmusthit' && curPlayer.animation.getByName("avoid") != null)
					{
						curPlayer.playAnim("avoid", true);
					}
					if (camZooming) {
					switch (daRating)
					{
						case 'sick':
							SicksTxtCam.zoom += 0.015 / songMultiplier;
							SicksTxtCam.zoom = FlxMath.lerp(1, SicksTxtCam.zoom, 0.95);
						case 'good':
							GoodsTxtCam.zoom += 0.015 / songMultiplier;
							GoodsTxtCam.zoom = FlxMath.lerp(1, GoodsTxtCam.zoom, 0.95);
						case 'bad':
							BadsTxtCam.zoom += 0.015 / songMultiplier;
							BadsTxtCam.zoom = FlxMath.lerp(1, BadsTxtCam.zoom, 0.95);
						case 'shit':
							ShitsTxtCam.zoom += 0.015 / songMultiplier;
							ScoreTxtCam.zoom = FlxMath.lerp(1, ScoreTxtCam.zoom, 0.95);
					}
					}

					if (daNote.isSustainNote) {
						switch (daRating)
						{
							case 'sick':
								if (!swappedsides)
									health += 0.0115 * gainmultiplier;
								else
									health -= 0.0115 * gainmultiplier;
							case 'good':
								if (!swappedsides)
									health += 0.009 * gainmultiplier;
								else
									health -= 0.009 * gainmultiplier;
							case 'bad':
								if (!swappedsides)
									health += 0.0065 * gainmultiplier;
								else
									health -= 0.0065 * gainmultiplier;
							case 'shit':
								if (!swappedsides)
									health += 0.0035 * gainmultiplier;
								else
									health -= 0.0035 * gainmultiplier;
							default:
								if (!swappedsides)
									health += 0.0115 * gainmultiplier;
								else
									health -= 0.0115 * gainmultiplier;
						}
					}
					else {
						switch (daRating)
						{
							case 'sick':
								if (!swappedsides)
									health += 0.023 * gainmultiplier;
								else
									health -= 0.023 * gainmultiplier;
							case 'good':
								if (!swappedsides)
									health += 0.018 * gainmultiplier;
								else
									health -= 0.018 * gainmultiplier;
							case 'bad':
								if (!swappedsides)
									health += 0.012 * gainmultiplier;
								else
									health -= 0.012 * gainmultiplier;
							case 'shit':
								if (!swappedsides)
									health += 0.005 * gainmultiplier;
								else
									health -= 0.005 * gainmultiplier;
							default:
								if (!swappedsides)
									health += 0.023 * gainmultiplier;
								else
									health -= 0.023 * gainmultiplier;
						}
					}
						
					
					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							if (SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 0 || (SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 1 && !swappedsides) || ((SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 2 || SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == null) && swappedsides))
								altAnim = '-alt';
					}

					if (daNote.altNote)
					{
						altAnim = '-alt';
					}
					if (curPlayer.color != FlxColor.WHITE)
						curPlayer.color = FlxColor.WHITE;
					if (!curPlayer.animation.curAnim.name.startsWith('hair') && curPlayer.animation.curAnim.name != 'avoid')
					{
						switch (daNote.noteData)
						{
							case 0:
								curPlayer.playAnim('singLEFT' + altAnim, true);
							case 1:
								curPlayer.playAnim('singDOWN' + altAnim, true);
							case 2:
								curPlayer.playAnim('singUP' + altAnim, true);
							case 3:
								curPlayer.playAnim('singRIGHT' + altAnim, true);
						}
					}

					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (!swappedsides)
							pressArrow(spr, spr.ID, daNote, true);
					});
					player2Strums.forEach(function(spr:FlxSprite)
					{
						if (swappedsides)
							pressArrow(spr, spr.ID, daNote, true);
					});

					curPlayer.holdTimer = 0;

					//daNote.wasGoodHit = true;
					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				player2Strums.forEach(function(spr:FlxSprite)
				{
					if ((spr.animation.curAnim.name == 'confirm' || spr.animation.curAnim.name == 'ugh' || spr.animation.curAnim.name == 'aaa') && notestyle != 'pixel')
					{
						spr.centerOffsets();
						if (FlxG.save.data.middlescroll)
						{
							spr.offset.x -= 13 * 1.75;
							spr.offset.y -= 13 * 1.75;
						}
						else
						{
							spr.offset.x -= 13;
							spr.offset.y -= 13;
						}
					}
					else
						spr.centerOffsets();
				});
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if ((spr.animation.curAnim.name == 'confirm' || spr.animation.curAnim.name == 'ugh' || spr.animation.curAnim.name == 'aaa') && notestyle != 'pixel')
					{
						spr.centerOffsets();
						if (FlxG.save.data.middlescroll)
						{
							spr.offset.x -= 13 * 1.75;
							spr.offset.y -= 13 * 1.75;
						}
						else
						{
							spr.offset.x -= 13;
							spr.offset.y -= 13;
						}
					}
					else
						spr.centerOffsets();
				});

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * SONG.speed));
				if ((FlxG.save.data.downscroll ? daNote.y > FlxG.height : daNote.y < -daNote.height) && daNote.mustPress && !botplay)
				{
					if ((daNote.tooLate || !daNote.wasGoodHit) && daNote.noteType != 'fire' && daNote.noteType != 'halo' && daNote.noteType != 'poison')
					{
						if (camZooming)
						{
							ScoreTxtCam.zoom += 0.015 / songMultiplier;
							ScoreTxtCam.zoom = FlxMath.lerp(1, ScoreTxtCam.zoom, 0.95);
							if (health < 2)
							{
								HealthTxtCam.zoom += 0.015 / songMultiplier;
								HealthTxtCam.zoom = FlxMath.lerp(1, HealthTxtCam.zoom, 0.95);
							}
							if (accuracyTxt.text != "Accuracy:100%") 
							{
								AccuracyTxtCam.zoom += 0.015 / songMultiplier;
								AccuracyTxtCam.zoom = FlxMath.lerp(1, AccuracyTxtCam.zoom, 0.95);
							}
							if (!daNote.isSustainNote || (daNote.isSustainNote && combo > 0)) {
							MissesTxtCam.zoom += 0.015 / songMultiplier;
							MissesTxtCam.zoom = FlxMath.lerp(1, MissesTxtCam.zoom, 0.95);
							}
						}
						if (daNote.noteType == 'warning')
						{
							if (!daNote.prevNote.noteEffect)
								if (swappedsides)
									health += 1;
								else
									health -= 1;
								daNote.noteEffect = true;
								daNote.prevNote.noteEffect = true;
								if (curPlayer.animation.getByName("hit") != null)
									curPlayer.playAnim("hit", true);
						}
						else if (daNote.noteType == 'stun')
						{
							if (!swappedsides)
								health = 0;
							else
								health = 2;
						}
						else if (daNote.noteType == 'poisonmusthit')
						{
							if (!daNote.prevNote.noteEffect)
								HealthDrain();

								daNote.noteEffect = true;
								daNote.prevNote.noteEffect = true;
						}
						else
						{
							if (FlxG.save.data.disabledmissstun)
								if (swappedsides)
									health += 0.095 * losemultiplier;
								else
									health -= 0.095 * losemultiplier;
							else
								if (swappedsides)
									health += 0.0475 * losemultiplier;
								else
									health -= 0.0475 * losemultiplier;
							
						}					

						if (combo > 5 && gf.animOffsets.exists('sad'))
						{
							gf.playAnim('sad');
						}
						
						vocals.volume = 0;
						if (!daNote.isSustainNote || (daNote.isSustainNote && combo > 0))
							misses++;
						
						if (combo > 0)
						{
							combo = 0;
							popUpCombo();
						}
						else if (!daNote.isSustainNote)
						{
							combo--;
							popUpCombo();
						}

						if (daNote.isSustainNote)
							songScore -= 20;
						else
							songScore -= 100;

						if (FlxG.save.data.disabledmissstun)
						{
							if (FlxG.save.data.misssounds)
								FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

							if (!curPlayer.animation.curAnim.name.startsWith('hair') && curPlayer.animation.curAnim.name != 'hit')
							{
								var misstxt:String = '';
								if (curPlayer.animation.getByName('singRIGHTmiss') == null)
									curPlayer.color = 0xCFAFFF;
								else
									misstxt = 'miss';

								switch(Math.abs(daNote.noteData))
								{
									case 0:
										curPlayer.playAnim('singLEFT' + misstxt, true);
									case 1:
										curPlayer.playAnim('singDOWN' + misstxt, true);
									case 2:
										curPlayer.playAnim('singUP' + misstxt, true);
									case 3:
										curPlayer.playAnim('singRIGHT' + misstxt, true);
								}									
							}
						}
					}
					else if ((daNote.noteType == 'fire' || daNote.noteType == 'halo' || daNote.noteType == 'poison') && (daNote.tooLate || !daNote.wasGoodHit) && !curPlayer.animation.curAnim.name.startsWith('sing') && curPlayer.animation.getByName("avoid") != null)
					{
						curPlayer.playAnim("avoid", true);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		player2Strums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.finished && (!swappedsides || botplay))
			{
				spr.animation.play('static');
				spr.centerOffsets();
			}
		});
		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.finished && (swappedsides || botplay))
			{
				spr.animation.play('static');
				spr.centerOffsets();
			}
		});

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}
	/*
	function sustain2(strum:Int, spr:FlxSprite, note:Note, ?bot:Bool = false):Void
	{
		var length:Float = note.sustainLength;

		if (length > 0)
		{
			if ((bot && !swappedsides) || (!bot && swappedsides))
				strumming1[strum] = true;
			else if ((bot && swappedsides) || (!bot && !swappedsides))
				strumming2[strum] = true;
		}

		var bps:Float = Conductor.bpm / 60;
		var spb:Float = 1 / bps;

		if (!note.isSustainNote)
		{
			timer = new FlxTimer();
			timer.start(length == 0 ? 0.2 : (length / songMultiplier / Conductor.crochet * spb) + 0.1, function(tmr:FlxTimer)
			{
				if ((!strumming2[strum] && (((!bot && !swappedsides) || (bot && swappedsides))) || (!strumming1[strum] && ((!bot && swappedsides) || (bot && !swappedsides))))) //my brain exploded while making this send prayers
				{
					spr.animation.play("static", true);
					spr.centerOffsets();
				}
				else
				{
					if ((bot && !swappedsides) || (!bot && swappedsides))
						strumming1[strum] = false;
					else if (bot && swappedsides || (!bot && !swappedsides))
						strumming2[strum] = false;
					spr.animation.play("static", true);
					spr.centerOffsets();
				}
			});
		}
	}
	*/
	function pressArrow(spr:FlxSprite, idCheck:Int, daNote:Note, ?bot:Bool = false)
	{
		if (Math.abs(daNote.noteData) == idCheck)
		{
			if (daNote.altNote)
			{
				switch (SONG.song.toLowerCase())
				{
					case 'ugh' | 'high effort ugh':
						if (idCheck == 2 || idCheck == 0)
							spr.animation.play('ugh', true);
					case 'no among us' | 'h.e. no among us':
						if (idCheck == 2 || idCheck == 0)
							spr.animation.play('aaa', true);
					default:
						spr.animation.play('confirm', true);
				}
			}
			else
				spr.animation.play('confirm', true);
		}
	}
	
	function toggleTxtCams(value:Bool)
	{
		ScoreTxtCam.visible = value;
		ShitsTxtCam.visible = value;
		BadsTxtCam.visible = value;
		GoodsTxtCam.visible = value;
		SicksTxtCam.visible = value;
		RatingTxtCam.visible = value;
		AccuracyTxtCam.visible = value;
		MissesTxtCam.visible = value;
		HealthTxtCam.visible = value;
	}
	function createTxtCams()
	{
		ScoreTxtCam = new FlxCamera();
		ScoreTxtCam.bgColor.alpha = 0;
		ShitsTxtCam = new FlxCamera();
		ShitsTxtCam.bgColor.alpha = 0;
		BadsTxtCam = new FlxCamera();
		BadsTxtCam.bgColor.alpha = 0;
		GoodsTxtCam = new FlxCamera();
		GoodsTxtCam.bgColor.alpha = 0;
		SicksTxtCam = new FlxCamera();
		SicksTxtCam.bgColor.alpha = 0;
		RatingTxtCam = new FlxCamera();
		RatingTxtCam.bgColor.alpha = 0;
		AccuracyTxtCam = new FlxCamera();
		AccuracyTxtCam.bgColor.alpha = 0;
		MissesTxtCam = new FlxCamera();
		MissesTxtCam.bgColor.alpha = 0;
		HealthTxtCam = new FlxCamera();
		HealthTxtCam.bgColor.alpha = 0;
	}
	function setAlphaTxtCams(value:Float)
	{
		ScoreTxtCam.alpha = value;
		ShitsTxtCam.alpha = value;
		BadsTxtCam.alpha = value;
		GoodsTxtCam.alpha = value;
		SicksTxtCam.alpha = value;
		RatingTxtCam.alpha = value;
		AccuracyTxtCam.alpha = value;
		MissesTxtCam.alpha = value;
		HealthTxtCam.alpha = value;
	}
	function tweenAlphaTxtCams(value:Float, value2:Float)
	{
		FlxTween.tween(ScoreTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
		FlxTween.tween(ShitsTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
		FlxTween.tween(BadsTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
		FlxTween.tween(GoodsTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
		FlxTween.tween(SicksTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
		FlxTween.tween(RatingTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
		FlxTween.tween(AccuracyTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
		FlxTween.tween(MissesTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
		FlxTween.tween(HealthTxtCam, {alpha: value}, value2, {ease: FlxEase.expoInOut});
	}

	function zoomTxtCams() 
	{
		ScoreTxtCam.zoom = FlxMath.lerp(1, ScoreTxtCam.zoom, 0.95);
		ShitsTxtCam.zoom = FlxMath.lerp(1, ShitsTxtCam.zoom, 0.95);
		BadsTxtCam.zoom = FlxMath.lerp(1, BadsTxtCam.zoom, 0.95);
		GoodsTxtCam .zoom= FlxMath.lerp(1, GoodsTxtCam.zoom, 0.95);
		SicksTxtCam.zoom = FlxMath.lerp(1, SicksTxtCam.zoom, 0.95);
		RatingTxtCam.zoom = FlxMath.lerp(1, RatingTxtCam.zoom, 0.95);
		AccuracyTxtCam.zoom = FlxMath.lerp(1, AccuracyTxtCam.zoom, 0.95);
		MissesTxtCam.zoom = FlxMath.lerp(1, MissesTxtCam.zoom, 0.95);
		HealthTxtCam.zoom = FlxMath.lerp(1, HealthTxtCam.zoom, 0.95);
	}

	function addZoomTxtCams()
	{
		ScoreTxtCam.zoom += 0.03 / songMultiplier;
		ShitsTxtCam.zoom += 0.03 / songMultiplier;
		BadsTxtCam.zoom += 0.03 / songMultiplier;
		GoodsTxtCam.zoom += 0.03 / songMultiplier;
		SicksTxtCam.zoom += 0.03 / songMultiplier;
		RatingTxtCam.zoom += 0.03 / songMultiplier;
		AccuracyTxtCam.zoom += 0.03 / songMultiplier;
		MissesTxtCam.zoom += 0.03 / songMultiplier;
		HealthTxtCam.zoom += 0.03 / songMultiplier;
	}

	function endSong():Void
	{
		deathCounter = 0;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore && !praticemode && !botplay)
		{
			#if !switch
				Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}
		OG.currentCutsceneEnded = false;

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
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

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				if (FlxG.save.data.menutransitions)
					FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width}, 1, {ease: FlxEase.quadIn });
				FlxG.switchState(new StoryMenuState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore && !praticemode && !botplay)
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';
				
				if (storyDifficulty == 3)
					difficulty = '-hardplus';
				var lastCharacter:String = SONG.player1;
				var lastEnemy:String = SONG.player2;
				trace('LOADING NEXT SONG');
				trace(storyPlaylist[0].toLowerCase() + difficulty);
				

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;
					ScoreTxtCam.visible = false;
					noteCam.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				var bsidecrap:String = '';
				if (OG.BSIDE)
					bsidecrap = 'b-side/';

				SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase() + difficulty, bsidecrap + storyPlaylist[0]);
				if (!lastCharacter.startsWith("bf"))
					SONG.player1 = lastCharacter;
				if (lastEnemy != SONG.player2)
					SONG.player2 = lastEnemy;
					
				FlxG.sound.music.stop();
				if (FlxG.save.data.menutransitions)
					FlxTween.tween(FlxG.camera, { zoom: 0.5, x: FlxG.width * -1}, 1, {ease: FlxEase.quadIn });
				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
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
			if (FlxG.save.data.menutransitions)
				FlxTween.tween(FlxG.camera, { zoom: 0.5, y: FlxG.width}, 1, {ease: FlxEase.quadIn });
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;
	var currentTimingShown:FlxText = null;
	var timeShown:Int = 0;

	public function getRatesScore(rate:Float, score:Float):Float
	{
		var rateX:Float = 1;
		var lastScore:Float = score;
		var pr =  rate - 0.05;
		if (pr < 1.00)
			pr = 1;
		
		while(rateX <= pr)
		{
			if (rateX > pr)
				break;
			lastScore = score + ((lastScore * rateX) * 0.022);
			rateX += 0.05;
		}

		var actualScore = Math.round(score + (Math.floor((lastScore * pr)) * 0.022));

		return actualScore;
	}
	var daRating:String = "";
	private function popUpScore(note:Note):Void
	{
		var noteDiff:Float = (note.strumTime - Conductor.songPosition) / songMultiplier;
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;
		score = Std.int(score / (Conductor.safeFrames / 10));

		daRating = "sick";
		if (!botplay) {
		if (FlxG.save.data.newhittimings)
		{
			if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.8)
			{
				daRating = 'shit';
				score = 50;
				score = Std.int(score * (Conductor.safeFrames / 10));
				shits++;
			}
			else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.575)
			{
				daRating = 'bad';
				score = 100;
				score = Std.int(score * (Conductor.safeFrames / 10));
				bads++;
			}
			else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.325)
			{
				daRating = 'good';
				score = 200;
				score = Std.int(score / (Conductor.safeFrames / 10));
				goods++;
			}
		}
		else
		{
			if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.9)
			{
				daRating = 'shit';
				score = 50;
				score = Std.int(score * (Conductor.safeFrames / 10));
				shits++;
			}
			else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.75)
			{
				daRating = 'bad';
				score = 100;
				score = Std.int(score * (Conductor.safeFrames / 10));
				bads++;
			}
			else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.2)
			{
				daRating = 'good';
				score = 200;
				score = Std.int(score / (Conductor.safeFrames / 10));
				goods++;
			}
		}
		}
		else
			noteDiff *= songMultiplier;
		

		if (daRating == 'sick')
		{
			if (FlxG.save.data.notesplashes)
			{
				if (notestyle == 'pixel')
				{
					var noteSplash = grpPixelNoteSplashes.recycle(PixelNoteSplash);
					if (swappedsides)
						noteSplash.setupNoteSplash(player2Strums.members[note.noteData].x, player2Strums.members[note.noteData].y, note.noteData);
					else
						noteSplash.setupNoteSplash(playerStrums.members[note.noteData].x, playerStrums.members[note.noteData].y, note.noteData);
					grpPixelNoteSplashes.add(noteSplash);
				}
				else
				{
					var noteSplash = grpNoteSplashes.recycle(NoteSplash);
					if (swappedsides)
						noteSplash.setupNoteSplash(player2Strums.members[note.noteData].x, player2Strums.members[note.noteData].y, note.noteData);
					else
						noteSplash.setupNoteSplash(playerStrums.members[note.noteData].x, playerStrums.members[note.noteData].y, note.noteData);
					grpNoteSplashes.add(noteSplash);
				}
			}
			
			sicks++;
		}

		if (songMultiplier >= 1.05)
			score = Std.int(getRatesScore(songMultiplier, score));

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';
		var sussy:String = '';
		var color:String = '';
		var bside:String = '';

		if (notestyle == 'pixel')
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		if (curStage.startsWith('amogus'))
		{
			if (daRating == 'bad' || daRating == 'shit')
				sussy = 'sus';
		}

		if (FlxG.save.data.colorratings)
		{
			color = 'COLOR';
		}

		if (OG.BSIDE)
		{
			bside = '-bside';
		}

		if (FlxG.save.data.cleanmode && daRating == 'shit' && sussy != 'sus')
			rating.loadGraphic(Paths.image(pixelShitPart1 + color + 'terrible' + pixelShitPart2));
		else if (daRating == 'sick' || daRating == 'good')
			rating.loadGraphic(Paths.image(pixelShitPart1 + color + daRating + bside + pixelShitPart2));
		else
			rating.loadGraphic(Paths.image(pixelShitPart1 + color + sussy + daRating + pixelShitPart2));
		rating.screenCenter();
		if (FlxG.save.data.ratingsfollowcamera)
		{
			rating.x = coolText.x - 125;
			rating.y -= 50;
			if (swappedsides && !FlxG.save.data.middlescroll)
				rating.x -= 525;
			if (FlxG.save.data.middlescroll)
			{
				if (!swappedsides)
					rating.x += 325;
				else
					rating.x -= 425;
			} 
		}
		else
		{
			rating.x = coolText.x - 40;
			rating.y -= 60;
			if (swappedsides)
				rating.x -= 175;
			if (FlxG.save.data.enemyextraeffects && !swappedsides)
				rating.x += 125;
		}
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var msTiming = CoolUtil.truncateFloat(noteDiff, 3);
		if (botplay) {
		var randomMs = FlxG.random.float(0,100);
		if (randomMs >= 12.5)
			msTiming = 0;
		else if (randomMs >= 6.25)
			msTiming = 1;
		else
			msTiming = -1;
		}

		if (currentTimingShown != null)
			remove(currentTimingShown);

		currentTimingShown = new FlxText(0, 0, 0, "0ms");
		timeShown = 0;
		switch (daRating)
		{
			case 'shit':
				if (FlxG.save.data.colorratings)
					currentTimingShown.color = FlxColor.RED;
				else
					currentTimingShown.color = 0xFF8B8B8B;
			case 'bad':
				if (FlxG.save.data.colorratings)
					currentTimingShown.color = 0xFFC46060;
				else
					currentTimingShown.color = 0xFFC4C4C4;
			case 'good':
				if (FlxG.save.data.colorratings)
					currentTimingShown.color = FlxColor.GREEN;
				else
					currentTimingShown.color = FlxColor.WHITE;
			case 'sick':
				if (FlxG.save.data.colorratings)
					currentTimingShown.color = FlxColor.CYAN;
				else
					currentTimingShown.color = FlxColor.WHITE;
		}
		currentTimingShown.borderStyle = OUTLINE;
		currentTimingShown.borderSize = 1;
		currentTimingShown.borderColor = FlxColor.BLACK;
		currentTimingShown.text = msTiming + "ms";
		currentTimingShown.size = 20;

		if (currentTimingShown.alpha != 1)
			currentTimingShown.alpha = 1;

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = rating.x;
		comboSpr.y = rating.y + 100;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		currentTimingShown.screenCenter();
		currentTimingShown.x = comboSpr.x + 100;
		currentTimingShown.y = rating.y + 100;
		currentTimingShown.acceleration.y = 600;
		currentTimingShown.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		if (FlxG.save.data.ratingsfollowcamera)
		{
			rating.cameras = [ratingCam];
		}
		currentTimingShown.cameras = [ratingCam];
		if (!noteCam.visible)
		{
			rating.alpha = 0;
			currentTimingShown.alpha = 0;
		}
		add(rating);
		if (FlxG.save.data.milliseconds)
			add(currentTimingShown);

		if (notestyle != 'pixel')
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}
		currentTimingShown.updateHitbox();
		comboSpr.updateHitbox();
		rating.updateHitbox();

		popUpCombo();

		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		//coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * songMultiplier * 0.001,
			onUpdate: function(tween:FlxTween)
			{
				if (currentTimingShown != null)
					currentTimingShown.alpha -= 0.02;
				timeShown++;
			}
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();

				if (currentTimingShown != null && timeShown >= 20)
				{
					remove(currentTimingShown);
					currentTimingShown = null;
				}
			},
			startDelay: Conductor.crochet * songMultiplier * 0.001
		});

		curSection += 1;
	}

	private function popUpCombo():Void
	{		
		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';

		if (notestyle == 'pixel')
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}
		
		var rating:FlxSprite = new FlxSprite();
		if (daRating == "")
			daRating = "sick";
		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		if (FlxG.save.data.ratingsfollowcamera)
		{
			rating.x = FlxG.width * 0.55 - 125;
			rating.y -= 50;
			if (swappedsides && !FlxG.save.data.middlescroll)
				rating.x -= 525;
			if (FlxG.save.data.middlescroll)
			{
				if (!swappedsides)
					rating.x += 325;
				else
					rating.x -= 425;
			} 
		}
		else
		{
			rating.x = FlxG.width * 0.55 - 40;
			rating.y -= 60;
			if (swappedsides)
				rating.x -= 175;
			if (FlxG.save.data.enemyextraeffects && !swappedsides)
				rating.x += 125;
		}

		var seperatedScore:Array<Int> = [];
		/*
		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);
		*/
		var comboSplit:Array<String> = (Math.abs(combo) + "").split('');

		if (combo < 0)
			seperatedScore.push(-1);

		if (comboSplit.length == 1)
		{
			seperatedScore.push(0);
			seperatedScore.push(0);
		}
		else if (comboSplit.length == 2)
			seperatedScore.push(0);

		for (i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		if (combo < 0)
			daLoop--;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			if (combo == 69 || combo == 420) //if funny number
				numScore.color = FlxColor.YELLOW;
			else if (combo < 0)
				numScore.color = 0xFFC46060;
			else
				numScore.color = FlxColor.WHITE;
			if (FlxG.save.data.ratingsfollowcamera)
			{
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				if (combo < 0 && swappedsides && !FlxG.save.data.middlescroll)
					numScore.x += 43;
			}
			else
			{
				numScore.x = FlxG.width * 0.55 + (43 * daLoop) - 90;
				numScore.y += 80;
				if (swappedsides)
					numScore.x -= 175;
				if (FlxG.save.data.enemyextraeffects && !swappedsides)
					numScore.x += 125;
			}

			if (notestyle != 'pixel')
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (FlxG.save.data.ratingsfollowcamera)
			{
				numScore.cameras = [ratingCam];
			}
			if (!noteCam.visible)
				numScore.alpha = 0;
			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * songMultiplier * 0.002
			});

			daLoop++;
		}
	}

	var EnemydaRating:String = "";
	var Enemycombo:Int = 0;
	var EnemytimeShown:Int = 0;
	var EnemycurrentTimingShown:FlxText = null;
	private function EnemypopUpScore(note:Note):Void
	{
		Enemycombo++;
		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();

		//var noteDiff:Float = (note.strumTime - Conductor.songPosition);

		EnemydaRating = "sick";
		

		if (FlxG.save.data.notesplashes && EnemydaRating == 'sick' && FlxG.save.data.enemystrums)
		{
			if (notestyle == 'pixel')
			{
				var noteSplash = grpPixelNoteSplashes.recycle(PixelNoteSplash);
				if (swappedsides)
					noteSplash.setupNoteSplash(playerStrums.members[note.noteData].x, playerStrums.members[note.noteData].y, note.noteData, false, FlxG.save.data.middlescroll);
				else
					noteSplash.setupNoteSplash(player2Strums.members[note.noteData].x, player2Strums.members[note.noteData].y, note.noteData, false, FlxG.save.data.middlescroll);
				grpPixelNoteSplashes.add(noteSplash);
			}
			else
			{
				var noteSplash = grpNoteSplashes.recycle(NoteSplash);
				if (swappedsides)
					noteSplash.setupNoteSplash(playerStrums.members[note.noteData].x, playerStrums.members[note.noteData].y, note.noteData, FlxG.save.data.middlescroll);
				else
					noteSplash.setupNoteSplash(player2Strums.members[note.noteData].x, player2Strums.members[note.noteData].y, note.noteData, FlxG.save.data.middlescroll);
				grpNoteSplashes.add(noteSplash);
			}
		}

		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';
		var sussy:String = '';
		var color:String = '';
		var bside:String = '';

		if (notestyle == 'pixel')
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		if (curStage.startsWith('amogus'))
		{
			if (EnemydaRating == 'bad' || EnemydaRating == 'shit')
				sussy = 'sus';
		}

		if (FlxG.save.data.colorratings)
		{
			color = 'COLOR';
		}

		if (OG.BSIDE)
		{
			bside = '-bside';
		}

		if (FlxG.save.data.cleanmode && EnemydaRating == 'shit' && sussy != 'sus')
			rating.loadGraphic(Paths.image(pixelShitPart1 + color + 'terrible' + pixelShitPart2));
		else if (EnemydaRating == 'sick' || EnemydaRating == 'good')
			rating.loadGraphic(Paths.image(pixelShitPart1 + color + EnemydaRating + bside + pixelShitPart2));
		else
			rating.loadGraphic(Paths.image(pixelShitPart1 + color + sussy + EnemydaRating + pixelShitPart2));
		rating.screenCenter();
		if (FlxG.save.data.ratingsfollowcamera)
		{
			rating.x = coolText.x - 125;
			rating.y -= 50;
			if (!swappedsides && !FlxG.save.data.middlescroll)
				rating.x -= 525;
			if (FlxG.save.data.middlescroll)
			{
				if (!swappedsides)
					rating.x -= 350;
				else
					rating.x += 250;
			} 
		}
		else
		{
			rating.x = coolText.x - 40;
			rating.y -= 60;
			if (!swappedsides)
				rating.x -= 175;
			else
				rating.x += 125;
		}
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		//var msTiming = CoolUtil.truncateFloat(noteDiff, 3);
		var msTiming:Float;
		var randomMs = FlxG.random.float(0,100);
		if (randomMs >= 12.5)
			msTiming = 0;
		else if (randomMs >= 6.25)
			msTiming = 1;
		else
			msTiming = -1;

		if (EnemycurrentTimingShown != null)
			remove(EnemycurrentTimingShown);

		EnemycurrentTimingShown = new FlxText(0, 0, 0, "0ms");
		EnemytimeShown = 0;
		switch (EnemydaRating)
		{
			case 'shit':
				if (FlxG.save.data.colorratings)
					EnemycurrentTimingShown.color = FlxColor.RED;
				else
					EnemycurrentTimingShown.color = 0xFF8B8B8B;
			case 'bad':
				if (FlxG.save.data.colorratings)
					EnemycurrentTimingShown.color = 0xFFC46060;
				else
					EnemycurrentTimingShown.color = 0xFFC4C4C4;
			case 'good':
				if (FlxG.save.data.colorratings)
					EnemycurrentTimingShown.color = FlxColor.GREEN;
				else
					EnemycurrentTimingShown.color = FlxColor.WHITE;
			case 'sick':
				if (FlxG.save.data.colorratings)
					EnemycurrentTimingShown.color = FlxColor.CYAN;
				else
					EnemycurrentTimingShown.color = FlxColor.WHITE;
		}
		EnemycurrentTimingShown.borderStyle = OUTLINE;
		EnemycurrentTimingShown.borderSize = 1;
		EnemycurrentTimingShown.borderColor = FlxColor.BLACK;
		EnemycurrentTimingShown.text = msTiming + "ms";
		EnemycurrentTimingShown.size = 20;

		if (EnemycurrentTimingShown.alpha != 1)
			EnemycurrentTimingShown.alpha = 1;

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = rating.x;
		comboSpr.y = rating.y + 100;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		EnemycurrentTimingShown.screenCenter();
		EnemycurrentTimingShown.x = comboSpr.x + 100;
		EnemycurrentTimingShown.y = rating.y + 100;
		EnemycurrentTimingShown.acceleration.y = 600;
		EnemycurrentTimingShown.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		if (FlxG.save.data.ratingsfollowcamera)
		{
			rating.cameras = [ratingCam];
		}
		EnemycurrentTimingShown.cameras = [ratingCam];
		if (!noteCam.visible)
		{
			rating.alpha = 0;
			EnemycurrentTimingShown.alpha = 0;
		}
		add(rating);
		if (FlxG.save.data.milliseconds)
			add(EnemycurrentTimingShown);

		if (notestyle != 'pixel')
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}
		EnemycurrentTimingShown.updateHitbox();
		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		/*
		seperatedScore.push(Math.floor(Enemycombo / 100));
		seperatedScore.push(Math.floor((Enemycombo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(Enemycombo % 10);
		*/
		var comboSplit:Array<String> = (Enemycombo + "").split('');

		if (comboSplit.length == 1)
		{
			seperatedScore.push(0);
			seperatedScore.push(0);
		}
		else if (comboSplit.length == 2)
			seperatedScore.push(0);

		for (i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			if (Enemycombo == 69 || Enemycombo == 420) //if funny number
				numScore.color = FlxColor.YELLOW;
			else
				numScore.color = FlxColor.WHITE;
			if (FlxG.save.data.ratingsfollowcamera)
			{
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
			}
			else
			{
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80;
				if (!swappedsides)
					numScore.x -= 175;
				else
					numScore.x += 125;
			}

			if (notestyle != 'pixel')
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (FlxG.save.data.ratingsfollowcamera)
			{
				numScore.cameras = [ratingCam];
			}
			if (!noteCam.visible)
				numScore.alpha = 0;
			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * songMultiplier * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * songMultiplier * 0.001,
			onUpdate: function(tween:FlxTween)
			{
				if (EnemycurrentTimingShown != null)
					EnemycurrentTimingShown.alpha -= 0.02;
				EnemytimeShown++;
			}
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();

				if (EnemycurrentTimingShown != null && EnemytimeShown >= 20)
				{
					remove(EnemycurrentTimingShown);
					EnemycurrentTimingShown = null;
				}
			},
			startDelay: Conductor.crochet * songMultiplier * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		if (botplay)
			controlArray = [];

		curPlayer = swappedsides ? dad : boyfriend;
		curEnemy = swappedsides ? boyfriend : dad;

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic && !botplay)
		{
			curPlayer.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			var directionList:Array<Int> = [];

			var dontCheck = false;

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);

					if (!directionList.contains(daNote.noteData))
					{
						directionList.push(daNote.noteData);
					}
				}
			});

			var dataNotes = [];
			for (i in possibleNotes) {
				switch (i.noteData)
				{
					// NOTES YOU ARE HOLDING
					case 0:
						if (left && !i.isSustainNote)
							dataNotes.push(i);
					case 1:
						if (down && !i.isSustainNote)
							dataNotes.push(i);
					case 2:
						if (up && !i.isSustainNote)
							dataNotes.push(i);
					case 3:
						if (right && !i.isSustainNote)
							dataNotes.push(i);
				}
			}

			if (dataNotes.length != 0)
			{
				var coolNote = null;

				for (i in dataNotes)
				{
					coolNote = i;
					break;
				}

				if (dataNotes.length > 1) // stacked notes or really close ones
				{
					for (i in 0...dataNotes.length)
					{
						if (i == 0)
							continue;

						var note = dataNotes[i];

						switch (note.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 0:
								if (!left)
									continue;
							case 1:
								if (!down)
									continue;
							case 2:
								if (!up)
									continue;
							case 3:
								if (!right)
									continue;
						}

						if (!note.isSustainNote && ((note.strumTime - coolNote.strumTime) < 2))
						{
							trace('found a stacked/really close note ' + (note.strumTime - coolNote.strumTime));
							note.kill();
							notes.remove(note, true);
							note.destroy();
						}
					}
				}
			}

			for (i in 0...controlArray.length)
			{
				if (controlArray[i] && !directionList.contains(i))
				{
					dontCheck = true;
				}
			}

			if (possibleNotes.length > 0 && !dontCheck)
			{
				var daNote = possibleNotes[0];
				var hit = [false,false,false,false];

				if (perfectMode)
					noteCheck(true, daNote);
				if (possibleNotes.length > 0 && FlxG.save.data.newhittimings)
				{
					for (coolNote in possibleNotes)
					{
						if (controlArray[coolNote.noteData] && !hit[coolNote.noteData])
						{
							hit[coolNote.noteData] = true;
							scoreTxt.color = FlxColor.WHITE;
							goodNoteHit(coolNote);
						}
					}
				}
				if (!FlxG.save.data.newhittimings) {
				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList && !FlxG.save.data.disabledmissstun)
									badNoteCheck();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
				}
				for (coolNote in possibleNotes)
				{
					if (controlArray[coolNote.noteData])
					{
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						if (coolNote.noteType == 'halo' && !swappedsides)
						{
							// lol death
							if (!swappedsides)
								health = 0;
							else
								health = 2;
							FlxG.sound.play(Paths.sound('noteTypes/death'));
							boyfriend.playAnim("hit", true);
						}
						else if (coolNote.noteType == 'fire')
						{
							songScore -= 50;
							if (swappedsides)
								health += 0.45 * losemultiplier;
							else
								health -= 0.45 * losemultiplier;
							coolNote.wasGoodHit = true;
							coolNote.canBeHit = false;
							coolNote.kill();
							notes.remove(coolNote, true);
							coolNote.destroy();
							FlxG.sound.play(Paths.sound('noteTypes/burnSound'));
							
							if (!swappedsides)
							{
								playerStrums.forEach(function(spr:FlxSprite)
								{
									if (controlArray[spr.ID] && spr.ID == coolNote.noteData)
									{
										var smoke:FlxSprite = new FlxSprite(spr.x - spr.width + 15, spr.y - spr.height);
										smoke.frames = Paths.getSparrowAtlas('noteTypes/Smoke');
										smoke.animation.addByPrefix('boom','smoke',24,false);
										smoke.animation.play('boom');
										smoke.setGraphicSize(Std.int(smoke.width * 0.6));
										smoke.cameras = [camHUD];
										add(smoke);
										smoke.animation.finishCallback = function(name:String) {
											remove(smoke);	
										}
									}
								});
								boyfriend.playAnim("hit", true);
							}
							else
							{
								player2Strums.forEach(function(spr:FlxSprite)
								{
									if (controlArray[spr.ID] && spr.ID == coolNote.noteData)
									{
										var smoke:FlxSprite = new FlxSprite(spr.x - spr.width + 15, spr.y - spr.height);
										smoke.frames = Paths.getSparrowAtlas('noteTypes/Smoke');
										smoke.animation.addByPrefix('boom','smoke',24,false);
										smoke.animation.play('boom');
										smoke.setGraphicSize(Std.int(smoke.width * 0.6));
										smoke.cameras = [camHUD];
										add(smoke);
										smoke.animation.finishCallback = function(name:String) {
											remove(smoke);	
										}
									}
								});
							}
						}
						else if (coolNote.noteType == 'poison')
						{
							songScore -= 50;
							HealthDrain();
						}
						else if (coolNote.noteType == 'stun')
						{
							songScore += 20;
							FlxG.sound.play(Paths.sound("noteTypes/laser"), 1);
							var camx = camFollow.x;
							FlxTween.tween(camFollow, {x: camx+100}, 0.3, {ease:FlxEase.sineOut,type:FlxTweenType.BACKWARD});
							FlxG.camera.shake(0.01, 0.15);
							FlxG.camera.scroll.x += 30;
							if (curPlayer.animation.getByName("avoid") != null)
								curPlayer.playAnim("avoid", true);
						}
						else if (coolNote.noteType == 'warning' && curPlayer.animation.getByName("avoid") != null)
						{
							songScore += 15;
							curPlayer.playAnim("avoid", true);
						}
						else if (coolNote.noteType == 'poisonmusthit' && curPlayer.animation.getByName("avoid") != null)
						{
							songScore += 10;
							curPlayer.playAnim("avoid", true);
						}
					}
				}
				/* 
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
				 */
				// trace(daNote.noteData);
				/* 
						switch (daNote.noteData)
						{
							case 2: // NOTES YOU JUST PRESSED
								if (upP || rightP || downP || leftP)
									noteCheck(upP, daNote);
							case 3:
								if (upP || rightP || downP || leftP)
									noteCheck(rightP, daNote);
							case 1:
								if (upP || rightP || downP || leftP)
									noteCheck(downP, daNote);
							case 0:
								if (upP || rightP || downP || leftP)
									noteCheck(leftP, daNote);
						}

					//this is already done in noteCheck / goodNoteHit
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				 */
			}
			else
			{
				if (!FlxG.save.data.disabledmissstun)
					badNoteCheck();
			}

			if (dontCheck && possibleNotes.length > 0 && FlxG.save.data.disabledmissstun)
			{
				if (mashViolations > 4)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					noteMiss(0, true);
				}
				else
					mashViolations++;
			}
		}

		if ((up || right || down || left) && !boyfriend.stunned && generatedMusic && !botplay)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (curPlayer.holdTimer > Conductor.stepCrochet * 4 * 0.001 && ((!up && !down && !right && !left) || botplay))
		{
			if (curPlayer.animation.curAnim.name.startsWith('sing') && !curPlayer.animation.curAnim.name.endsWith('miss') && curPlayer.color == FlxColor.WHITE && !curPlayer.animation.curAnim.name.endsWith('alt'))
			{
				curPlayer.playAnim('idle');
				if (curPlayer.curCharacter.startsWith('gf') || curPlayer.curCharacter.startsWith('spooky'))
					curPlayer.dance();
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (!swappedsides) {
			switch (spr.ID)
			{
				case 0:
					if (leftP && !botplay && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'ugh' && spr.animation.curAnim.name != 'aaa')
						spr.animation.play('pressed');
					if (leftR && !botplay)
						spr.animation.play('static');
				case 1:
					if (downP && !botplay && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR && !botplay)
						spr.animation.play('static');
				case 2:
					if (upP && !botplay && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'ugh' && spr.animation.curAnim.name != 'aaa')
						spr.animation.play('pressed');
					if (upR && !botplay)
						spr.animation.play('static');
				case 3:
					if (rightP && !botplay && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR && !botplay)
						spr.animation.play('static');
			}

			if ((spr.animation.curAnim.name == 'confirm' || spr.animation.curAnim.name == 'ugh' || spr.animation.curAnim.name == 'aaa') && notestyle != 'pixel')
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
			}
		});
		player2Strums.forEach(function(spr:FlxSprite)
		{
			if (swappedsides) {
			switch (spr.ID)
			{
				case 0:
					if (leftP && !botplay && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'ugh' && spr.animation.curAnim.name != 'aaa')
						spr.animation.play('pressed');
					if (leftR && !botplay)
						spr.animation.play('static');
				case 1:
					if (downP && !botplay && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR && !botplay)
						spr.animation.play('static');
				case 2:
					if (upP && !botplay && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'ugh' && spr.animation.curAnim.name != 'aaa')
						spr.animation.play('pressed');
					if (upR && !botplay)
						spr.animation.play('static');
				case 3:
					if (rightP && !botplay && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR && !botplay)
						spr.animation.play('static');
			}

			if ((spr.animation.curAnim.name == 'confirm' || spr.animation.curAnim.name == 'ugh' || spr.animation.curAnim.name == 'aaa') && notestyle != 'pixel')
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
			}
		});
	}

	function noteMiss(direction:Int = 1, mashmiss:Bool = false):Void
	{
		if (!boyfriend.stunned && !botplay)
		{
			if (mashmiss)
				if (swappedsides)
					health += 0.16;
				else
					health -= 0.16;
			else
				if (swappedsides)
					health += 0.04 * losemultiplier;
				else
					health -= 0.04 * losemultiplier;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			if (combo > 0)
				combo = 0;
			else
				combo--;
			popUpCombo();
			if (camZooming)
			{
				ScoreTxtCam.zoom += 0.015 / songMultiplier;
				ScoreTxtCam.zoom = FlxMath.lerp(1, ScoreTxtCam.zoom, 0.95);
				if (health < 2)
				{
					HealthTxtCam.zoom += 0.015 / songMultiplier;
					HealthTxtCam.zoom = FlxMath.lerp(1, HealthTxtCam.zoom, 0.95);
				}
			}

			if (praticemode == false)
				songScore -= 10;

			if (FlxG.save.data.misssounds)
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*
			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});
			*/

			if (!curPlayer.animation.curAnim.name.startsWith('hair'))
			{
				var misstxt:String = '';
				if (curPlayer.animation.getByName('singRIGHTmiss') == null)
					curPlayer.color = 0xCFAFFF;
				else
					misstxt = 'miss';
				switch (direction)
				{
					case 0:
						curPlayer.playAnim('singLEFT' + misstxt, true);
					case 1:
						curPlayer.playAnim('singDOWN' + misstxt, true);
					case 2:
						curPlayer.playAnim('singUP' + misstxt, true);
					case 3:
						curPlayer.playAnim('singRIGHT' + misstxt, true);
				}
			}
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (!botplay) {
		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
		}
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note, (mashing > getKeyPresses(note)));
		else
		{
			if (!FlxG.save.data.disabledmissstun)
				badNoteCheck();
		}
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that
		
		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		return possibleNotes.length;
	}
	var sustainLength:Float;
	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		if (!note.wasGoodHit && note.noteType != 'fire' && note.noteType != 'halo' && note.noteType != 'poison')
		{
			if (camZooming)
			{
				ScoreTxtCam.zoom += 0.015 / songMultiplier;
				ScoreTxtCam.zoom = FlxMath.lerp(1, ScoreTxtCam.zoom, 0.95);
				if (health < 2)
				{
					HealthTxtCam.zoom += 0.015 / songMultiplier;
					HealthTxtCam.zoom = FlxMath.lerp(1, HealthTxtCam.zoom, 0.95);
				}
				if (accuracyTxt.text != "Accuracy:100%") 
				{
					AccuracyTxtCam.zoom += 0.015 / songMultiplier;
					AccuracyTxtCam.zoom = FlxMath.lerp(1, AccuracyTxtCam.zoom, 0.95);
				}
			}
			if (mashing != 0)
				mashing = 0;
			if (!resetMashViolation && mashViolations >= 1)
				mashViolations--;
			if (mashViolations < 0)
				mashViolations = 0;

			if (!note.isSustainNote || combo <= 0)
			{
				if (note.sustainLength > 0)
					sustainLength = note.sustainLength / Conductor.stepCrochet;
				else
					sustainLength = 0;
				if (combo < 0)
					combo = 0;
				combo++; //add combo before showing combo because showing 0 combo doesnt make sense (plus it shows the actual combo, not the combo - 1)
				popUpScore(note);
				goodnotes++;
				if (FlxG.save.data.hitsounds)
					FlxG.sound.play(Paths.sound('hitsound'));
			}
			else
			{
				if (sustainLength > 0) //so accuracy doesnt break lmao
					goodnotes += 1 / sustainLength;
				var score:Int = 50;
				score = Std.int(score / (Conductor.safeFrames / 10));
				switch (daRating)
				{
					case 'good':
						score = 35;
						score = Std.int(score / (Conductor.safeFrames / 10));
					case 'bad':
						score = 20;
						score = Std.int(score * (Conductor.safeFrames / 10));
					case 'shit':
						score = 5;
						score = Std.int(score * (Conductor.safeFrames / 10));
				}
				if (songMultiplier >= 1.05)
					score = Std.int(getRatesScore(songMultiplier, score));

				songScore += score;
			}
			if (note.isSustainNote && note.noteType == 'stun')
			{
				var camx = camFollow.x;
				FlxTween.tween(camFollow, {x: camx+100}, 0.3, {ease:FlxEase.sineOut,type:FlxTweenType.BACKWARD});
				FlxG.camera.shake(0.01, 0.15);
				FlxG.camera.scroll.x += 30;
			}
			if (camZooming) {
			switch (daRating)
			{
				case 'sick':
					SicksTxtCam.zoom += 0.015 / songMultiplier;
					SicksTxtCam.zoom = FlxMath.lerp(1, SicksTxtCam.zoom, 0.95);
				case 'good':
					GoodsTxtCam.zoom += 0.015 / songMultiplier;
					GoodsTxtCam.zoom = FlxMath.lerp(1, GoodsTxtCam.zoom, 0.95);
				case 'bad':
					BadsTxtCam.zoom += 0.015 / songMultiplier;
					BadsTxtCam.zoom = FlxMath.lerp(1, BadsTxtCam.zoom, 0.95);
				case 'shit':
					ShitsTxtCam.zoom += 0.015 / songMultiplier;
					ScoreTxtCam.zoom = FlxMath.lerp(1, ScoreTxtCam.zoom, 0.95);
			}
			}

			if (note.isSustainNote) {
				switch (daRating)
				{
					case 'sick':
						if (!swappedsides)
							health += 0.0115 * gainmultiplier;
						else
							health -= 0.0115 * gainmultiplier;
					case 'good':
						if (!swappedsides)
							health += 0.009 * gainmultiplier;
						else
							health -= 0.009 * gainmultiplier;
					case 'bad':
						if (!swappedsides)
							health += 0.0065 * gainmultiplier;
						else
							health -= 0.0065 * gainmultiplier;
					case 'shit':
						if (!swappedsides)
							health += 0.0035 * gainmultiplier;
						else
							health -= 0.0035 * gainmultiplier;
					default:
						if (!swappedsides)
							health += 0.0115 * gainmultiplier;
						else
							health -= 0.0115 * gainmultiplier;
				}
			}
			else {
				switch (daRating)
				{
					case 'sick':
						if (!swappedsides)
							health += 0.023 * gainmultiplier;
						else
							health -= 0.023 * gainmultiplier;
					case 'good':
						if (!swappedsides)
							health += 0.018 * gainmultiplier;
						else
							health -= 0.018 * gainmultiplier;
					case 'bad':
						if (!swappedsides)
							health += 0.012 * gainmultiplier;
						else
							health -= 0.012 * gainmultiplier;
					case 'shit':
						if (!swappedsides)
							health += 0.005 * gainmultiplier;
						else
							health -= 0.005 * gainmultiplier;
					default:
						if (!swappedsides)
							health += 0.023 * gainmultiplier;
						else
							health -= 0.023 * gainmultiplier;
				}
			}
				
			
			var altAnim:String = "";

			if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].altAnim)
					if (SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 0 || (SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 1 && !swappedsides) || ((SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == 2 || SONG.notes[Math.floor(curStep / 16)].altAnimPlayer == null) && swappedsides))
						altAnim = '-alt';
			}

			if (note.altNote)
			{
				altAnim = '-alt';
			}
			if (curPlayer.color != FlxColor.WHITE)
				curPlayer.color = FlxColor.WHITE;
			if (!curPlayer.animation.curAnim.name.startsWith('hair'))
			{
				switch (note.noteData)
				{
					case 0:
						curPlayer.playAnim('singLEFT' + altAnim, true);
					case 1:
						curPlayer.playAnim('singDOWN' + altAnim, true);
					case 2:
						curPlayer.playAnim('singUP' + altAnim, true);
					case 3:
						curPlayer.playAnim('singRIGHT' + altAnim, true);
				}
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (!swappedsides)
					pressArrow(spr, spr.ID, note);
			});
			player2Strums.forEach(function(spr:FlxSprite)
			{
				if (swappedsides)
					pressArrow(spr, spr.ID, note);
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	function HealthDrain():Void
	{
		FlxG.sound.play(Paths.sound("noteTypes/BoomCloud"), 1);
		if (curPlayer.animation.getByName("hit") != null)
			curPlayer.playAnim("hit", true);

		FlxG.camera.zoom -= 0.02;
		if (camZooming)
		{
			HealthTxtCam.zoom += 0.030 / songMultiplier;
			HealthTxtCam.zoom = FlxMath.lerp(1, HealthTxtCam.zoom, 0.95);
		}
		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			curPlayer.playAnim("idle", true);
		});
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			if (swappedsides)
				health += 0.005;
			else
				health -= 0.005;
		}, 300);
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
			if (curPlayer.curCharacter.startsWith('gf'))
				curPlayer.playAnim('hairBlow');
				if (curPlayer.color != FlxColor.WHITE)
					curPlayer.color = FlxColor.WHITE;
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		if (curPlayer.curCharacter.startsWith('gf'))
			curPlayer.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		gf.playAnim('scared', true);
		if (boyfriend.curCharacter.startsWith("bf"))
			boyfriend.playAnim('scared', true);	
	}

	var tankAngle:Float = FlxG.random.int(-90, 45);

	function moveTank():Void
	{
		tankAngle += FlxG.elapsed * FlxG.random.float(5, 7) * songMultiplier;
        tank.angle = tankAngle - 90 + 15;
        tank.x = 400 + 1500 * FlxMath.fastCos(FlxAngle.asRadians(tankAngle + 180));
        tank.y = 1300 + 1100 * FlxMath.fastSin(FlxAngle.asRadians(tankAngle + 180));
	}

	function resetRunningTank(x:Float, y:Int, goingRight:Bool, spr:FlxSprite, tanknum:Int):Void
	{
    	spr.x = x;
    	spr.y = y;
    	tankGoingRight[tanknum] = goingRight;
    	endingOffset[tanknum] = FlxG.random.float(50, 200);
    	runningTankSpeed[tanknum] = FlxG.random.float(0.6, 1);
     	spr.flipX = if (goingRight) true else false;
	}

	override function stepHit()
	{
		super.stepHit();
		if ((FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20) && songMultiplier >= 1)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	function shakeNote():Void
	{
		if (FlxG.save.data.tabinotesshake)
			noteCam.shake(0.005, (60 / Conductor.bpm), null, true, FlxAxes.X);
	}

	override function beatHit()
	{
		super.beatHit();
		if (lastBeatHit != curBeat) {
		lastBeatHit = curBeat;

		if (notestyle == 'tabi')
			shakeNote();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			//shiver chart is kinda broken and weird
			if (((SONG.notes[Math.floor(curStep / 16)].mustHitSection && !swappedsides) || (!SONG.notes[Math.floor(curStep / 16)].mustHitSection && swappedsides)) || (SONG.notes[Math.floor(curStep / 16)].sectionNotes.length == 0 && SONG.song.toLowerCase() != 'shiver' && (curEnemy.animation.curAnim.finished || dad.animation.curAnim.name != "scared" || boyfriend.animation.curAnim.name == "scared"))) //srry
				curEnemy.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015 / songMultiplier;
			camHUD.zoom += 0.03 / songMultiplier;
			addZoomTxtCams();
			noteCam.zoom += 0.03 / songMultiplier;
			ratingCam.zoom += 0.03 / songMultiplier;
		}
		else if (curSong.toLowerCase() == 'mom' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015 / songMultiplier;
			camHUD.zoom += 0.03 / songMultiplier;
			addZoomTxtCams();
			noteCam.zoom += 0.03 / songMultiplier;
			ratingCam.zoom += 0.03 / songMultiplier;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015 / songMultiplier;
			camHUD.zoom += 0.03 / songMultiplier;
			addZoomTxtCams();
			noteCam.zoom += 0.03 / songMultiplier;
			ratingCam.zoom += 0.03/ songMultiplier;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!curPlayer.animation.curAnim.name.startsWith("sing") && !curPlayer.animation.curAnim.name.startsWith("hair"))
		{
			curPlayer.playAnim('idle');
			if (curPlayer.color != FlxColor.WHITE)
				curPlayer.color = FlxColor.WHITE;
			if (curPlayer.curCharacter.startsWith('gf') || curPlayer.curCharacter.startsWith('spooky'))
				curPlayer.dance();
		}

		if (curBeat % 8 == 7 && !OG.BSIDE)
		{
			if (curSong == 'Bopeebo' || curSong == 'Old Bopeebo')
			{
				if (boyfriend.animation.getByName('hey') != null)
					boyfriend.playAnim('hey', true);

				if (curPlayer.curCharacter == "tankman")
				{
					tankmansoundthing = new FlxSound().loadEmbedded(Paths.sound('ugh'));
					FlxG.sound.list.add(tankmansoundthing);
					tankmansoundthing.play();
					#if desktop
					@:privateAccess
					{	
						if (tankmansoundthing.playing)	
							lime.media.openal.AL.sourcef(tankmansoundthing._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);					
					}
					trace("pitched the tankman sound thingy to " + songMultiplier);
					#end
				}

				gf.playAnim('cheer', true);
				if (curPlayer.curCharacter == "gf")
					curPlayer.playAnim('cheer', true);
			}
		}

		if (!OG.BSIDE) {
		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			if (boyfriend.animation.getByName('hey') != null)
				boyfriend.playAnim('hey', true);

			if (curPlayer.curCharacter == "tankman")
			{
				tankmansoundthing = new FlxSound().loadEmbedded(Paths.sound('ugh'));
				FlxG.sound.list.add(tankmansoundthing);
				tankmansoundthing.play();
				#if desktop
				@:privateAccess
				{	
					if (tankmansoundthing.playing)	
						lime.media.openal.AL.sourcef(tankmansoundthing._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);					
				}
				trace("pitched the tankman sound thingy to " + songMultiplier);
				#end
			}

			dad.playAnim('cheer', true);
		} }
		else
		{
			if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 80)
			{
				if (curPlayer.animation.getByName('hey') != null)
					curPlayer.playAnim('hey', true);

				if (curPlayer.curCharacter == "tankman")
				{
					tankmansoundthing = new FlxSound().loadEmbedded(Paths.sound('ugh'));
					FlxG.sound.list.add(tankmansoundthing);
					tankmansoundthing.play();
					#if desktop
					@:privateAccess
					{	
						if (tankmansoundthing.playing)	
							lime.media.openal.AL.sourcef(tankmansoundthing._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, songMultiplier);					
					}
					trace("pitched the tankman sound thingy to " + songMultiplier);
					#end
				}

				dad.playAnim('cheer', true);
			}
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'bf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('cheer', true);
			dad.playAnim('hey', true);
		}

		switch (curStage)
		{
			case 'school':


				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}
	}

	var curLight:Int = 0;
}