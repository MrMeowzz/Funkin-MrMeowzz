package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;

using StringTools;

class OptionsState extends MusicBeatState
{
	var textMenuItems:Array<String> = ['Clean Mode', 'Preload Freeplay Previews', 'Freeplay Previews'];

	var descriptionMenuItems:Array<String> = ['Changes some sprites, strings, and sounds to make it more PG.', 'Preloads the freeplay song previews so it does not lag while switching songs. Freeplay will take longer to load.', 'Disables the freeplay song previews.'];

	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<Alphabet>;

	var descriptiontxt:FlxText;

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		descriptiontxt = new FlxText(100, 0, 0, "", 15);
		descriptiontxt.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, RIGHT);
		add(descriptiontxt);

		grpOptionsTexts = new FlxTypedGroup<Alphabet>();
		add(grpOptionsTexts);

		// this code is so trash, ill clean up in later update

		if (FlxG.save.data.cleanmode == null)
			FlxG.save.data.cleanmode = false;
		
		if (FlxG.save.data.preloadfreeplaypreviews == null)
			FlxG.save.data.preloadfreeplaypreviews = true;
		
		if (FlxG.save.data.freeplaypreviews == null)
			FlxG.save.data.freeplaypreviews = true;

		if (FlxG.save.data.cleanmode)
			textMenuItems[0] += " ON";
		else
			textMenuItems[0] += " OFF";
		
		if (FlxG.save.data.preloadfreeplaypreviews)
			textMenuItems[1] += " ON";
		else
			textMenuItems[1] += " OFF";

		if (FlxG.save.data.freeplaypreviews)
			textMenuItems[2] += " ON";
		else
			textMenuItems[2] += " OFF";

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, textMenuItems[i], true, false);
			// optionText.ID = i;
			optionText.targetY = i;
			grpOptionsTexts.add(optionText);
		}

		changeSelection();

		FlxG.save.flush();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch (textMenuItems[curSelected])
			{
				case "Clean Mode" | "Clean Mode ON" | "Clean Mode OFF":
					FlxG.save.data.cleanmode = !FlxG.save.data.cleanmode;
					FlxG.save.flush();
					for (item in grpOptionsTexts.members)
					{
						if (item.text.contains(textMenuItems[curSelected]))
						{
							if (FlxG.save.data.cleanmode)
								textMenuItems[curSelected] = "Clean Mode ON";
							else
								textMenuItems[curSelected] = "Clean Mode OFF";
						}
					}
					regenOptions();
				case "Freeplay Previews" | "Freeplay Previews ON" | "Freeplay Previews OFF":
				#if desktop
					FlxG.save.data.freeplaypreviews = !FlxG.save.data.freeplaypreviews;
					FlxG.save.flush();
					for (item in grpOptionsTexts.members)
					{
						if (item.text.contains(textMenuItems[curSelected]))
						{
							if (FlxG.save.data.freeplaypreviews)
								textMenuItems[curSelected] = "Freeplay Previews ON";
							else
								textMenuItems[curSelected] = "Freeplay Previews OFF";
						}
					}
					regenOptions();
				#end
				case "Preload Freeplay Previews" | "Preload Freeplay Previews ON" | "Preload Freeplay Previews OFF":
				#if desktop
					FlxG.save.data.preloadfreeplaypreviews = !FlxG.save.data.preloadfreeplaypreviews;
					FlxG.save.flush();
					for (item in grpOptionsTexts.members)
					{
						if (item.text.contains(textMenuItems[curSelected]))
						{
							if (FlxG.save.data.preloadfreeplaypreviews)
								textMenuItems[curSelected] = "Preload Freeplay Previews ON";
							else
								textMenuItems[curSelected] = "Preload Freeplay Previews OFF";
						}
					}
					regenOptions();
				#end
			}
		}

		#if desktop
		if (FlxG.keys.justPressed.F11 || FlxG.keys.justPressed.F)
        {
			FlxG.save.data.fullscreen = !FlxG.fullscreen;
			FlxG.save.flush();	
        	FlxG.fullscreen = !FlxG.fullscreen;
        }
		#end
	}

	public function regenOptions()
	{
		grpOptionsTexts.clear();
		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, textMenuItems[i], true, false);
			// optionText.ID = i;
			optionText.targetY = i;
			grpOptionsTexts.add(optionText);
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		descriptiontxt.text = descriptionMenuItems[curSelected];

		var bullShit:Int = 0;

		for (item in grpOptionsTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
