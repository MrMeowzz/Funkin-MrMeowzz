package;

// static variables to keep between states
class OG 
{
	//menu stuf
	public static var SelectedFreeplay:Int = 0;
	public static var SelectedStoryMode:Int = 0;
	public static var SelectedMainMenu:Int = 0;
	public static var DifficultyFreeplay:Int = 1;
	public static var DifficultyStoryMode:Int = 1;

	//cutscene stuf
	public static var currentCutsceneEnded:Bool = false;
	public static var forceCutscene:Bool = false;

	//mod thingy
	public static var FreeplayMenuType:String = 'section';
	public static var StoryMenuType:String = 'section';
	public static var BSIDE:Bool = false;

	//preloading
	public static var music = [];
	public static var bsidemusic = [];
	public static var preloadedSongs:Bool = false;

	//http request
	public static var httpRequested:Bool = false;
}
