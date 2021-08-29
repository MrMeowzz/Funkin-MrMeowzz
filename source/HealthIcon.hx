package;

import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false, gftutorialicon:Bool = false, bsideicon:Bool = false)
	{
		super();
		antialiasing = true;
		if (bsideicon) {
		loadGraphic(Paths.image('iconGrid-bside'), true, 150, 150);
		animation.add('gf', [16, 24, 16], 0, false, isPlayer);
		animation.add('bf', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-car', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 29, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3, 2], 0, false, isPlayer);
		animation.add('pico', [4, 5, 4], 0, false, isPlayer);
		animation.add('mom', [6, 7, 6], 0, false, isPlayer);
		animation.add('mom-car', [6, 7, 6], 0, false, isPlayer);
		animation.add('face', [10, 11, 10], 0, false, isPlayer);
		animation.add('dad', [12, 13, 12], 0, false, isPlayer);
		animation.add('senpai', [22, 25, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [26, 27, 26], 0, false, isPlayer);
		animation.add('spirit', [23, 28, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15, 14], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18, 17], 0, false, isPlayer);
		animation.add('monster', [19, 20, 19], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20, 19], 0, false, isPlayer);
		animation.add('gf-christmas', [16, 24, 16], 0, false, isPlayer);
		animation.add('gf-car', [16, 24, 16], 0, false, isPlayer);
		animation.add('gf-pixel', [16, 24, 16], 0, false, isPlayer);
		}
		else {
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		animation.add('gf', [16, 51, 52], 0, false, isPlayer);
		animation.add('bf', [0, 1, 30], 0, false, isPlayer);
		animation.add('bf-holding-gf', [53, 54, 55], 0, false, isPlayer);
		animation.add('bf-car', [0, 1, 30], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1, 30], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 41, 40], 0, false, isPlayer);
		animation.add('tankman-pixel', [58, 57, 56], 0, false, isPlayer);
		animation.add('pico-pixel', [24, 25, 26], 0, false, isPlayer);
		animation.add('spooky', [2, 3, 31], 0, false, isPlayer);
		animation.add('pico', [4, 5, 32], 0, false, isPlayer);
		animation.add('pico-speaker', [4, 5, 32], 0, false, isPlayer);
		animation.add('mom', [6, 7, 33], 0, false, isPlayer);
		animation.add('mom-car', [6, 7, 33], 0, false, isPlayer);
		animation.add('tankman', [8, 9, 50], 0, false, isPlayer);
		animation.add('tankmannoamongus', [59, 60, 61], 0, false, isPlayer);
		animation.add('face', [10, 11, 38], 0, false, isPlayer);
		animation.add('dad', [12, 13, 34], 0, false, isPlayer);
		animation.add('senpai', [22, 42, 43], 0, false, isPlayer);
		animation.add('senpai-angry', [44, 45, 46], 0, false, isPlayer);
		animation.add('spirit', [23, 47, 48], 0, false, isPlayer);
		animation.add('bf-old', [14, 15, 39], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18, 36], 0, false, isPlayer);
		animation.add('monster', [19, 20, 37], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20, 37], 0, false, isPlayer);
		animation.add('gf-christmas', [16, 51, 52], 0, false, isPlayer);
		animation.add('gf-car', [16, 51, 52], 0, false, isPlayer);
		animation.add('gf-pixel', [16, 51, 52], 0, false, isPlayer);
		animation.add('gf-tankmen', [16, 51, 52], 0, false, isPlayer);
		animation.add('gf-amogus', [67, 67, 67], 0, false, isPlayer);
		animation.add('amogusguy', [62, 63, 64], 0, false, isPlayer);
		animation.add('bf-amogus', [65, 66, 65], 0, false, isPlayer);
		if (gftutorialicon)
		{
			animation.add('gf', [16, 49, 35], 0, false, isPlayer);
		}
		}
		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
