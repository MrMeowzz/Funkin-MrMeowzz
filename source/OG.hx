package;

// static variables to keep between states
class OG 
{
	public static var SelectedFreeplay:Int = 0;
	public static var SelectedStoryMode:Int = 0;
	public static var SelectedMainMenu:Int = 0;
	public static var DifficultyFreeplay:Int = 1;
	public static var DifficultyStoryMode:Int = 1;
	public static var currentCutsceneEnded:Bool = false;
	public static var FreeplayMenuType:String = 'section';
	public static var StoryMenuType:String = 'section';
	public static var BSIDE:Bool = false;
}
