package;

import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxAxes;
import flixel.FlxSubState;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import lime.utils.Assets;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.input.FlxKeyManager;


using StringTools;

class KeyBindMenu extends FlxSubState
{

    var keyTextDisplay:FlxText;
    var keyWarning:FlxText;
    var warningTween:FlxTween;
    var keyText:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "RESET"];
    var defaultKeys:Array<String> = ["A", "S", "W", "D", "R"];
    var defaultGpKeys:Array<String> = ["DPAD_LEFT", "DPAD_DOWN", "DPAD_UP", "DPAD_RIGHT", ""];
    var curSelected:Int = 0;

    var keys:Array<String> = [FlxG.save.data.leftBind,
                              FlxG.save.data.downBind,
                              FlxG.save.data.upBind,
                              FlxG.save.data.rightBind,
                              FlxG.save.data.killBind];
    var gpKeys:Array<String> = [FlxG.save.data.gpleftBind,
                              FlxG.save.data.gpdownBind,
                              FlxG.save.data.gpupBind,
                              FlxG.save.data.gprightBind,
                              FlxG.save.data.gpkillBind];
    var tempKey:String = "";
    var blacklist:Array<String> = ["ESCAPE", "ENTER", "BACKSPACE", "SPACE", "TAB", "NINE", "SIX", "FIVE", "SEVEN", "TWO", "F11"];

    var blackBox:FlxSprite;
    var modeText:FlxText;
    var controlsText:FlxText;
    var blacklistedKeyText:FlxText;

    var state:String = "select";

	override function create()
	{	

        for (i in 0...keys.length)
        {
            var k = keys[i];
            if (k == null)
                keys[i] = defaultKeys[i];
        }

        for (i in 0...gpKeys.length)
        {
            var k = gpKeys[i];
            if (k == null)
                gpKeys[i] = defaultGpKeys[i];
        }
	
		//FlxG.sound.playMusic('assets/music/configurator' + TitleState.soundExt);

		persistentUpdate = true;

        keyTextDisplay = new FlxText(-10, 0, 1280, "", 72);
		keyTextDisplay.scrollFactor.set(0, 0);
		keyTextDisplay.setFormat("VCR OSD Mono", 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		keyTextDisplay.borderSize = 2;
		keyTextDisplay.borderQuality = 3;

        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);

        modeText = new FlxText(-10, 580, 1280, 'Current Mode: ${KeyBinds.gamepad ? 'GAMEPAD' : 'KEYBOARD'}.', 72);
		modeText.scrollFactor.set(0, 0);
		modeText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		modeText.borderSize = 2;
		modeText.borderQuality = 3;
        modeText.alpha = 0;
        modeText.screenCenter(FlxAxes.X);

        controlsText = new FlxText(-10, 80, 1280, '(${KeyBinds.gamepad ? 'LEFT Trigger' : 'Escape'} to save, ${KeyBinds.gamepad ? 'RIGHT Trigger' : 'Backspace'} to leave without saving, ${KeyBinds.gamepad ? 'LEFT Shoulder' : 'Alt'} to reset to default keybindings.', 72);
		controlsText.scrollFactor.set(0, 0);
		controlsText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		controlsText.borderSize = 2;
		controlsText.borderQuality = 3;
        controlsText.alpha = 0;
        controlsText.screenCenter(FlxAxes.X);

        blacklistedKeyText = new FlxText(-10, 180, 1280, '', 72);
		blacklistedKeyText.scrollFactor.set(0, 0);
		blacklistedKeyText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		blacklistedKeyText.borderSize = 2;
		blacklistedKeyText.borderQuality = 3;
        blacklistedKeyText.alpha = 0;
        blacklistedKeyText.screenCenter(FlxAxes.X);
        add(modeText);
        add(controlsText);
        add(blacklistedKeyText);
        add(keyTextDisplay);

        blackBox.alpha = 0;
        keyTextDisplay.alpha = 0;

        FlxTween.tween(keyTextDisplay, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(modeText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
        FlxTween.tween(controlsText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
        FlxTween.tween(blacklistedKeyText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});

        textUpdate();

		super.create();
	}

    var frames = 0;

	override function update(elapsed:Float)
	{
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (frames <= 10)
            frames++;

        

        modeText.text = 'Current Mode: ${KeyBinds.gamepad ? 'GAMEPAD. Use a keyboard to switch modes' : 'KEYBOARD. Use a controller to switch modes'}.';
        controlsText.text = '(${KeyBinds.gamepad ? 'RIGHT Trigger' : 'Escape'} to save, ${KeyBinds.gamepad ? 'LEFT Trigger' : 'Backspace'} to leave without saving, ${KeyBinds.gamepad ? 'LEFT Shoulder' : 'Alt'} to reset to default keybindings, ${KeyBinds.gamepad ? 'RIGHT Shoulder' : 'Delete'} to delete keybinds.';
        blacklistedKeyText.text = '${lastKey != "" ? lastKey + " is blacklisted!" : ""}';
        switch(state){

            case "select":
                if (FlxG.keys.justPressed.ANY)
                {
                    KeyBinds.gamepad = false;
                }
                if (FlxG.keys.justPressed.UP)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(-1);
                }

                if (FlxG.keys.justPressed.DOWN)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(1);
                }
                
                /*
                if (FlxG.keys.justPressed.TAB)
                {
                    KeyBinds.gamepad = !KeyBinds.gamepad;
                    textUpdate();
                }
                */

                if (FlxG.keys.justPressed.ENTER){
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    state = "input";
                }
                else if(FlxG.keys.justPressed.ESCAPE){
                    quit(true);
                }
                else if (FlxG.keys.justPressed.BACKSPACE){
                    quit(false);
                }
                else if (FlxG.keys.justPressed.ALT){
                    reset();
                }
                else if (FlxG.keys.justPressed.DELETE){
                    keys[curSelected] = "";
                    addKey("");
                    textUpdate();
                }
                if (gamepad != null) // GP Logic
                {
                    if (gamepad.justPressed.ANY)
                    {
                        KeyBinds.gamepad = true;
                    }
                    if (gamepad.justPressed.DPAD_UP)
                    {
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        changeItem(-1);
                        textUpdate();
                    }
                    if (gamepad.justPressed.DPAD_DOWN)
                    {
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        changeItem(1);
                        textUpdate();
                    }

                    if (gamepad.justPressed.A && frames > 10){
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        state = "input";
                    }
                    else if(gamepad.justPressed.LEFT_TRIGGER){
                        quit(false);
                    }
                    else if (gamepad.justPressed.RIGHT_TRIGGER){
                        quit(true);
                    }
                    else if (gamepad.justPressed.LEFT_SHOULDER){
                        reset();
                    }
                    else if (gamepad.justPressed.RIGHT_SHOULDER){
                        gpKeys[curSelected] = "";
                        addKeyGamepad("");
                        textUpdate();
                    }
                }

            case "input":
                if (KeyBinds.gamepad) {
                    tempKey = gpKeys[curSelected];
                    gpKeys[curSelected] = "?";
                } else {
                    tempKey = keys[curSelected];
                    keys[curSelected] = "?";
                }
                textUpdate();
                state = "waiting";

            case "waiting":
                if (gamepad != null && KeyBinds.gamepad) // GP Logic
                {
                    if(FlxG.keys.justPressed.ESCAPE){ // just in case you get stuck
                        gpKeys[curSelected] = tempKey;
                        state = "select";
                        FlxG.sound.play(Paths.sound('confirmMenu'));
                    }

                    if (gamepad.justPressed.A)
                    {
                        addKeyGamepad(defaultKeys[curSelected]);
                        //save();
                        state = "select";
                    }

                    if (gamepad.justPressed.ANY)
                    {
                        trace(gamepad.firstJustPressedID());
                        addKeyGamepad(gamepad.firstJustPressedID());
                        //save();
                        state = "select";
                        textUpdate();
                    }

                }
                else
                {
                    if(FlxG.keys.justPressed.ESCAPE){
                        keys[curSelected] = tempKey;
                        state = "select";
                        FlxG.sound.play(Paths.sound('confirmMenu'));
                    }
                    else if(FlxG.keys.justPressed.ENTER){
                        addKey(defaultKeys[curSelected]);
                        //save();
                        state = "select";
                    }
                    else if(FlxG.keys.justPressed.ANY){
                        addKey(FlxG.keys.getIsDown()[0].ID.toString());
                        //save();
                        state = "select";
                    }
                }


            case "exiting":


            default:
                state = "select";

        }

        if(FlxG.keys.justPressed.ANY || (gamepad != null && gamepad.justPressed.ANY))
        {
            textUpdate();
        }

		super.update(elapsed);
		
	}

    function textUpdate(){

        keyTextDisplay.text = "\n\n";

        if (KeyBinds.gamepad)
        {
            for(i in 0...5){

                var textStart = (i == curSelected) ? "> " : "  ";
                trace(gpKeys[i]);
                keyTextDisplay.text += textStart + keyText[i] + ": " + ((gpKeys[i] == "") ? "NONE" : gpKeys[i] ) + "\n";
                
            }
        }
        else
        {
            for(i in 0...5){

                var textStart = (i == curSelected) ? "> " : "  ";
                if (i < 4)
                    keyTextDisplay.text += textStart + keyText[i] + ": " + ((keys[i] != keyText[i]) ? (((keys[i] == "") ? "NONE" : keys[i] ) + " / ") : "" ) + keyText[i] + " ARROW\n";
                else
                    keyTextDisplay.text += textStart + keyText[i] + ": " + ((keys[i] != keyText[i]) ? (((keys[i] == "") ? "NONE" : keys[i] )) : "" ) + "\n";

            }
        }

        keyTextDisplay.screenCenter();

    }

    function save(){

        FlxG.save.data.upBind = keys[2];
        FlxG.save.data.downBind = keys[1];
        FlxG.save.data.leftBind = keys[0];
        FlxG.save.data.rightBind = keys[3];
        FlxG.save.data.killBind = keys[4];
        
        FlxG.save.data.gpupBind = gpKeys[2];
        FlxG.save.data.gpdownBind = gpKeys[1];
        FlxG.save.data.gpleftBind = gpKeys[0];
        FlxG.save.data.gprightBind = gpKeys[3];
        FlxG.save.data.gpkillBind = gpKeys[4];

        FlxG.save.flush();

        PlayerSettings.player1.controls.loadKeyBinds();

    }

    function reset(){
        
        for(i in 0...5){
            if (KeyBinds.gamepad)
                gpKeys[i] = defaultGpKeys[i];
            else
                keys[i] = defaultKeys[i];
        }
        textUpdate();
    }

    function quit(savethekeys:Bool){

        state = "exiting";

        if (savethekeys)
        {
            save();
            FlxG.sound.play(Paths.sound('confirmMenu'));
            trace('SAVED DA KEYS');
        }
        else
            FlxG.sound.play(Paths.sound('cancelMenu'));

        FlxTween.tween(keyTextDisplay, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){close();}});
        FlxTween.tween(modeText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(controlsText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(blacklistedKeyText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
    }


    function addKeyGamepad(r:String){

        var shouldReturn:Bool = true;

        var notAllowed:Array<String> = ["START", "BACK"];
        var swapKey:Int = -1;

        if (r != "") {
        for(x in 0...gpKeys.length)
            {
                var oK = gpKeys[x];
                if(oK == r) {
                    swapKey = x;
                    gpKeys[x] = null;
                }
                if (notAllowed.contains(oK))
                {
                    gpKeys[x] = null;
                    lastKey = r;
                    return;
                }
            }
        }

        if (notAllowed.contains(r))
        {
            gpKeys[curSelected] = tempKey;
            lastKey = r;
            return;
        }

        if(shouldReturn){
            if (swapKey != -1) {
                gpKeys[swapKey] = tempKey;
            }
            gpKeys[curSelected] = r;
            FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        else{
            gpKeys[curSelected] = tempKey;
            lastKey = r;
        }

	}

    public var lastKey:String = "";

	function addKey(r:String){

        var shouldReturn:Bool = true;

        var notAllowed:Array<String> = [];
        var swapKey:Int = -1;

        for(x in blacklist){notAllowed.push(x);}

        trace(notAllowed);

        if (r != "") {
        for(x in 0...keys.length)
            {
                var oK = keys[x];
                if(oK == r) {
                    swapKey = x;
                    keys[x] = null;
                }
                if (notAllowed.contains(oK))
                {
                    keys[x] = null;
                    lastKey = oK;
                    return;
                }
            }
        }

        if (notAllowed.contains(r))
        {
            keys[curSelected] = tempKey;
            lastKey = r;
            return;
        }

        lastKey = "";

        if(shouldReturn){
            // Swap keys instead of setting the other one as null
            if (swapKey != -1) {
                keys[swapKey] = tempKey;
            }
            keys[curSelected] = r;
            FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        else{
            keys[curSelected] = tempKey;
            lastKey = r;
        }

	}

    function changeItem(_amount:Int = 0)
    {
        curSelected += _amount;
                
        if (curSelected > 4)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = 4;
    }
}