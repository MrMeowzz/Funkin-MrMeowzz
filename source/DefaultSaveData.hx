import flixel.FlxG;

class DefaultSaveData
{
    public static function SetSaveData():Void
    {
        FlxG.save.bind('funkin', 'Mr Meowzz');
		if (FlxG.save.data.fullscreen != null)
			FlxG.fullscreen = FlxG.save.data.fullscreen;
		else
			FlxG.save.data.fullscreen = OptionsState.DefaultValues[4];

		if (FlxG.save.data.cleanmode == null)
		{
			FlxG.save.data.cleanmode = OptionsState.DefaultValues[0];
		}
		if (FlxG.save.data.preloadfreeplaypreviews == null)
		{
			FlxG.save.data.preloadfreeplaypreviews = OptionsState.DefaultValues[1];
		}
		if (FlxG.save.data.freeplaypreviews == null)
		{
			FlxG.save.data.freeplaypreviews = OptionsState.DefaultValues[2];
		}
		if (FlxG.save.data.colorratings == null)
		{
			FlxG.save.data.colorratings = OptionsState.DefaultValues[3];
		}
		if (FlxG.save.data.downscroll == null)
		{
			FlxG.save.data.downscroll = OptionsState.DefaultValues[6];
		}
		if (FlxG.save.data.overridespeed == null)
		{
			FlxG.save.data.overridespeed = OptionsState.DefaultValues[7];
		}
		if (FlxG.save.data.disabledmissstun == null)
		{
			FlxG.save.data.disabledmissstun = OptionsState.DefaultValues[8];
		}
		if (FlxG.save.data.misssounds == null)
		{
			FlxG.save.data.misssounds = OptionsState.DefaultValues[9];
		}
		if (FlxG.save.data.countdown == null)
		{
			FlxG.save.data.countdown = OptionsState.DefaultValues[10];
		}
		if (FlxG.save.data.hitsounds == null)
		{
			FlxG.save.data.hitsounds = OptionsState.DefaultValues[11];
		}
		if (FlxG.save.data.instantrestart == null)
		{
			FlxG.save.data.instantrestart = OptionsState.DefaultValues[12];
		}
		if (FlxG.save.data.notesplashes == null)
		{
			FlxG.save.data.notesplashes = OptionsState.DefaultValues[13];
		}
		if (FlxG.save.data.newhittimings == null)
		{
			FlxG.save.data.newhittimings = OptionsState.DefaultValues[14];
		}
		if (FlxG.save.data.ratingsfollowcamera == null)
		{
			FlxG.save.data.ratingsfollowcamera = OptionsState.DefaultValues[15];
		}
		if (FlxG.save.data.notestyle == null)
		{
			FlxG.save.data.notestyle = 'default';
		}
		if (FlxG.save.data.tabinotesshake == null)
		{
			FlxG.save.data.tabinotesshake = OptionsState.DefaultValues[17];
		}
		if (FlxG.save.data.milliseconds == null)
		{
			FlxG.save.data.milliseconds = OptionsState.DefaultValues[18];
		}
		if (FlxG.save.data.skipcountdown == null)
		{
			FlxG.save.data.skipcountdown = OptionsState.DefaultValues[20];
		}
        if (FlxG.save.data.storymodedialog == null)
		{
			FlxG.save.data.storymodedialog = OptionsState.DefaultValues[21];
		}
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
    }
}