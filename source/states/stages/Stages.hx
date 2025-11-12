package states.stages;

import states.stages.objects.*;
import objects.*;
import states.*;
import backend.*;
import cutscenes.*;
import states.PlayState.SONG;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import backend.Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl3.*;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;

class Stages extends BaseStage
{
	public static var runningGoblin:Character;
	public static var dadAgain:Character;
	public static var boyfriendAgain:Character;

	var bobmadshake:FlxSprite;
	var bobsound:FlxSound;
	var isbobmad:Bool = true;
	var appearscreen:Bool = true;

	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }
	var dadAgainSinging:Bool = false;
	var dadAgainExist:Bool = false;
	var dadSinging:Bool = true;
	var boyfriendAgainSinging:Bool = false;
	var boyfriendAgainExist:Bool = false;
	var runningGoblinSinging:Bool = false;
	var runningGoblinExist:Bool = false;
	var boyfriendSigning:Bool =true;

	public var health:Float = 1; //making public because sethealth doesnt work without it

	private var gfSpeed:Int = 1;

	private var curSong:String = "";

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?

	public static var curStage:String = '';

	var chairummmm:FlxSprite;
	
	var chair2:FlxSprite;
	var table2:FlxSprite;
	var monitor:FlxSprite;
	var pot:FlxSprite;

	var poopmario:FlxSprite;

	var filters:Array<BitmapFilter> = [];
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	var bgevil:FlxSprite;
	var epiclight:FlxSprite;
	var windowpoppers:FlxSprite;

	var fleedgoblin:FlxSprite;
	var fleedbaby:FlxSprite;
	var coolshadergayshitlol:Bool = true;

	var blackUmm:FlxSprite;

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;	

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var goblinDeath:FlxSprite;
	var babaPopup:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var crib:FlxSprite;
	var floorSkew:FlxSkewedSprite;

	var camPos:FlxPoint;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	override function create()
	{
		switch(SONG.stage)
		{
			case 'crib':
				{
						curStage = 'crib';
						defaultCamZoom = 1;
						var bg:FlxSprite = new FlxSprite(-200, -540).loadGraphic(Paths.image('floor'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						add(bg);
				}
			case 'crib2':
				{
						curStage = 'crib2';
						defaultCamZoom = 1;
						var bg:FlxSprite = new FlxSprite(-200, -540).loadGraphic(Paths.image('floor2'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						add(bg);
				}			
			case 'street':
				{
						curStage = 'street';
						defaultCamZoom = 0.9;
						var bg:FlxSprite = new FlxSprite(-420, -188).loadGraphic(Paths.image('street'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						add(bg);
				}		
			case 'crib3':
				{
						curStage = 'crib3';
						defaultCamZoom = 1;
						var hallowTex = Paths.getSparrowAtlas('brokencrib');

						var halloweenBG:FlxSprite = new FlxSprite(-275, -100);
						halloweenBG.scrollFactor.set(1, 1);
						halloweenBG.frames = hallowTex;
						halloweenBG.animation.addByPrefix('idle', 'brokenhouse');
						halloweenBG.animation.play('idle');
						halloweenBG.antialiasing = true;
						add(halloweenBG);
				}
			case 'dream':
				{
						curStage = 'dream';
						defaultCamZoom = 1.1;

						var dreamyThing:FlxSprite = new FlxSprite(-170, -100).loadGraphic(Paths.image('dreambg'));
						dreamyThing.scrollFactor.set();
						add(dreamyThing);
						wiggleShit.effectType = WiggleEffectType.FLAG;
						wiggleShit.waveAmplitude = 0.1;
						wiggleShit.waveFrequency = 2;
						wiggleShit.waveSpeed = 1;
						dreamyThing.shader = wiggleShit.shader;

						var bg:FlxSprite = new FlxSprite(-120, -120).loadGraphic(Paths.image('flor'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						add(bg);

						var hallowTex = Paths.getSparrowAtlas('dreamtv');
						var halloweenBG:FlxSprite = new FlxSprite(135, 125);
						halloweenBG.scrollFactor.set(0.9, 0.9);
						halloweenBG.frames = hallowTex;
						halloweenBG.animation.addByPrefix('idle', 'true');
						halloweenBG.animation.play('idle');
						halloweenBG.antialiasing = true;
						add(halloweenBG);
						bobmadshake = new FlxSprite( -198, -118).loadGraphic(Paths.image('bobscreen', 'shared'));
						bobmadshake.scrollFactor.set(0, 0);
						bobmadshake.visible = false;
							
						bobsound = new FlxSound().loadEmbedded(Paths.sound('bobscreen'));
				}		
			case 'phlox':
				{
					curStage = 'phlox';
					defaultCamZoom = 1.0;

					var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('phloxbg'));
					bg.antialiasing = true;
					bg.scrollFactor.set();
					bg.active = false;
					add(bg);
					
					var phloxtweets:FlxSprite = new FlxSprite(-170, 120).loadGraphic(Paths.image('gayshit'));
					phloxtweets.antialiasing = true;
					phloxtweets.scrollFactor.set(0.6, 0.6);
					phloxtweets.active = false;
					add(phloxtweets);

					var ground:FlxSprite = new FlxSprite(-350, 780).loadGraphic(Paths.image('phloxground'));
					ground.setGraphicSize(Std.int(ground.width * 1.7));
					ground.antialiasing = true;
					ground.scrollFactor.set(0.8, 0.8);
					ground.active = false;
					add(ground);

					var phloxsign:FlxSprite = new FlxSprite(600, 430).loadGraphic(Paths.image('phloxsign'));
					phloxsign.antialiasing = true;
					phloxsign.scrollFactor.set(0.9, 0.9);
					phloxsign.active = false;
					add(phloxsign);

					var babaTex = Paths.getSparrowAtlas('BABA');
					babaPopup = new FlxSprite(-30, -30);
					babaPopup.frames = babaTex;
					babaPopup.animation.addByPrefix('baba', "BABA!", 23);
					babaPopup.antialiasing = true;
					babaPopup.scrollFactor.set(0, 0);
					babaPopup.visible = false;
				}
			case 'evilhospital':
			{
					curStage = 'evilhospital';

					defaultCamZoom = 0.9;

					var bg:FlxSprite = new FlxSprite(-320, -100).loadGraphic(Paths.image('evilhospital'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 1.1));
					bg.updateHitbox();
					add(bg);

					var hallowTex = Paths.getSparrowAtlas('windowbrocken');
					var halloweenBG:FlxSprite = new FlxSprite(-304, 138);
					halloweenBG.scrollFactor.set(0.9, 0.9);
					halloweenBG.scale.set(1.2, 1.2);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'evil window instance');
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = true;
					add(halloweenBG);

					var chair2:FlxSprite = new FlxSprite(1149, 115).loadGraphic(Paths.image('evilchair'));
					chair2.antialiasing = true;
					chair2.scrollFactor.set(0.9, 0.9);
					chair2.active = false;
					chair2.visible = false;
					chair2.setGraphicSize(Std.int(chair2.width * 1.1));
					chair2.updateHitbox();

					var table2:FlxSprite = new FlxSprite(902, 350).loadGraphic(Paths.image('eviltable'));
					table2.antialiasing = true;
					table2.scrollFactor.set(0.9, 0.9);
					table2.active = false;
					table2.visible = false;
					table2.setGraphicSize(Std.int(table2.width * 1.1));
					table2.updateHitbox();
			
					
					var monitor:FlxSprite = new FlxSprite(437, 37).loadGraphic(Paths.image('evilmonitor'));
					monitor.antialiasing = true;
					monitor.scrollFactor.set(0.9, 0.9);
					monitor.active = false;

					monitor.visible = false;
					monitor.setGraphicSize(Std.int(monitor.width * 1.25));
					monitor.updateHitbox();
			
					var pot:FlxSprite = new FlxSprite(1052, 175).loadGraphic(Paths.image('potfloater'));
					pot.antialiasing = true;
					pot.scrollFactor.set(0.9, 0.9);
					pot.active = false;
					pot.visible = false;
					pot.setGraphicSize(Std.int(pot.width * 1.2));
					pot.updateHitbox();
					
					//THIS IS SO WHEN NEW CHARACTERS COME IN IT DOESNT EXPLODE
					var v1:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('characters/glassbaby'));
					v1.antialiasing = true;
					v1.scrollFactor.set();
					v1.active = false;
					v1.updateHitbox();
					v1.alpha = 0;
					add(v1);

					var v2:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('characters/glassgoblin'));
					v2.antialiasing = true;
					v2.scrollFactor.set();
					v2.active = false;
					v2.updateHitbox();
					v2.alpha = 0;
					add(v2);

					var v3:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('characters/micbf'));
					v3.antialiasing = true;
					v3.scrollFactor.set();
					v3.active = false;
					v3.updateHitbox();
					v3.alpha = 0;
					add(v3);
					//ugly fat shit poop
					var bgevil:FlxSprite = new FlxSprite(-826, -383).loadGraphic(Paths.image('windowbgpng'));
					bgevil.scrollFactor.set(1, 1);
					bgevil.active = false;
					bgevil.updateHitbox();
					bgevil.antialiasing = true;
					add(bgevil);

					var windowTex = Paths.getSparrowAtlas('windowpoppers');
					var windowpoppers:FlxSprite = new FlxSprite(63, 112);
					windowpoppers.scrollFactor.set(1, 1);
					windowpoppers.frames = windowTex;
					windowpoppers.animation.addByPrefix('idle', 'windowpoppers');
					windowpoppers.animation.play('idle');
					windowpoppers.visible = false;
					windowpoppers.antialiasing = true;
					add(windowpoppers);

					var epiclight:FlxSprite = new FlxSprite(-167, -65).loadGraphic(Paths.image('epiclight'));
					epiclight.scrollFactor.set(1, 1);
					epiclight.active = false;
					epiclight.updateHitbox();
					epiclight.antialiasing = true;

					var goblintexturruru = Paths.getSparrowAtlas('freedgoblin');
	
					var fleedgoblin:FlxSprite = new FlxSprite(1070, 580);
					fleedgoblin.frames = goblintexturruru;
					fleedgoblin.animation.addByPrefix('idle', "freedgoblin", 24);
					fleedgoblin.antialiasing = true;
					fleedgoblin.visible = false;
					//add(fleedgoblin);
					fleedgoblin.animation.play('idle');

					var babybluefuckhead = Paths.getSparrowAtlas('babyfreedirl');
	
					var fleedbaby:FlxSprite = new FlxSprite(1150, 600);
					fleedbaby.frames = babybluefuckhead;
					fleedbaby.animation.addByPrefix('idle', "babyfreedirl", 24);
					fleedbaby.antialiasing = true;
					fleedbaby.visible = false;
					//add(fleedbaby);
					fleedbaby.animation.play('idle');
					
			}

			case 'hospital':
				{
						curStage = 'hospital';
	
						defaultCamZoom = 0.9;
	
						var bg:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('hospitalBack'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 1.1));
						bg.updateHitbox();
						add(bg);
	
						var chairummmm:FlxSprite = new FlxSprite(-500, -100).loadGraphic(Paths.image('chairLOL'));
						chairummmm.antialiasing = true;
						chairummmm.scrollFactor.set(0.9, 0.9);
						chairummmm.active = false;
						chairummmm.setGraphicSize(Std.int(chairummmm.width * 1.1));
						chairummmm.updateHitbox();

						var poopmario:FlxSprite = new FlxSprite(20, -540).loadGraphic(Paths.image('floor'));
						poopmario.antialiasing = true;
						poopmario.scrollFactor.set(1, 1);
						poopmario.active = false;
						poopmario.visible = false;
						add(poopmario);
				}

			case 'bathroom':
				{
					curStage = 'bathroom';
					defaultCamZoom = 0.65;

					var bg:FlxSprite = new FlxSprite(-320, -220).loadGraphic(Paths.image('brfloor'));
					bg.antialiasing = true;
					bg.scrollFactor.set();
					bg.active = false;
					add(bg);
				}
			case 'testshitlol':
				{
					floorSkew = new FlxSkewedSprite(100, -50,Paths.image('dreambg'));
					floorSkew.scrollFactor.set(1,1);
					add(floorSkew);
				}
		}
	}
	
	var doof:DialogueBox = null;
	function initDoof()
	{
		var file:String = Paths.txt('$songName/dialogue_${ClientPrefs.data.language}');
		#if MODS_ALLOWED
		if (!FileSystem.exists(file))
		#else
		if (!OpenFlAssets.exists(file))
		#end
		{
			file = Paths.txt('$songName/dialogue');
		}

		#if MODS_ALLOWED
		if (!FileSystem.exists(file))
		#else
		if (!OpenFlAssets.exists(file))
		#end
		{
			startCountdown();
			return;
		}

		doof = new DialogueBox(false, CoolUtil.coolTextFile(file));
		doof.cameras = [camHUD];
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = PlayState.instance.startNextDialogue;
		doof.skipDialogueThing = PlayState.instance.skipDialogue;
	}

	function Bobismad()
		{
			bobmadshake.visible = true;
			bobmadshake.alpha = 0.95;
			bobsound.play();
			bobsound.volume = 1;
			isbobmad = false;
			shakescreen();
			new FlxTimer().start(0.5 , function(tmr:FlxTimer)
			{
				resetBobismad();
			});
		}

	function shakescreen()
		{
			camera.shake(0.02,0.5);
		}

	function resetBobismad():Void
		{
			bobsound.pause();
			bobmadshake.visible = false;
			bobsound.volume = 0;
			isbobmad = true;
		}

	override function createPost()
	{
		if (curStage == 'stage' || curStage == 'hospital')
			add(gf);

		if (curStage == 'hospital')
		{
			add(chairummmm);
		}
		else if (curStage == 'evilhospital')
		{
			add(chair2);
			add(table2);
			add(monitor);
			add(pot);
		}

		if (curStage == 'evilhospital')
		{
			add(epiclight);
			add(fleedgoblin);
			add(fleedbaby);
			
			var grain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('grain'));
			grain.antialiasing = true;
			grain.scrollFactor.set();
			grain.alpha = .5;
			add(grain);
			grain.cameras = [camHUD];
		}
		if(curStage == 'bathroom')
		{
			var grain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('grain2'));
			grain.antialiasing = true;
			add(grain);
			grain.cameras = [camHUD];
			blackUmm = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			add(blackUmm);
			blackUmm.cameras = [camHUD];
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'street':
				boyfriend.x += 240;
				dad.x += 160;
				dad.y += 17;
			case 'dream':
				dad.y -= 37;
				dad.x -= 80;
				boyfriend.y -= 37;
				boyfriend.x -= 3;
			case 'hospital':
				boyfriend.x += 240;
				gf.y += 350;
				gf.x += 300;
				dad.x += 100;
			case 'bathroom':
				boyfriend.x += 1000;
				dad.x += 0; //who did this FUCK YOU.
				dad.x -= 0;
				dad.y += 500;
        }

		if (curSong.toLowerCase() == 'nap-time') {
			curStage = 'crib';
        }
        if (curSong.toLowerCase() == 'kidz-bop') {
			curStage = 'crib2';
        }
        if (curSong.toLowerCase() == 'baby-blue') {
			curStage = 'crib2';
        }
        if (curSong.toLowerCase() == 'temper-tantrum') {
			curStage = 'crib3';
        }
        if (curSong.toLowerCase() == 'babys-revenge') {
			curStage = 'crib3';
        }
        if (curSong.toLowerCase() == 'un-adieu') {
			curStage = 'testshitlol';
        }
        if (curSong.toLowerCase() == 'trackstar') {
			curStage = 'street';
        }
		if (curSong.toLowerCase() == 'baby-bob') {
			curStage = 'dream';
        }
        if (curSong.toLowerCase() == 'just-like-you') {
			curStage = 'phlox';
        }
        if (curSong.toLowerCase() == 'insignificance') {
			curStage = 'phlox';
        }
        if (curSong.toLowerCase() == 'babys-lullaby') {
			curStage = 'hospital';
        }
        if (curSong.toLowerCase() == 'rebound') {
			curStage = 'hospital';
        }
        if (curSong.toLowerCase() == 'four-eyes') {
			curStage = 'evilhospital';
        }

		switch (PlayState.SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'pico':
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
			case 'baby':
				dad.y += 440;
				dad.x += 120;
			case 'miku':
				dad.y += 100;
			case 'tinky':
				dad.y += 100;
				dad.x += 120;
			case 'pewdiepie':
				dad.y += 300;
				dad.x += 120;
			case 'freddy':
				dad.y += 150;
				dad.x += 120;
			case 'scout':
				dad.y += 150;
				dad.x -= 120;
			case 'homer':
				camPos.x -= 600;
				dad.y += 150;
				dad.x -= 150;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'running-goblin':
				dad.y += 430;
				dad.x += 110;
			case 'evil-baby':
				dad.y += 350;
				dad.x += 125;
			case 'gametoons':
				dad.y += 370;
				dad.x += 200;
			case 'alien':
				dad.y += 230;
				dad.x += 0;
			case 'bob':	
				dad.y += 290;
			case 'bob-ron':	
				dad.y += 290;
			case 'ron':
				dad.y += 268;
				dad.x -= 27;
			case 'bobcreature':
				dad.y += 278;
				dad.x -= 70;
			case 'happy-baby':
				dad.y += 440;
				dad.x += 120;
			case 'kitty':
				dad.y += 440;
				dad.x += 120;
			case 'myth':
				dad.y -= 75;
				dad.x += 200;
			case 'window-watcher':
				dad.x += 75;
				dad.y += 280;
				FlxTween.tween(dad, {x: 260}, 2, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
				FlxTween.tween(dad, {y: 180}, 6, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
            }
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}
	function changeDaddy(id:String)
		{
			var olddadx = dad.x;
			var olddady = dad.y;
			remove(dad);
			add(dad);
			iconP2.animation.play(id);
			trace('did it work, just maybe, just maybe');
		}
	function changeBf(id:String)
			{                
				var olddadx = boyfriend.x;
				var olddady = boyfriend.y;
				remove(boyfriend);
				add(boyfriend);
			}
	function babaFrontPopup():Void
	{
		babaPopup.visible = true;
		babaPopup.animation.play('baba');
		new FlxTimer().start(1 , function(tmr:FlxTimer)
		{
			babaPopup.destroy();
		});
	}

	override function stepHit()
	{
		super.stepHit();

		//THIS IS THE WORST CODE EVER WHY DID I DO THIS
		//baby blue character changing
		if (curStep == 888 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == -150;
            dad.x == 150;
			changeDaddy('homer');
		}
		if (curStep == 1040 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 150;
            dad.x == 120;
			changeDaddy('freddy');
		}
		if (curStep == 1205 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 150;
            dad.x == -120;
			changeDaddy('scout');
		}
		if (curStep == 1365 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 100;
            dad.x == 120;
			changeDaddy('tinky');
		}
		if (curStep == 1536 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 180;
            dad.x == 120;
			changeDaddy('miku');
		}
		if (curStep == 1679 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 440;
            dad.x == 120;
			changeDaddy('baby');
		}
		if (curStep >= 2111 && curStep <= 2128 && curSong.toLowerCase() == 'baby-blue')
			{
				//used to spam on 1.4.2 OOPS!!!
				health += 0.4;
			}
		if (curStep == 2250 && curSong.toLowerCase() == 'baby-blue')
		{
			changeDaddy('monstershit');
		}
		if (curStep == 2448 && curSong.toLowerCase() == 'baby-blue')
		{
			changeDaddy('baby');
		}
		if (curStep == 3226 && curSong.toLowerCase() == 'baby-blue')
		{
			changeDaddy('pewdiepie');
		}
		if (curStep == 3407 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 440;
            dad.x == 120;
			changeDaddy('baby');
		}
		//gametoons lol
		if (curStep == 278 && curSong.toLowerCase() == 'gametoons')
			{
				changeDaddy('screamer');
			}
		// FOUR EYES
	
		//trackstar lol
		if (FlxG.save.data.cameraeffect)
		{
			if (curStep == 96 && curSong.toLowerCase() == 'trackstar')
				{
					trace('it worked');
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 102 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 112 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 160 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 166 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 176 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 224 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 230 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 240 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 288 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 294 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 304 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 352 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 358 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 368 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 415 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 422 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 432 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 480 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 486 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 496 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 544 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 550 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 560 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 608 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 614 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 624 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 672 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 678 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 688 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 736 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 742 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 752 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 800 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 806 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 816 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1248 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1254 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1264 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1312 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1318 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1328 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1376 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1382 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1391 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1439 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1446 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1455 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
		}
		if (curStep == 1599 && curSong.toLowerCase() == 'trackstar')
				{
					dad.visible = false;
					var goblinDeathTex = Paths.getSparrowAtlas('goblindeath');
	
					goblinDeath = new FlxSprite(-960, 270);
					goblinDeath.frames = goblinDeathTex;
					goblinDeath.animation.addByPrefix('drive', "goblin death", 24);
					goblinDeath.antialiasing = true;
					add(goblinDeath);
					goblinDeath.animation.play('drive');
					FlxG.sound.play(Paths.sound('baba'));
				}
		//un adieu, i actucally added this on acident but it turned out good
		if (FlxG.save.data.cameraeffect)
		{
			if (curStep == 184 && curSong.toLowerCase() == 'un-adieu')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
		}
		if (curStep == 704 && curSong.toLowerCase() == 'un-adieu')
			{
				FlxG.camera.fade(FlxColor.BLACK, 13, false);
			}
		//poop revenge
		if (FlxG.save.data.cameraeffect)
		{
			if (curStep == 40 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}
			if (curStep == 41 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 42 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 43 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 44 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}		
			if (curStep == 45 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}		
			if (curStep == 46 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}		
			if (curStep == 47 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}		
			if (curStep == 56 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 57 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 58 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 59 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 60 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}
			if (curStep == 61 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}
			if (curStep == 62 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}
			if (curStep == 63 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}
			if (curStep == 64 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}

			if (curStep == 768 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}

			if (curStep == 784 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}

			if (curStep == 788 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}

			if (curStep == 792 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
					}

			if (curStep == 800 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
					}

		}
		//kitty test (testing other dad)
		if (curStage == 'crib' && curSong.toLowerCase() == 'kitty')
				{
					switch (curStep)
					{
						case 1:
							dadAgainSinging = true;
						case 32:
							dadAgainSinging = true;
						
					}
				}
				//turns in just like you
		if (curStage == 'phlox' && curSong.toLowerCase() == 'just-like-you')
				{
					switch (curStep)
					{
						case 128:
							dadSinging = false;
							dadAgainSinging = true;
						case 256:
							dadSinging = true;
							dadAgainSinging = false;
						case 384:
							dadSinging = true;
							dadAgainSinging = true;
						case 640:
							dadAgainSinging = false;
						case 656:
							dadSinging = false;
							dadAgainSinging = true;
						case 704:
							dadSinging = true;
							dadAgainSinging = false;
						case 712:
							dadSinging = false;
							dadAgainSinging = true;
						case 768:
							dadSinging = true;
							dadAgainSinging = true;
					}
				}
		if (curStage == 'phlox' && curSong.toLowerCase() == 'just-like-you')
				{
					switch (curStep)
					{
						case 191:
							boyfriendSigning = false;
							boyfriendAgainSinging = true;
						case 319:
							boyfriendSigning = true;
							boyfriendAgainSinging = false;
						case 447:
							boyfriendSigning = true;
							boyfriendAgainSinging = true;
						case 671:
							boyfriendSigning = true;
							boyfriendAgainSinging = false;
						case 688:
							boyfriendSigning = false;
							boyfriendAgainSinging = true;
						case 719:
							boyfriendSigning = true;
							boyfriendAgainSinging = false;
						case 727:
							boyfriendSigning = false;
							boyfriendAgainSinging = true;
						case 831:
							boyfriendSigning = true;
							boyfriendAgainSinging = true;
					}
				}
				//trace(FlxG.camera.x);
				//baby bob hardcoded in eyeballs
		if (curStage == 'dream' && curSong.toLowerCase() == 'baby-bob')
				{
					switch (curStep)
					{
							case 12:
								Bobismad();
							case 44:
								Bobismad();
							case 76:
								Bobismad();
							case 108:
								Bobismad();
							case 160:
								Bobismad();
							case 224:
								Bobismad();
							case 272:
								Bobismad();
							case 336:
								Bobismad();
							case 382:
								Bobismad();
							case 392:
								Bobismad();
							case 432:
								Bobismad();
							case 456:
								Bobismad();
							case 496:
								Bobismad();
							case 576:
								Bobismad();
							case 620:
								Bobismad();
							case 656:
								Bobismad();
							case 836:
								Bobismad();
							case 908:
								Bobismad();
							case 928:
								Bobismad();
					}
				}
		if (curSong.toLowerCase() == 'insignificance')
			{
				switch (curStep)
				{
					case 1174:
						babaFrontPopup();
				}
			}		
		if (curSong.toLowerCase() == 'insignificance')
			{
				switch (curStep)
				{
					case 10:
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 543:
						boyfriendSigning = true;
						boyfriendAgainSinging = false;
					case 575:
						boyfriendSigning = false;
						boyfriendAgainSinging = true;
					case 607:
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 671:
						boyfriendSigning = true;
						boyfriendAgainSinging = false;
					case 735:
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 799:
						boyfriendSigning = false;
						boyfriendAgainSinging = true;
					case 928:
						if (FlxG.save.data.cameraeffect)
							{
								defaultCamZoom = 1.45;
								camera.flash(FlxColor.BLACK, 6.0);
							}
					case 948:
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 1048:
						if (FlxG.save.data.cameraeffect)
						{
							camera.shake(0.03,0.7);
							defaultCamZoom = 1.05;
						}
					case 1178:
						runningGoblin.x -= 200;
						runningGoblin.y += 170;
						runningGoblin = new Character(runningGoblin.x, runningGoblin.y, 'player-goblin');
						add(runningGoblin);
						runningGoblinExist = true;
						iconP1.animation.play('bf-baby-goblin');
					case 1183:
						//goblins turn
						boyfriendSigning = false;
						boyfriendAgainSinging = false;
						runningGoblinSinging = true;
						boyfriend.playAnim('idle');
						boyfriendAgain.playAnim('idle');
						defaultCamZoom = 1.10;
						//look at all this code that is useless :|
						camFollow.setPosition(runningGoblin.getMidpoint().x, runningGoblin.getMidpoint().y);
					case 1439:
						FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0)))));
						camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
						defaultCamZoom = 1.05;
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 1583:
						changeBf('alien');
						
				}
			}

			if (curSong.toLowerCase() == 'babys-lullaby')
				{
					switch (curStep)
					{
						case 384:
							if (FlxG.save.data.cameraeffect)
								{
									defaultCamZoom = 1.45;
									camera.flash(FlxColor.WHITE, 5.0);
									chairummmm.visible = false;
									poopmario.visible = true;
									//crib.visible = true;

								}
						case 640:
							if (FlxG.save.data.cameraeffect)
								{
									defaultCamZoom = 0.9;
									camera.flash(FlxColor.WHITE, 5.0);
									chairummmm.visible = true;
									poopmario.visible = false;
									//crib.visible = false;
												
								}
						case 1216:
							if (FlxG.save.data.cameraeffect)
								{
									defaultCamZoom = 1.1;
								}
					}
				}
			
			if (curSong.toLowerCase() == 'four-eyes')
			{
				switch(curStep)
				{
					case 1:
						defaultCamZoom = 1.05;
					case 1184:
						//Window Watcher P1 Ends
						
					case 1209:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom - 0.025}, 0.5, {
							ease: FlxEase.quadInOut
						});
						FlxTween.tween(FlxG.camera, {alpha: .3}, 0.5, {
							ease: FlxEase.quadInOut
						});
					case 1217:
						//Running Goblin Starts

					case 1824:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1826:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1840:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1841:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1842:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1843:	
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1888:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1890:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1904:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1905:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1906:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1907:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1952:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1954:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1968:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1969:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1970:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1971:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2016:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2018:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2032:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2033:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2034:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2035:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2080:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2082:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2096:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2097:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2098:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2099:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2144:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2146:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2160:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2161:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2162:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2163:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2561:
						//Baby Blue Part Starts
					case 4347:
						dad.playAnim('bye');
					case 4415:
						//Window Watcher Starts
				}
			}
			
			
			/*
			if (curSong.toLowerCase() == 'tutorial-2')
				{
					switch (curStep)
					{
						//BIGSHIT
						case 131:
						redFlashing();
					}
				}
			}
			*/

	}
	
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (curSong.toLowerCase() == 'trackstar' && curBeat >= 208 && curBeat < 304)
			{
				FlxG.camera.zoom += 0.10;
				camHUD.zoom += 0.02;
			}
		if (curSong.toLowerCase() == 'four-eyes' && curBeat >= 1024 && curBeat <= 1088)
			{
				FlxG.camera.zoom += 0.10;
				camHUD.zoom += 0.025;
			}
		if (curSong.toLowerCase() == 'four-eyes' && curBeat >= 1328 && curBeat <= 1423)
				{
					FlxG.camera.zoom += 0.07;
					camHUD.zoom += 0.025;
				}
		if (curSong.toLowerCase() == 'rebound')
			{
				switch(curBeat)
				{
					case 2:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.4}, 2.49, {
							ease: FlxEase.quadInOut
						});
					case 6:
						defaultCamZoom = 1.3;
					case 8:
						defaultCamZoom = 1;
					case 72:
						defaultCamZoom = 0.9;
					case 84:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.2}, 1.66, {
							ease: FlxEase.quadInOut
						});
					case 88:
						defaultCamZoom = 1;
					case 152:
						defaultCamZoom = 1.25;
					case 168:
						defaultCamZoom = 1;
					case 228:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.1}, 1.66, {
							ease: FlxEase.quadInOut
						});
					case 292:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.1}, 1.66, {
							ease: FlxEase.quadInOut
						});
					case 356:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.2}, 1.66, {
							ease: FlxEase.quadInOut
						});
					case 360:
						defaultCamZoom = 0.9;
				}
			}


		if (curSong.toLowerCase() == 'rebound' && curBeat >= 8 && curBeat < 72)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;
				//FlxTween.tween(camHUD, {y: 0}, 0.5, {
				//	ease: FlxEase.quartOut
				//});

			}
		if (curSong.toLowerCase() == 'rebound' && curBeat >= 88 && curBeat < 152)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;


			}
		if (curSong.toLowerCase() == 'rebound' && curBeat >= 168 && curBeat < 228)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;
			}
		if (curSong.toLowerCase() == 'rebound' && curBeat >= 232 && curBeat < 292)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;
			}
		if (curSong.toLowerCase() == 'rebound' && curBeat >= 296 && curBeat < 360)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;
			}
		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
			if(boyfriendAgainExist)
				boyfriendAgain.playAnim('idle');
			if(runningGoblinExist)
				runningGoblin.playAnim('idle');
		}

		if (!dad.animation.curAnim.name.startsWith("sing") && !dad.animation.curAnim.name.startsWith("hi") && !dad.animation.curAnim.name.startsWith("bye"))
		{
			if(curSong == 'myth' && (curBeat > 353 || curBeat < 28)) {
				dad.playAnim('gone', true);
			} else {
				dad.dance();
			}
			FlxG.camera.targetOffset.y = 0;
			FlxG.camera.targetOffset.x = 0;
			if (dadAgainExist)
				dadAgain.dance();
		}

		if (curSong == 'myth')
		{
			switch(curBeat)
			{
				case 2:
					//at 2 because haxeflixel lags at beat 0 and dont plays the thing LOL
					blackUmm.visible = false;
				case 28:
					dad.playAnim('hi', true);
				case 353:
					dad.playAnim('bye', true);
			}
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat == 47 && curSong == 'trackstar')
		{
			dad.playAnim('hey', true);
		}

		if (curBeat == 79 && curSong == 'trackstar')
		{
			dad.playAnim('hey', true);
		}

		//rebound shit
		if (curBeat == 23 && curSong == 'Rebound')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat == 39 && curSong == 'Rebound')
		{
			dad.playAnim('hey', true);
		}

		if (curBeat == 247 && curSong == 'Rebound')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat == 263 && curSong == 'Rebound')
		{
			dad.playAnim('hey', true);
		}

		if (curBeat == 295 && curSong == 'Rebound')
			{
				boyfriend.playAnim('hey', true);
			}

			if (curBeat > 294 && curBeat < 296 && curSong == 'Rebound')
				{
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.4}, 0.2, {
						ease: FlxEase.quadInOut
					});
				}

		if (curBeat == 327 && curSong == 'Rebound')
			{
				dad.playAnim('hey', true);
			}

		if (curSong.toLowerCase() == 'four-eyes')
				{
					switch(curBeat)
					{
						case 0:
							//
						case 16:
							defaultCamZoom = 1.1;
						case 30:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom - 0.3}, 1.8, {
								ease: FlxEase.quadInOut
							});
						case 36:
							defaultCamZoom = 2;
						case 40:
							defaultCamZoom = 0.9;
						case 294:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.5}, 0.7, {
								ease: FlxEase.quadIn
							});
						case 296:
							//end of windowwathcers part
							coolshadergayshitlol = false;
							health -= .75;
							camHUD.visible = false;
							camGame.alpha = 0;
							epiclight.visible = false;
							bgevil.visible = false;
							windowpoppers.visible = false;
							chairummmm.visible = true;
							chair2.visible = true;
							table2.visible = true;
							monitor.visible = true;
							pot.visible = true;
						case 304:
							coolshadergayshitlol = true;
							defaultCamZoom = 1.25;
							camGame.alpha = 1;
							camHUD.visible = true;
							changeDaddy('glassgoblin');
							SONG.player2 = ("glassgoblin");
						case 320:
							defaultCamZoom = 1.05;
						case 558:
							defaultCamZoom = 1.3;
						case 624:
							coolshadergayshitlol = false;
							SONG.player2 = ("window-watcher");
							health -= 1;
							dad.playAnim('bye');
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.2}, 1.6, {
								ease: FlxEase.quadInOut
							});
						case 625:
							FlxTween.tween(camGame, {alpha: 0}, 1.4, {
								ease: FlxEase.quadInOut
							});
							FlxTween.tween(camHUD, {alpha: 0}, 1.4, {
								ease: FlxEase.quadInOut
							});
						case 629:
							camHUD.alpha = 0;
							camGame.alpha = 0;
							defaultCamZoom = 1.05;
						case 640:
							coolshadergayshitlol = true;
							fleedgoblin.visible = true;
							camHUD.alpha = 1;
							camGame.alpha = 1;
							FlxG.camera.zoom += 0.3;
							camHUD.zoom += 0.1;
							SONG.player2 = ("glassbaby");
							changeDaddy('glassbaby');
						case 800:
							defaultCamZoom = 1.15;
						case 926:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom - 0.25}, 1.6, {
								ease: FlxEase.quadInOut
							});
						case 930:
							defaultCamZoom = 0.9;
						case 943:
							defaultCamZoom = 1.05;
						case 992:
							defaultCamZoom = 1.25;
						case 1088:
							health -= 1.25;
						case 1095:
							camGame.x += 300;
							defaultCamZoom = 5;
						case 1099:
							defaultCamZoom = 0.9;
							health -= 1;
							fleedbaby.visible = true;
							camGame.x -= 300;
							changeBf('micbf');
							SONG.player2 = ("window-watcher");
							SONG.player1 = ("micbf");
							changeDaddy('window-watcher');
							FlxTween.tween(dad, {x: 260}, 2, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
							FlxTween.tween(dad, {y: 180}, 6, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
						case 1178:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1194:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1210:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1226:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1306:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1322:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1324:
							defaultCamZoom = 1.15;
						case 1328:
							FlxG.camera.zoom += 0.3;
							camHUD.zoom += 0.1;
							defaultCamZoom = 1;
						case 1426:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom - .7}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1428:
							defaultCamZoom = 1.1;
						case 1460:
							camGame.visible = false;
						case 1464:
							FlxG.camera.zoom += 0.3;
							camHUD.zoom += 0.1;
							camGame.visible = true;
						case 1560:
							defaultCamZoom = 1;
						case 1624:
							FlxG.camera.fade(FlxColor.WHITE, 1.33, false);
					}
				}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
