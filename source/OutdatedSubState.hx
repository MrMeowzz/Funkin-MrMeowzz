package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

    public static var latestver:String = "";

    public static var prerelease:Bool = false;

	public static var data:String;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var ver = "v" + Application.current.meta.get('version');
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! You're running an outdated version of Mr Meowzz's FNF!\nCurrent version is "
			+ ver
			+ " while the most recent version is v"
			+ latestver
			+ "! Press ACCEPT to go to GitHub, or BACK to ignore this!!\nHold SHIFT with ACCEPT to automatically open/download the file from GitHub.",
			32);
		var patchnotes:FlxText = new FlxText(0, 0, FlxG.width, "", 20);
		patchnotes.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER);
		patchnotes.screenCenter(X);
		add(patchnotes);
		if (data != null)
			patchnotes.text = haxe.Json.parse(data).body;
		
        if (prerelease)
		{
			patchnotes.visible = false;
            txt.text =
            "Pre-release build detected! Current version: "
            + ver
            + "\nRemember that there is probably bugs and unfinished features in this build!\nPress ACCEPT to close this!!";
		}
		#if html5
		patchnotes.visible = false;
		if (!prerelease)
			txt.text =
			"HEY! You're running an outdated version of Mr Meowzz's FNF!\nCurrent version is "
			+ ver
			+ " while the most recent version is v"
			+ latestver
			+ "! Please wait for Github to update this page or press BACK to ignore this!!";
		#end
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		if (patchnotes.visible)
			txt.y = 25;
		patchnotes.y = txt.height += 125;
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
            if (prerelease)
            {
                leftState = true;
			    FlxG.switchState(new MainMenuState());
            }
            else
            {
				#if !html5
                #if linux
				if (FlxG.keys.pressed.SHIFT)
					Sys.command('/usr/bin/xdg-open', ["https://github.com/MrMeowzz/Funkin-MrMeowzz/releases/latest/download/MrMeowzzFunkin.zip", "&"]);
				else
			    	Sys.command('/usr/bin/xdg-open', ["https://github.com/MrMeowzz/Funkin-MrMeowzz/releases/latest", "&"]);
			    #else
				if (FlxG.keys.pressed.SHIFT)
					FlxG.openURL('https://github.com/MrMeowzz/Funkin-MrMeowzz/releases/latest/download/MrMeowzzFunkin.zip');
				else
			    	FlxG.openURL('https://github.com/MrMeowzz/Funkin-MrMeowzz/releases/latest');
			    #end
				#end
            }
		}
		if (controls.BACK && !prerelease)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}