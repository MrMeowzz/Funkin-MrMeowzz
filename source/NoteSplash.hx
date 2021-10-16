package;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
class NoteSplash extends FlxSprite {
    public function new(xPos:Float,yPos:Float,?data:Int = 0) {
        if (data == null) data = 0;
        super(xPos,yPos);
        var tex:FlxAtlasFrames;
        tex = Paths.getSparrowAtlas('noteSplashes');
        frames = tex;

        var notestyle:String = PlayState.SONG.notestyle;
		if (FlxG.save.data.notestyle != 'default' && PlayState.SONG.notestyleOverride != true)
			notestyle = FlxG.save.data.notestyle;

        if (notestyle == 'kapi')
        {
            animation.addByPrefix("note1-0", "note impact 1 blue", 24, false);
		    animation.addByPrefix("note2-0", "note impact 1 blue", 24, false);
		    animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
		    animation.addByPrefix("note3-0", "note impact 1 purple", 24, false);

		    animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
		    animation.addByPrefix("note2-1", "note impact 2 blue", 24, false);
		    animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
		    animation.addByPrefix("note3-1", "note impact 2 purple", 24, false);
        }
        else
        {
            animation.addByPrefix("note1-0", "note impact 1 blue", 24, false);
		    animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
		    animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
		    animation.addByPrefix("note3-0", "note impact 1 red", 24, false);

		    animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
		    animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
		    animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
		    animation.addByPrefix("note3-1", "note impact 2 red", 24, false);
        }
        setupNoteSplash(xPos,xPos,data);
    }
    public function setupNoteSplash(xPos:Float, yPos:Float, ?data:Int = 0, ?middlescroll = false) {
        var notestyle:String = PlayState.SONG.notestyle;
		if (FlxG.save.data.notestyle != 'default' && PlayState.SONG.notestyleOverride != true)
			notestyle = FlxG.save.data.notestyle;
        if (data == null) data = 0;
        var randomsplash = FlxG.random.int(0,1);
        setPosition(xPos, yPos);
        alpha = 0.6;
        animation.play("note"+data+"-"+randomsplash, true);
        updateHitbox();
        if (Std.int(width) != 260 && Std.int(width) != 274)
        {
            if (randomsplash == 0)
                setGraphicSize(260);
            else
                setGraphicSize(274);
            updateHitbox();
        }
        if (middlescroll)
        {
            setGraphicSize(Std.int(width * 0.8));
            updateHitbox();
        }
        if (randomsplash == 0)
        {
            offset.x += 75;
	        offset.y += 95;
            if (animation.curAnim.name == "note0-0" || (animation.curAnim.name == "note3-0" && notestyle == 'kapi'))
                offset.y += 10;
        }
        else
        {
            offset.x += 90;
	        offset.y += 80;
        }
        animation.finishCallback = function(name) kill();
    }
}