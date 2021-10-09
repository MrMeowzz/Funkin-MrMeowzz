package;

import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxAxes;
import flixel.FlxSubState;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.input.FlxKeyManager;
import flixel.util.FlxColor;

class ResetOptionsState extends FlxSubState
{

    var mainText:FlxText;

    var blackBox:FlxSprite;

    public static var ResetOptions:Bool = false;

	override function create()
	{	
        ResetOptions = false;
        mainText = new FlxText(0, 0, 1280, "Are you sure? This will reset ALL options to default.", 72);
		mainText.scrollFactor.set(0, 0);
		mainText.setFormat("VCR OSD Mono", 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		mainText.borderSize = 2;
		mainText.borderQuality = 3;
        mainText.screenCenter();

        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);

        add(mainText);

        blackBox.alpha = 0;
        mainText.alpha = 0;

        FlxTween.tween(mainText, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});

		super.create();
	}

	override function update(elapsed:Float)
	{
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if(FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.Z || FlxG.keys.justPressed.SPACE || (gamepad != null && (gamepad.justPressed.START || gamepad.justPressed.A)))
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));

            OptionSaveData.ResetOptions();

            ResetOptions = true;

            FlxTween.tween(mainText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
            FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){close();}});
        }

        if(FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE || (gamepad != null && (gamepad.justPressed.BACK || gamepad.justPressed.B)))
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));

            FlxTween.tween(mainText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
            FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){close();}});
        }

		super.update(elapsed);		
	}
}