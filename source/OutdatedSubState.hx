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
			+ "! Press ACCEPT to go to GitHub, or BACK to ignore this!!",
			32);
        if (prerelease)
            txt.text =
            "Pre-release build detected! Current version: "
            + ver
            + "\nRemember that there is probably bugs and unfinished features in this build!\nPress ACCEPT to close this!!";
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
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
                #if linux
			    Sys.command('/usr/bin/xdg-open', ["https://github.com/MrMeowzz/Funkin-MrMeowzz/releases/latest", "&"]);
			    #else
			    FlxG.openURL('https://github.com/MrMeowzz/Funkin-MrMeowzz/releases/latest');
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