import flixel.FlxG;

class OptionSaveData
{
    public static function SetDefaultOptions():Void
    {
        FlxG.save.bind('funkin', 'Mr Meowzz');
		if (FlxG.save.data.fullscreen != null)
			FlxG.fullscreen = FlxG.save.data.fullscreen;
		else
			FlxG.save.data.fullscreen = false;

		if (FlxG.save.data.cleanmode == null)		
			FlxG.save.data.cleanmode = false;
		
		if (FlxG.save.data.preloadfreeplaypreviews == null)		
			FlxG.save.data.preloadfreeplaypreviews = true;
		
		if (FlxG.save.data.freeplaypreviews == null)	
			FlxG.save.data.freeplaypreviews = true;
		
		if (FlxG.save.data.colorratings == null)		
			FlxG.save.data.colorratings = true;
		
		if (FlxG.save.data.downscroll == null)		
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.middlescroll == null)
			FlxG.save.data.middlescroll = false;
		
		if (FlxG.save.data.overridespeed == null)		
			FlxG.save.data.overridespeed = false;
		
		if (FlxG.save.data.disabledmissstun == null)		
			FlxG.save.data.disabledmissstun = true;
		
		if (FlxG.save.data.misssounds == null)		
			FlxG.save.data.misssounds = true;
		
		if (FlxG.save.data.hitsounds == null)		
			FlxG.save.data.hitsounds = false;
		
		if (FlxG.save.data.enemyhitsounds == null)		
			FlxG.save.data.enemyhitsounds = false;
		
		if (FlxG.save.data.instantrestart == null)		
			FlxG.save.data.instantrestart = false;
		
		if (FlxG.save.data.notesplashes == null)	
			FlxG.save.data.notesplashes = true;
		
		if (FlxG.save.data.newhittimings == null)		
			FlxG.save.data.newhittimings = true;
		
		if (FlxG.save.data.ratingsfollowcamera == null)		
			FlxG.save.data.ratingsfollowcamera = true;
		
		if (FlxG.save.data.notestyle == null)		
			FlxG.save.data.notestyle = 'default';
		
		if (FlxG.save.data.tabinotesshake == null)		
			FlxG.save.data.tabinotesshake = false;
		
		if (FlxG.save.data.milliseconds == null)		
			FlxG.save.data.milliseconds = true;
		
		if (FlxG.save.data.skipcountdown == null)		
			FlxG.save.data.skipcountdown = false;
		
        if (FlxG.save.data.storymodedialog == null)		
			FlxG.save.data.storymodedialog = true;
		
		if (FlxG.save.data.freeplaydialog == null)		
			FlxG.save.data.freeplaydialog = false;
		
		if (FlxG.save.data.menutransitions == null)		
			FlxG.save.data.menutransitions = true;	

		if (FlxG.save.data.enemyextraeffects == null)
			FlxG.save.data.enemyextraeffects = false;

		if (FlxG.save.data.enemystrums == null)
			FlxG.save.data.enemystrums = true;

		if (FlxG.save.data.safeframes == null)
			FlxG.save.data.safeframes = 10;
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
    }

	public static function ResetOptions():Void
    {
		FlxG.save.data.fullscreen = false;

		FlxG.save.data.cleanmode = false;
			
		FlxG.save.data.preloadfreeplaypreviews = true;
		
		FlxG.save.data.freeplaypreviews = true;
				
		FlxG.save.data.colorratings = true;
			
		FlxG.save.data.downscroll = false;

		FlxG.save.data.middlescroll = false;
	
		FlxG.save.data.overridespeed = false;
			
		FlxG.save.data.disabledmissstun = true;
			
		FlxG.save.data.misssounds = true;
		
		FlxG.save.data.hitsounds = false;
			
		FlxG.save.data.enemyhitsounds = false;
			
		FlxG.save.data.instantrestart = false;
		
		FlxG.save.data.notesplashes = true;
		
		FlxG.save.data.newhittimings = true;
			
		FlxG.save.data.ratingsfollowcamera = true;
			
		FlxG.save.data.notestyle = 'default';
				
		FlxG.save.data.tabinotesshake = false;
			
		FlxG.save.data.milliseconds = true;
			
		FlxG.save.data.skipcountdown = false;
			
		FlxG.save.data.storymodedialog = true;
		
		FlxG.save.data.freeplaydialog = false;
		
		FlxG.save.data.menutransitions = true;	

		FlxG.save.data.enemyextraeffects = false;

		FlxG.save.data.enemystrums = true;

		FlxG.save.data.safeframes = 10;
    }
}