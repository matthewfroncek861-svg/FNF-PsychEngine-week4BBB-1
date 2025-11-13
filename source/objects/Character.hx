package objects;

import backend.animation.PsychAnimationController;

import flixel.util.FlxSort;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;

import openfl.utils.AssetType;
import openfl.utils.Assets;
import haxe.Json;

import backend.Song;
import states.stages.objects.TankmenBG;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
	var vocals_file:String;
	@:optional var _editor_isPlayer:Null<Bool>;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

class Character extends FlxSprite
{
	/**
	 * In case a character is missing, it will use this on its place
	**/
	public static final DEFAULT_CHARACTER:String = 'bf';

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;
	public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();

	public var isPlayer:Bool = false;
	public var curCharacter:String = DEFAULT_CHARACTER;

	public var holdTimer:Float = 0;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;
	public var animationNotes:Array<Dynamic> = [];
	public var stunned:Bool = false;
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose
	public var idleSuffix:String = '';
	public var danceIdle:Bool = false; //Character use "danceLeft" and "danceRight" instead of "idle"
	public var skipDance:Bool = false;

	public var healthIcon:String = 'face';
	public var animationsArray:Array<AnimArray> = [];

	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];
	public var healthColorArray:Array<Int> = [255, 0, 0];

	public var missingCharacter:Bool = false;
	public var missingText:FlxText;
	public var hasMissAnimations:Bool = false;
	public var vocalsFile:String = '';

	public static var dadHealthColor:String = '0xFFA5004D';

	public static var bfHealthColor:String = '0xFF31B0D1';

	//Used on Character Editor
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var editorIsPlayer:Null<Bool> = null;

	public function new(x:Float, y:Float, ?character:String = 'bf', ?isPlayer:Bool = false)
	{
		super(x, y);

		animation = new PsychAnimationController(this);

		animOffsets = new Map<String, Array<Dynamic>>();
		this.isPlayer = isPlayer;
		changeCharacter(character);
		
		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch(curCharacter)
		{
			case 'pico-speaker':
				skipDance = true;
				loadMappedAnims();
				playAnim("shoot1");
			case 'pico-blazin', 'darnell-blazin':
				skipDance = true;
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

			case 'gf-goblin':
				tex = Paths.getSparrowAtlas('characters/goblin_gf');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

			case 'baby-bopper':
				tex = Paths.getSparrowAtlas('characters/baby_bopper');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';

				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';

				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';

				playAnim('idle');

				flipX = true;
			case 'baby':
					tex = Paths.getSparrowAtlas('characters/baby');
					frames = tex;
					animation.addByPrefix('idle', 'baby', 24);
					animation.addByPrefix('singUP', 'up', 24);
					animation.addByPrefix('singRIGHT', 'right', 24);
					animation.addByPrefix('singDOWN', 'down', 24);
					animation.addByPrefix('singLEFT', 'left', 24);
	
					addOffset('idle');
					addOffset("singUP", 20, 31);
					addOffset("singRIGHT", 30, 6);
					addOffset("singLEFT", 45, -6);
					addOffset("singDOWN", -9, -49);

						if(isPlayer)
					bfHealthColor = '0xFFB3FFFF';
				if(!isPlayer)
					dadHealthColor = '0xFFB3FFFF';
	
					playAnim('idle');
			case 'miku':
					tex = Paths.getSparrowAtlas('characters/ev_miku_assets');
					frames = tex;
					animation.addByPrefix('idle', 'Miku idle dance', 24);
					animation.addByPrefix('singUP', 'Miku Sing Note UP', 24);
					animation.addByPrefix('singRIGHT', 'Miku Sing Note RIGHT', 24);
					animation.addByPrefix('singDOWN', 'Miku Sing Note DOWN', 24);
					animation.addByPrefix('singLEFT', 'Miku Sing Note LEFT', 24);
	
					addOffset('idle');
					addOffset("singUP", 4, 50);
					addOffset("singRIGHT", -56, -2);
					addOffset("singLEFT", 76, -2);
					addOffset("singDOWN", 6, 0);

					if(isPlayer)
						bfHealthColor = '0xFF32CDCC';
					if(!isPlayer)
						dadHealthColor = '0xFF32CDCC';
	
					playAnim('idle');
			case 'tinky':
					tex = Paths.getSparrowAtlas('characters/Tinky_Winky');
					frames = tex;
					animation.addByPrefix('idle', 'TinkyIdle', 24);
					animation.addByPrefix('singUP', 'TinkyUp', 24);
					animation.addByPrefix('singRIGHT', 'TinkyRight', 24);
					animation.addByPrefix('singDOWN', 'TinkyDown', 24);
					animation.addByPrefix('singLEFT', 'TinkyLeft', 24);
	
					addOffset('idle');
					addOffset("singUP", -2, 46);
					addOffset("singRIGHT", -3, -94);
					addOffset("singLEFT", 135, -72);
					addOffset("singDOWN", -9, -67);

					if(isPlayer)
						bfHealthColor = '0xFF6001B5';
					if(!isPlayer)
						dadHealthColor = '0xFF6001B5';
	
					playAnim('idle');
			case 'pewdiepie':
					tex = Paths.getSparrowAtlas('characters/pewdiepie');
					frames = tex;
					animation.addByPrefix('idle', 'pewdiepie idle', 24);
					animation.addByPrefix('singUP', 'pewdiepie sing up', 24);
					animation.addByPrefix('singRIGHT', 'pewdiepies sing right', 24);
					animation.addByPrefix('singDOWN', 'pewdiepie sing up', 24);
					animation.addByPrefix('singLEFT', 'pewdiepies sing right', 24);
	
					addOffset('idle');
					addOffset("singUP", 20, 31);
					addOffset("singRIGHT", 30, 6);
					addOffset("singLEFT", 45, -6);
					addOffset("singDOWN", -9, -49);

					if(isPlayer)
						bfHealthColor = '0xFF925D57';
					if(!isPlayer)
						dadHealthColor = '0xFF925D57';
	
					playAnim('idle');
			case 'freddy':
					tex = Paths.getSparrowAtlas('characters/freddy');
					frames = tex;
					animation.addByPrefix('idle', 'FREDDY IDLE', 24);
					animation.addByPrefix('singUP', 'FREDDY RIGHT', 24);
					animation.addByPrefix('singRIGHT', 'FREDDY RIGHT', 24);
					animation.addByPrefix('singDOWN', 'FREDDY RIGHT', 24);
					animation.addByPrefix('singLEFT', 'FREDDY RIGHT', 24);
	
					addOffset('idle');
					addOffset("singUP", 20, 31);
					addOffset("singRIGHT", 30, 6);
					addOffset("singLEFT", 45, -6);
					addOffset("singDOWN", -9, -49);

					if(isPlayer)
						bfHealthColor = '0xFF6C3B15';
					if(!isPlayer)
						dadHealthColor = '0xFF6C3B15';
	
					playAnim('idle');
					
			case 'scout':
					tex = Paths.getSparrowAtlas('characters/scout');
					frames = tex;
					animation.addByPrefix('idle', 'scout idle', 24);
					animation.addByPrefix('singUP', 'scout up', 24);
					animation.addByPrefix('singRIGHT', 'scout right', 24);
					animation.addByPrefix('singDOWN', 'scout down', 24);
					animation.addByPrefix('singLEFT', 'scout left', 24);
	
					addOffset('idle');
					addOffset("singUP", -290, 201);
					addOffset("singRIGHT", -170, 6);
					addOffset("singLEFT", 35, 54);
					addOffset("singDOWN", -210, -79);

					if(isPlayer)
						bfHealthColor = '0xFFB85E3B';
					if(!isPlayer)
						dadHealthColor = '0xFFB85E3B';
	
					playAnim('idle');
					
			case 'homer':
					tex = Paths.getSparrowAtlas('characters/homer');
					frames = tex;
					animation.addByPrefix('idle', 'homer idle', 24);
					animation.addByPrefix('singUP', 'homer up', 24);
					animation.addByPrefix('singRIGHT', 'homer right', 24);
					animation.addByPrefix('singDOWN', 'homer down', 24);
					animation.addByPrefix('singLEFT', 'homer left', 24);
	
					addOffset('idle');
					addOffset("singUP", 100, 288);
					addOffset("singRIGHT", 300, 16);
					addOffset("singLEFT", 415, 104);
					addOffset("singDOWN", 453, -19);

					if(isPlayer)
						bfHealthColor = '0xFFFFD624';
					if(!isPlayer)
						dadHealthColor = '0xFFFFD624';
	
					playAnim('idle');
					
			case 'monstershit':
					tex = Paths.getSparrowAtlas('characters/monsterShit');
					frames = tex;
					animation.addByPrefix('idle', 'monster idle', 24);
					animation.addByPrefix('singUP', 'monster up note', 24);
					animation.addByPrefix('singRIGHT', 'monster down', 24);
					animation.addByPrefix('singDOWN', 'Monster left note', 24);
					animation.addByPrefix('singLEFT', 'Monster Right note', 24);
	
					addOffset('idle');
					addOffset("singUP", -20, 50);
					addOffset("singRIGHT", -51);
					addOffset("singLEFT", -30);
					addOffset("singDOWN", -40, -94);

					if(isPlayer)
						bfHealthColor = '0xFFA5004D';
					if(!isPlayer)
						dadHealthColor = '0xFFA5004D';
					
					playAnim('idle');
					
			case 'running-goblin':
					tex = Paths.getSparrowAtlas('characters/running_goblin', 'shared');
					frames = tex;
					animation.addByPrefix('idle', 'idle', 24);
					animation.addByPrefix('singUP', 'up', 24);
					animation.addByPrefix('singRIGHT', 'right', 24);
					animation.addByPrefix('singDOWN', 'down', 24);
					animation.addByPrefix('singLEFT', 'left', 24);
					animation.addByPrefix('hey', 'baba', 24);
		
					addOffset('idle');
					addOffset("singUP", -80, 90);
					addOffset("singRIGHT", -115, 49);
					addOffset("singLEFT", 327, 66);
					addOffset("singDOWN", -64, 50);
					addOffset("hey", -64, 50);

					if(isPlayer)
						bfHealthColor = '0xFF1AB44A';
					if(!isPlayer)
						dadHealthColor = '0xFF1AB44A';
					
		
					playAnim('idle');		
			
			case 'window-watcher':
					tex = Paths.getSparrowAtlas('characters/windowwatcher', 'shared');
					frames = tex;
					animation.addByPrefix('idle', 'windowwatcheridle', 24);
					animation.addByPrefix('singUP', 'up', 24);
					animation.addByPrefix('singRIGHT', 'right', 24);
					animation.addByPrefix('singDOWN', 'down', 24);
					animation.addByPrefix('singLEFT', 'left', 24);
			
					addOffset('idle');
					addOffset("singUP", 4, 131);
					addOffset("singRIGHT", 30, -40);
					addOffset("singLEFT", 201, -17);
					addOffset("singDOWN", -2, -100);
	
					if(isPlayer)
						bfHealthColor = '0xFFCDDEE1';
					if(!isPlayer)
						dadHealthColor = '0xFFCDDEE1';
						
			
					playAnim('idle');
					
			case 'glassgoblin':
					tex = Paths.getSparrowAtlas('characters/glassgoblin', 'shared');
					frames = tex;
					animation.addByPrefix('idle', 'goblinglassidle', 24);
					animation.addByPrefix('singUP', 'goblinglassup', 24);
					animation.addByPrefix('singRIGHT', 'goblinglassright', 24);
					animation.addByPrefix('singDOWN', 'goblinglassdown', 24);
					animation.addByPrefix('singLEFT', 'goblinglassleft', 24);
					animation.addByPrefix('bye', 'goblinfree', 16);

				
					addOffset('idle');
					addOffset("singUP", -3, 70);
					addOffset("singRIGHT", -61, 0);
					addOffset("singLEFT", 80, -5);
					addOffset("singDOWN", -2, -72);
					addOffset("bye", 29, 52);
		
					if(isPlayer)
						bfHealthColor = '0xFFCDDEE1';
					if(!isPlayer)
						dadHealthColor = '0xFFCDDEE1';
						
				
					playAnim('idle');	

			case 'glassbaby':
				tex = Paths.getSparrowAtlas('characters/glassbaby', 'shared');
					frames = tex;
					animation.addByPrefix('idle', 'babyglassidle', 24);
					animation.addByPrefix('singUP', 'babyglassup', 24);
					animation.addByPrefix('singRIGHT', 'babyglassright', 24);
					animation.addByPrefix('singDOWN', 'babyglassdown', 24);
					animation.addByPrefix('singLEFT', 'babyglassleft', 24);
					animation.addByPrefix('bye', 'babyfreeing', 24);
				
					addOffset('idle', 3, 0);
					addOffset("singUP", -3, 80);
					addOffset("singRIGHT", -53, 2);
					addOffset("singLEFT", 105, -4);
					addOffset("singDOWN", 12, -100);
					addOffset("bye", 101, 135);
		
					if(isPlayer)
						bfHealthColor = '0xFFCDDEE1';
					if(!isPlayer)
						dadHealthColor = '0xFFCDDEE1';
						
				
					playAnim('idle');

			case 'player-goblin':
					tex = Paths.getSparrowAtlas('characters/running_goblin', 'shared');
					frames = tex;
					animation.addByPrefix('idle', 'idle', 24);
					animation.addByPrefix('singUP', 'up', 24);
					animation.addByPrefix('singRIGHT', 'right', 24);
					animation.addByPrefix('singDOWN', 'down', 24);
					animation.addByPrefix('singLEFT', 'left', 24);
		
					addOffset('idle');
					addOffset("singUP", -80, 90);
					addOffset("singRIGHT", -115, 49);
					addOffset("singLEFT", 327, 66);
					addOffset("singDOWN", -64, 50);

					if(isPlayer)
						bfHealthColor = '0xFF1AB44A';
					if(!isPlayer)
						dadHealthColor = '0xFF1AB44A';
		
					playAnim('idle');
			case 'evil-baby':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/evil_baby', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'baby 2 idle', 24);
				animation.addByPrefix('singUP', 'baby 2 up', 24);
				animation.addByPrefix('singDOWN', 'baby 2 down', 24);
				// Need to be flipped! REDO THIS LATER!
				animation.addByPrefix('singLEFT', 'baby 2 sing left', 24);
				animation.addByPrefix('singRIGHT', 'baby 2 right', 24);

				addOffset('idle');
				addOffset("singUP", 34, 50);
				addOffset("singRIGHT", -28, -16);
				addOffset("singLEFT", 137, 3);
				addOffset("singDOWN", 8, -77);

				if(isPlayer)
					bfHealthColor = '0xFFB3FFFF';
				if(!isPlayer)
					dadHealthColor = '0xFFB3FFFF';
			
			
				playAnim('idle');
			case 'player-baby':
				tex = Paths.getSparrowAtlas('characters/evilbabyplayer', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'baby 2 idle instance 1', 24, false);
				animation.addByPrefix('singUP', 'baby 2 up instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'baby 2 sing left instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'baby 2 right instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'baby 2 down instance 1', 24, false);
				animation.addByPrefix('singUPmiss', 'upmiss instance 1', 24, false);
				animation.addByPrefix('singLEFTmiss', 'rightmiss instance 1', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'leftmiss instance 1', 24, false);
				animation.addByPrefix('singDOWNmiss', 'downmiss instance 1', 24, false);

				animation.addByPrefix('firstDeath', 'babydie instance 1', 24, false);
				animation.addByPrefix('deathLoop', 'deathloop instance 1', 24, true);
				animation.addByPrefix('deathConfirm', 'death confirm instance 1', 24, false);
				

				addOffset('idle', -5);
				addOffset("singUP", -5, 60);
				addOffset("singRIGHT", -19, 4);
				addOffset("singLEFT", 147, -17);
				addOffset("singDOWN", 37, -74);
				addOffset("singUPmiss", -1, 53);
				addOffset("singRIGHTmiss", 28, 2);
				addOffset("singLEFTmiss", 146, -16);
				addOffset("singDOWNmiss", 52, -84);
				
				

				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 24, 4);
				addOffset('deathConfirm', 27, -252);

				if(isPlayer)
					bfHealthColor = '0xFFB3FFFF';
				if(!isPlayer)
					dadHealthColor = '0xFFB3FFFF';

				playAnim('idle');

				flipX = true;
				
			case 'screamer':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/screamer');
				frames = tex;
				animation.addByPrefix('idle', 'screamer idle', 24);
				animation.addByPrefix('singUP', 'screamer left', 24);
				animation.addByPrefix('singRIGHT', 'screamer right', 24);
				animation.addByPrefix('singDOWN', 'screamer left', 24);
				animation.addByPrefix('singLEFT', 'screamer right', 24);
	
				addOffset('idle');
				addOffset("singUP", 20, 31);
				addOffset("singRIGHT", 30, 6);
				addOffset("singLEFT", 45, -6);
				addOffset("singDOWN", -9, -49);

				if(isPlayer)
					bfHealthColor = '0xFFFFFEDD';
				if(!isPlayer)
					dadHealthColor = '0xFFFFFEDD';
	
				playAnim('idle');
			case 'gametoons':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/gametoons');
				frames = tex;
				animation.addByPrefix('idle', 'gametoons idle', 24);
				animation.addByPrefix('singUP', 'gametoons up', 24);
				animation.addByPrefix('singRIGHT', 'gametoons right', 24);
				animation.addByPrefix('singDOWN', 'gametoons down', 24);
				animation.addByPrefix('singLEFT', 'gametoons right', 24);
	
				addOffset('idle');
				addOffset("singUP", 20, 31);
				addOffset("singRIGHT", 30, 6);
				addOffset("singLEFT", 45, -6);
				addOffset("singDOWN", -9, -49);

				if(isPlayer)
					bfHealthColor = '0xFF66FFFE';
				if(!isPlayer)
					dadHealthColor = '0xFF66FFFE';
		
				playAnim('idle');
			case 'alien':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/alien', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'alien', 24);
				animation.addByPrefix('singUP', 'alien', 24);
				animation.addByPrefix('singRIGHT', 'alien', 24);
				animation.addByPrefix('singDOWN', 'alien', 24);
				animation.addByPrefix('singLEFT', 'alien', 24);
	
				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';
	
				playAnim('idle');
			case 'ron':
				tex = Paths.getSparrowAtlas('characters/Tankman', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "Idle", 24);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('cheer', 'Ugh', 24, false);
				addOffset('idle');
				addOffset("singUP", 42, 38);
				addOffset("singLEFT", 98, -27);
				addOffset("singRIGHT", -89, -51);
				addOffset("singDOWN", 40, -120);
				addOffset("Ugh", 71, -40);

				if(isPlayer)
					bfHealthColor = '0xFFFFD800';
				if(!isPlayer)
					dadHealthColor = '0xFFFFD800';

				playAnim('idle');
			case 'bob':
				tex = Paths.getSparrowAtlas('characters/bob_asset', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);

				if(isPlayer)
					bfHealthColor = '0xFFCCCCCC';
				if(!isPlayer)
					dadHealthColor = '0xFFCCCCCC';

				addOffset('idle');

				playAnim('idle');
			
			case 'bob-ron':
				tex = Paths.getSparrowAtlas('characters/bob_asset', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);

				if(isPlayer)
					bfHealthColor = '0xFFCCCCCC';
				if(!isPlayer)
					dadHealthColor = '0xFFCCCCCC';
	
				addOffset('idle');
	
				playAnim('idle');
			case 'bobcreature':
					// DAD ANIMATION LOADING CODE
						tex = Paths.getSparrowAtlas('characters/bobcreature');
						frames = tex;
						animation.addByPrefix('idle', 'bobcreature', 24);
						animation.addByPrefix('singUP', 'up', 24);
						animation.addByPrefix('singRIGHT', 'right', 24);
						animation.addByPrefix('singDOWN', 'down', 24);
						animation.addByPrefix('singLEFT', 'left', 24);

		
						addOffset('idle');
						addOffset("singUP", 30, 90);
						addOffset("singRIGHT", 4, -14);
						addOffset("singLEFT", 60, -20);
						addOffset("singDOWN", 66, -61);

						if(isPlayer)
							bfHealthColor = '0xFFCCCCCC';
						if(!isPlayer)
							dadHealthColor = '0xFFCCCCCC';
		
						playAnim('idle');
			case 'happy-baby':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/happy_baby');
				frames = tex;
				animation.addByPrefix('idle', 'baby idle', 24);
				animation.addByPrefix('singUP', 'baby up', 24);
				animation.addByPrefix('singRIGHT', 'baby right', 24);
				animation.addByPrefix('singDOWN', 'babydown', 24);
				animation.addByPrefix('singLEFT', 'baby left', 24);
				
	
				addOffset('idle');
				addOffset("singUP", 34, 35);
				addOffset("singRIGHT", 41, 7);
				addOffset("singLEFT", 52, -6);
				addOffset("singDOWN", -5, -49);

				if(isPlayer)
					bfHealthColor = '0xFFB3FFFF';
				if(!isPlayer)
					dadHealthColor = '0xFFB3FFFF';
	
				playAnim('idle');
			case 'kitty':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/kitty');
				frames = tex;
				animation.addByPrefix('idle', 'kittyidle', 24);
				animation.addByPrefix('singUP', 'kittyup', 24);
				animation.addByPrefix('singRIGHT', 'kittyright', 24);
				animation.addByPrefix('singDOWN', 'kittydown', 24);
				animation.addByPrefix('singLEFT', 'kittyleft', 24);
	
				addOffset('idle');
				addOffset("singUP", -1, 31);
				addOffset("singRIGHT", -16, 10);
				addOffset("singLEFT", 29, -6);
				addOffset("singDOWN", -10, -19);

				if(isPlayer)
					bfHealthColor = '0xFFAF5958';
				if(!isPlayer)
					dadHealthColor = '0xFFAF5958';
	
				playAnim('idle');
			case 'myth':
				tex = Paths.getSparrowAtlas('characters/myth_sprites');
				frames = tex;
				animation.addByPrefix('idle', 'baby idle', 24);
				animation.addByPrefix('singUP', 'baby up', 24);
				animation.addByPrefix('singRIGHT', 'baby right', 24);
				animation.addByPrefix('singDOWN', 'baby down', 24);
				animation.addByPrefix('singLEFT', 'baby left', 24);
				animation.addByPrefix('hi', 'baby appear', 24, false);
				animation.addByPrefix('bye', 'baby dissapear', 24, false);
				animation.addByPrefix('gone', 'baby gone', 24);

				if(isPlayer)
					bfHealthColor = '0xFFA5004D';
				if(!isPlayer)
					dadHealthColor = '0xFFA5004D';
		
				addOffset('idle');
				addOffset("singUP", 34, 35);
				addOffset("singRIGHT", 41, 7);
				addOffset("singLEFT", 52, -6);
				addOffset("singDOWN", -5, -20);
				addOffset('hi');
				addOffset('bye');
				addOffset('gone');

				if(isPlayer)
					bfHealthColor = '0xFFB3FFFF';
				if(!isPlayer)
					dadHealthColor = '0xFFB3FFFF';
		
				playAnim('idle');
			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -53, 36);
				addOffset("singRIGHT", -50, -5);
				addOffset("singLEFT", -10, -3);
				addOffset("singDOWN", -8, -44);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", -4, 0);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -7);
				
				if(isPlayer)
					bfHealthColor = '0xFF31B0D1';
				if(!isPlayer)
					dadHealthColor = '0xFF31B0D1';

				playAnim('idle');
			case 'micbf':
					var tex = Paths.getSparrowAtlas('characters/micbf', 'shared');
					frames = tex;
	
					trace(tex.frames.length);
	
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
	
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
	
					animation.addByPrefix('scared', 'BF idle shaking', 24);
	
					addOffset('idle', -5);
					addOffset("singUP", -53, 36);
					addOffset("singRIGHT", -50, -5);
					addOffset("singLEFT", -10, -3);
					addOffset("singDOWN", -8, -44);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", -4, 0);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
					addOffset('scared', -7);
					
					if(isPlayer)
						bfHealthColor = '0xFF31B0D1';
					if(!isPlayer)
						dadHealthColor = '0xFF31B0D1';
	
					playAnim('idle');
	
					flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;
		}
	}

	public function changeCharacter(character:String)
	{
		animationsArray = [];
		animOffsets = [];
		curCharacter = character;
		var characterPath:String = 'characters/$character.json';

		var path:String = Paths.getPath(characterPath, TEXT);
		#if MODS_ALLOWED
		if (!FileSystem.exists(path))
		#else
		if (!Assets.exists(path))
		#end
		{
			path = Paths.getSharedPath('characters/' + DEFAULT_CHARACTER + '.json'); //If a character couldn't be found, change him to BF just to prevent a crash
			missingCharacter = true;
			missingText = new FlxText(0, 0, 300, 'ERROR:\n$character.json', 16);
			missingText.alignment = CENTER;
		}

		try
		{
			#if MODS_ALLOWED
			loadCharacterFile(Json.parse(File.getContent(path)));
			#else
			loadCharacterFile(Json.parse(Assets.getText(path)));
			#end
		}
		catch(e:Dynamic)
		{
			trace('Error loading character file of "$character": $e');
		}

		skipDance = false;
		hasMissAnimations = hasAnimation('singLEFTmiss') || hasAnimation('singDOWNmiss') || hasAnimation('singUPmiss') || hasAnimation('singRIGHTmiss');
		recalculateDanceIdle();
		dance();
	}

	public function loadCharacterFile(json:Dynamic)
	{
		isAnimateAtlas = false;

		#if flxanimate
		var animToFind:String = Paths.getPath('images/' + json.image + '/Animation.json', TEXT);
		if (#if MODS_ALLOWED FileSystem.exists(animToFind) || #end Assets.exists(animToFind))
			isAnimateAtlas = true;
		#end

		scale.set(1, 1);
		updateHitbox();

		if(!isAnimateAtlas)
		{
			frames = Paths.getMultiAtlas(json.image.split(','));
		}
		#if flxanimate
		else
		{
			atlas = new FlxAnimate();
			atlas.showPivot = false;
			try
			{
				Paths.loadAnimateAtlas(atlas, json.image);
			}
			catch(e:haxe.Exception)
			{
				FlxG.log.warn('Could not load atlas ${json.image}: $e');
				trace(e.stack);
			}
		}
		#end

		imageFile = json.image;
		jsonScale = json.scale;
		if(json.scale != 1) {
			scale.set(jsonScale, jsonScale);
			updateHitbox();
		}

		// positioning
		positionArray = json.position;
		cameraPosition = json.camera_position;

		// data
		healthIcon = json.healthicon;
		singDuration = json.sing_duration;
		flipX = (json.flip_x != isPlayer);
		healthColorArray = (json.healthbar_colors != null && json.healthbar_colors.length > 2) ? json.healthbar_colors : [161, 161, 161];
		vocalsFile = json.vocals_file != null ? json.vocals_file : '';
		originalFlipX = (json.flip_x == true);
		editorIsPlayer = json._editor_isPlayer;

		// antialiasing
		noAntialiasing = (json.no_antialiasing == true);
		antialiasing = ClientPrefs.data.antialiasing ? !noAntialiasing : false;

		// animations
		animationsArray = json.animations;
		if(animationsArray != null && animationsArray.length > 0) {
			for (anim in animationsArray) {
				var animAnim:String = '' + anim.anim;
				var animName:String = '' + anim.name;
				var animFps:Int = anim.fps;
				var animLoop:Bool = !!anim.loop; //Bruh
				var animIndices:Array<Int> = anim.indices;

				if(!isAnimateAtlas)
				{
					if(animIndices != null && animIndices.length > 0)
						animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
					else
						animation.addByPrefix(animAnim, animName, animFps, animLoop);
				}
				#if flxanimate
				else
				{
					if(animIndices != null && animIndices.length > 0)
						atlas.anim.addBySymbolIndices(animAnim, animName, animIndices, animFps, animLoop);
					else
						atlas.anim.addBySymbol(animAnim, animName, animFps, animLoop);
				}
				#end

				if(anim.offsets != null && anim.offsets.length > 1) addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
				else addOffset(anim.anim, 0, 0);
			}
		}
		#if flxanimate
		if(isAnimateAtlas) copyAtlasValues();
		#end
		//trace('Loaded file to character ' + curCharacter);
	}

	override function update(elapsed:Float)
	{
		if(isAnimateAtlas) atlas.update(elapsed);

		if(debugMode || (!isAnimateAtlas && animation.curAnim == null) || (isAnimateAtlas && (atlas.anim.curInstance == null || atlas.anim.curSymbol == null)))
		{
			super.update(elapsed);
			return;
		}

		if(heyTimer > 0)
		{
			var rate:Float = (PlayState.instance != null ? PlayState.instance.playbackRate : 1.0);
			heyTimer -= elapsed * rate;
			if(heyTimer <= 0)
			{
				var anim:String = getAnimationName();
				if(specialAnim && (anim == 'hey' || anim == 'cheer'))
				{
					specialAnim = false;
					dance();
				}
				heyTimer = 0;
			}
		}
		else if(specialAnim && isAnimationFinished())
		{
			specialAnim = false;
			dance();
		}
		else if (getAnimationName().endsWith('miss') && isAnimationFinished())
		{
			dance();
			finishAnimation();
		}

		switch(curCharacter)
		{
			case 'pico-speaker':
				if(animationNotes.length > 0 && Conductor.songPosition > animationNotes[0][0])
				{
					var noteData:Int = 1;
					if(animationNotes[0][1] > 2) noteData = 3;

					noteData += FlxG.random.int(0, 1);
					playAnim('shoot' + noteData, true);
					animationNotes.shift();
				}
				if(isAnimationFinished()) playAnim(getAnimationName(), false, false, animation.curAnim.frames.length - 3);
		}

		if (getAnimationName().startsWith('sing')) holdTimer += elapsed;
		else if(isPlayer) holdTimer = 0;

		if (!isPlayer && holdTimer >= Conductor.stepCrochet * (0.0011 #if FLX_PITCH / (FlxG.sound.music != null ? FlxG.sound.music.pitch : 1) #end) * singDuration)
		{
			dance();
			holdTimer = 0;
		}

		var name:String = getAnimationName();
		if(isAnimationFinished() && hasAnimation('$name-loop'))
			playAnim('$name-loop');

		super.update(elapsed);
	}

	inline public function isAnimationNull():Bool
	{
		return !isAnimateAtlas ? (animation.curAnim == null) : (atlas.anim.curInstance == null || atlas.anim.curSymbol == null);
	}

	var _lastPlayedAnimation:String;
	inline public function getAnimationName():String
	{
		return _lastPlayedAnimation;
	}

	public function isAnimationFinished():Bool
	{
		if(isAnimationNull()) return false;
		return !isAnimateAtlas ? animation.curAnim.finished : atlas.anim.finished;
	}

	public function finishAnimation():Void
	{
		if(isAnimationNull()) return;

		if(!isAnimateAtlas) animation.curAnim.finish();
		else atlas.anim.curFrame = atlas.anim.length - 1;
	}

	public function hasAnimation(anim:String):Bool
	{
		return animOffsets.exists(anim);
	}

	public var animPaused(get, set):Bool;
	private function get_animPaused():Bool
	{
		if(isAnimationNull()) return false;
		return !isAnimateAtlas ? animation.curAnim.paused : atlas.anim.isPlaying;
	}
	private function set_animPaused(value:Bool):Bool
	{
		if(isAnimationNull()) return value;
		if(!isAnimateAtlas) animation.curAnim.paused = value;
		else
		{
			if(value) atlas.pauseAnimation();
			else atlas.resumeAnimation();
		}

		return value;
	}

	public var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && !skipDance && !specialAnim)
		{
			if(danceIdle)
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight' + idleSuffix);
				else
					playAnim('danceLeft' + idleSuffix);
			}
			else if(hasAnimation('idle' + idleSuffix))
				playAnim('idle' + idleSuffix);
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		specialAnim = false;
		if(!isAnimateAtlas)
		{
			animation.play(AnimName, Force, Reversed, Frame);
		}
		else
		{
			atlas.anim.play(AnimName, Force, Reversed, Frame);
			atlas.update(0);
		}
		_lastPlayedAnimation = AnimName;

		if (hasAnimation(AnimName))
		{
			var daOffset = animOffsets.get(AnimName);
			offset.set(daOffset[0], daOffset[1]);
		}
		//else offset.set(0, 0);

		if (curCharacter.startsWith('gf-') || curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
				danced = true;

			else if (AnimName == 'singRIGHT')
				danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}
	}

	function loadMappedAnims():Void
	{
		try
		{
			var songData:SwagSong = Song.getChart('picospeaker', Paths.formatToSongPath(Song.loadedSongName));
			if(songData != null)
				for (section in songData.notes)
					for (songNotes in section.sectionNotes)
						animationNotes.push(songNotes);

			TankmenBG.animationNotes = animationNotes;
			animationNotes.sort(sortAnims);
		}
		catch(e:Dynamic) {}
	}

	function sortAnims(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
	}

	public var danceEveryNumBeats:Int = 2;
	private var settingCharacterUp:Bool = true;
	public function recalculateDanceIdle() {
		var lastDanceIdle:Bool = danceIdle;
		danceIdle = (hasAnimation('danceLeft' + idleSuffix) && hasAnimation('danceRight' + idleSuffix));

		if(settingCharacterUp)
		{
			danceEveryNumBeats = (danceIdle ? 1 : 2);
		}
		else if(lastDanceIdle != danceIdle)
		{
			var calc:Float = danceEveryNumBeats;
			if(danceIdle)
				calc /= 2;
			else
				calc *= 2;

			danceEveryNumBeats = Math.round(Math.max(calc, 1));
		}
		settingCharacterUp = false;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function quickAnimAdd(name:String, anim:String)
	{
		animation.addByPrefix(name, anim, 24, false);
	}

	// Atlas support
	// special thanks ne_eo for the references, you're the goat!!
	@:allow(states.editors.CharacterEditorState)
	public var isAnimateAtlas(default, null):Bool = false;
	#if flxanimate
	public var atlas:FlxAnimate;
	public override function draw()
	{
		var lastAlpha:Float = alpha;
		var lastColor:FlxColor = color;
		if(missingCharacter)
		{
			alpha *= 0.6;
			color = FlxColor.BLACK;
		}

		if(isAnimateAtlas)
		{
			if(atlas.anim.curInstance != null)
			{
				copyAtlasValues();
				atlas.draw();
				alpha = lastAlpha;
				color = lastColor;
				if(missingCharacter && visible)
				{
					missingText.x = getMidpoint().x - 150;
					missingText.y = getMidpoint().y - 10;
					missingText.draw();
				}
			}
			return;
		}
		super.draw();
		if(missingCharacter && visible)
		{
			alpha = lastAlpha;
			color = lastColor;
			missingText.x = getMidpoint().x - 150;
			missingText.y = getMidpoint().y - 10;
			missingText.draw();
		}
	}

	public function copyAtlasValues()
	{
		@:privateAccess
		{
			atlas.cameras = cameras;
			atlas.scrollFactor = scrollFactor;
			atlas.scale = scale;
			atlas.offset = offset;
			atlas.origin = origin;
			atlas.x = x;
			atlas.y = y;
			atlas.angle = angle;
			atlas.alpha = alpha;
			atlas.visible = visible;
			atlas.flipX = flipX;
			atlas.flipY = flipY;
			atlas.shader = shader;
			atlas.antialiasing = antialiasing;
			atlas.colorTransform = colorTransform;
			atlas.color = color;
		}
	}

	public override function destroy()
	{
		atlas = FlxDestroyUtil.destroy(atlas);
		super.destroy();
	}
	#end
}
