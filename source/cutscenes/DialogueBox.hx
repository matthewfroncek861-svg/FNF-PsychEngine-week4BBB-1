package cutscenes;

import flixel.addons.text.FlxTypeText;
import backend.Song;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var noMore:Bool = false;
	var skipText:FlxText;
	var cave:FlxSprite;
	var cave2:FlxSprite;
	var cave3:FlxSprite;

	var songName:String = Paths.formatToSongPath(Song.loadedSongName);
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'nap-time':
				if (PlayState.isStoryMode) {
					FlxG.sound.playMusic(Paths.music('babytheme'), 0.485);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
			case 'kidz-bop':
				if (PlayState.isStoryMode) {
					FlxG.sound.playMusic(Paths.music('babytheme'), 0.485);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
			case 'baby-blue':
				if (PlayState.isStoryMode) {
					FlxG.sound.playMusic(Paths.music('babytheme'), 0.485);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
			case 'trackstar':
				if (PlayState.isStoryMode) {
					FlxG.sound.playMusic(Paths.music('bloop'), 0.485);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
			case 'tutorial':

			case 'baby-bob':
				if (PlayState.isStoryMode) {
					FlxG.sound.playMusic(Paths.music('bobdialogue'), 0.485);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}			
			case 'just-like-you':
				if (PlayState.isStoryMode) {
					FlxG.sound.playMusic(Paths.music('bobdialogue'), 0.485);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}		
			case 'insignificance':
				if (PlayState.isStoryMode) 
				{
					if (PlayState.videoDialogue == 1)
					{
						FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0.485);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					}
					else
					{
						FlxG.sound.playMusic(Paths.music('bobcreature'), 0.485);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					}
				}
			case 'babys-lullaby':
				if (PlayState.isStoryMode) {
					FlxG.sound.playMusic(Paths.music('shakey'), 0.485);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}	
			case 'rebound':
					if (PlayState.isStoryMode) {
						FlxG.sound.playMusic(Paths.music('shakey'), 0.485);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					}	
			case 'four-eyes':
				if (PlayState.isStoryMode) 
				{
					if (PlayState.videoDialogue == 1)
					{
						FlxG.sound.playMusic(Paths.music('shakey'), 0.485);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					}
					else if(PlayState.videoDialogue == 4)
					{
						FlxG.sound.playMusic(Paths.music('follow'), 0.485);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					}
				}
			default:
				if (PlayState.isStoryMode) {
					FlxG.sound.playMusic(Paths.music('boomer'), 0.485);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}			
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		cave = new FlxSprite(-150, -100).loadGraphic(Paths.image('cave'));
		cave.screenCenter();
		cave.scrollFactor.set();
		cave.visible = false;
		add(cave);

		cave2 = new FlxSprite(-150, -100).loadGraphic(Paths.image('cave2'));
		cave2.screenCenter();
		cave2.scrollFactor.set();
		cave2.visible = false;
		add(cave2);

		cave3 = new FlxSprite(-150, -100).loadGraphic(Paths.image('cave3'));
		cave3.screenCenter();
		cave3.scrollFactor.set();
		cave3.visible = false;
		add(cave3);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = true;
		switch (songName)
		{
			case 'senpai':
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], '', 24);
			case 'roses':
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance 1', [4], '', 24);
			case 'thorns':
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn instance 1', [11], '', 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'kidz-bop':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking_baby');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'Speech Bubble Normal Open', 24, false);
				box.setGraphicSize(Std.int(box.width * 1 * 0.9));
				box.y = (FlxG.height - box.height) - 20;
			case 'nap-time':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking_baby');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'Speech Bubble Normal Open', 24, false);
				box.setGraphicSize(Std.int(box.width * 1 * 0.9));
				box.y = (FlxG.height - box.height) - 20;
			case 'baby-blue':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking_baby');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'Speech Bubble Normal Open', 24, false);
				box.setGraphicSize(Std.int(box.width * 1 * 0.9));
				box.y = (FlxG.height - box.height) - 20;
			case defualt:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking_baby');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'Speech Bubble Normal Open', 24, false);
				box.setGraphicSize(Std.int(box.width * 1 * 0.9));
				box.y = (FlxG.height - box.height) - 20;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), '', 32);
		swagDialogue.font = Paths.font('pixel-latin.ttf');
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		swagDialogue.borderStyle = SHADOW;
		swagDialogue.borderColor = 0xFFD89494;
		swagDialogue.shadowOffset.set(2, 2);
		add(swagDialogue);

		skipText = new FlxText(FlxG.width - 320, FlxG.height - 30, 300, Language.getPhrase('dialogue_skip', 'Press BACK to Skip'), 16);
		skipText.setFormat(null, 16, FlxColor.WHITE, RIGHT, OUTLINE_FAST, FlxColor.BLACK);
		skipText.borderSize = 2;
		add(skipText);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		super.update(elapsed);

		switch(songName)
		{
			case 'roses':
				portraitLeft.visible = false;
			case 'thorns':
				portraitLeft.visible = false;
				swagDialogue.color = FlxColor.WHITE;
				swagDialogue.borderStyle = NONE;
		}

		if (box.animation.curAnim != null && box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
		{
			box.animation.play('normal');
			dialogueOpened = true;
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(Controls.instance.BACK)
		{
			if (dialogueStarted && !isEnding)
			{
				dialogueCompleted();
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
			}
		}
		else if(Controls.instance.ACCEPT)
		{
			if (dialogueEnded)
			{
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
						dialogueCompleted();
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
				swagDialogue.skip();
				
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
	}

	var isEnding:Bool = false;
	function dialogueCompleted()
	{
		isEnding = true;
		FlxG.sound.play(Paths.sound('clickText'), 0.8);	

		if (songName == 'senpai' || songName == 'thorns')
			FlxG.sound.music.fadeOut(1.5, 0, (_) -> FlxG.sound.music.stop());

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			box.alpha -= 1 / 5;
			bgFade.alpha -= 1 / 5 * 0.7;
			portraitLeft.visible = false;
			portraitRight.visible = false;
			swagDialogue.alpha -= 1 / 5;
			handSelect.alpha -= 1 / 5;
		}, 5);

		swagDialogue.skip();
		skipText.visible = false;
		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			finishThing();
			kill();
		});
	}

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function() {
			handSelect.visible = true;
			dialogueEnded = true;
		};

		handSelect.visible = false;
		dialogueEnded = false;
		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					if (songName == 'senpai') portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'bf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
				swagDialogue.color = FlxColor.fromRGB(80, 165, 235);
				portraitLeft.visible = false;
				cave.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('dialogue/ports');
					portraitRight.animation.addByPrefix('enter', 'boyfriend port', 24, false);
					portraitRight.scale.set(1.3, 1.3);
					portraitRight.antialiasing = true;
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set();
					// portraitRight.screenCenter(X);

					portraitRight.x = (box.x + box.width) - (portraitRight.width) - 90;
					portraitRight.y = box.y + -225;

					portraitRight.visible = true;
					box.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'dream-baby':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
					swagDialogue.color = FlxColor.fromRGB(80, 165, 235);
					portraitLeft.visible = false;
					if (!portraitRight.visible)
					{
						portraitRight.frames = Paths.getSparrowAtlas('dialogue/ports');
						portraitRight.animation.addByPrefix('enter', 'player baby port', 24, false);
						portraitRight.scale.set(1.3, 1.3);
						portraitRight.antialiasing = true;
						portraitRight.updateHitbox();
						portraitRight.scrollFactor.set();
						// portraitRight.screenCenter(X);
	
						portraitRight.x = (box.x + box.width) - (portraitRight.width) - 90;
						portraitRight.y = box.y + -225;
	
						portraitRight.visible = true;
						portraitRight.animation.play('enter');
					}
			case 'baby':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
				swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
					portraitLeft.animation.addByPrefix('enter', 'baby port', 24, false);
					portraitLeft.scale.set(1.3, 1.3);
					portraitLeft.antialiasing = true;
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);

					portraitLeft.x = box.x + 64;
					portraitLeft.y = box.y - 196;

					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'evil-baby':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
				swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
					portraitLeft.animation.addByPrefix('enter', 'evil baby port', 24, false);
					portraitLeft.scale.set(1.3, 1.3);
					portraitLeft.antialiasing = true;
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
	
					portraitLeft.x = box.x + 64;
					portraitLeft.y = box.y - 196;
	
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'goblin':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
				swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
					portraitLeft.animation.addByPrefix('enter', 'goblin port', 24, false);
					portraitLeft.scale.set(1.3, 1.3);
					portraitLeft.antialiasing = true;
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
	
					portraitLeft.x = box.x + 50;
					portraitLeft.y = box.y - 196;
	
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'lol':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
				swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
					portraitLeft.animation.addByPrefix('enter', 'lol port', 24, false);
					portraitLeft.scale.set(1.3, 1.3);
					portraitLeft.antialiasing = true;
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
	
					portraitLeft.x = box.x + 64;
					portraitLeft.y = box.y - 196;
	
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bob':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
				swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
						portraitLeft.animation.addByPrefix('enter', 'bob port', 24, false);
						portraitLeft.scale.set(1.3, 1.3);
						portraitLeft.antialiasing = true;
						portraitLeft.updateHitbox();
						portraitLeft.scrollFactor.set();
						// portraitLeft.screenCenter(X);
		
						portraitLeft.x = box.x + 64;
						portraitLeft.y = box.y - 196;
		
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
			case 'ron':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
					swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
					portraitRight.visible = false;
					if (!portraitLeft.visible)
						{
							portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
							portraitLeft.animation.addByPrefix('enter', 'ron port', 24, false);
							portraitLeft.scale.set(1.3, 1.3);
							portraitLeft.antialiasing = true;
							portraitLeft.updateHitbox();
							portraitLeft.scrollFactor.set();
							// portraitLeft.screenCenter(X);
			
							portraitLeft.x = box.x + 64;
							portraitLeft.y = box.y - 196;
			
							portraitLeft.visible = true;
							portraitLeft.animation.play('enter');
						}
			case 'og-bob':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
					swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
					portraitRight.visible = false;
					if (!portraitLeft.visible)
						{
							portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
							portraitLeft.animation.addByPrefix('enter', 'normal bob port', 24, false);
							portraitLeft.scale.set(1.3, 1.3);
							portraitLeft.antialiasing = true;
							portraitLeft.updateHitbox();
							portraitLeft.scrollFactor.set();
							// portraitLeft.screenCenter(X);
			
							portraitLeft.x = box.x + 64;
							portraitLeft.y = box.y - 196;
			
							portraitLeft.visible = true;
							portraitLeft.animation.play('enter');
						}
			case 'window':
						swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
						swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
						portraitRight.visible = false;
						cave2.visible = false;
						cave.visible = false;
						cave3.visible = false;
						box.visible = true;
						if (!portraitLeft.visible)
							{
								portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
								portraitLeft.animation.addByPrefix('enter', 'window port', 24, false);
								portraitLeft.scale.set(1.3, 1.3);
								portraitLeft.antialiasing = true;
								portraitLeft.updateHitbox();
								portraitLeft.scrollFactor.set();
								// portraitLeft.screenCenter(X);
				
								portraitLeft.x = box.x + 64;
								portraitLeft.y = box.y - 196;
				
								portraitLeft.visible = true;
								portraitLeft.animation.play('enter');
							}
			case 'cave1':
								swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
								swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
								portraitRight.visible = false;
								if (!portraitLeft.visible)
									{
										cave.visible = true;
										portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
										portraitLeft.animation.addByPrefix('enter', 'window port', 24, false);
										portraitLeft.scale.set(1.3, 1.3);
										portraitLeft.antialiasing = true;
										portraitLeft.updateHitbox();
										portraitLeft.scrollFactor.set();
										// portraitLeft.screenCenter(X);
						
										portraitLeft.x = box.x + 64;
										portraitLeft.y = box.y - 196;
						
										portraitLeft.visible = true;
										portraitLeft.animation.play('enter');
									}
				case 'cave2':
									swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
									swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
									portraitRight.visible = false;
									if (!portraitLeft.visible)
										{
											cave2.visible = true;
											portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
											portraitLeft.animation.addByPrefix('enter', 'window port', 24, false);
											portraitLeft.scale.set(1.3, 1.3);
											portraitLeft.antialiasing = true;
											portraitLeft.updateHitbox();
											portraitLeft.scrollFactor.set();
											// portraitLeft.screenCenter(X);
							
											portraitLeft.x = box.x + 64;
											portraitLeft.y = box.y - 196;
							
											portraitLeft.visible = false;
											box.visible = false;
											portraitLeft.animation.play('enter');
										}
				case 'cave3':
										swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
										swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
										portraitRight.visible = false;
										if (!portraitLeft.visible)
											{
												cave3.visible = true;
												portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
												portraitLeft.animation.addByPrefix('enter', 'window port', 24, false);
												portraitLeft.scale.set(1.3, 1.3);
												portraitLeft.antialiasing = true;
												portraitLeft.updateHitbox();
												portraitLeft.scrollFactor.set();
												// portraitLeft.screenCenter(X);
								
												portraitLeft.x = box.x + 64;
												portraitLeft.y = box.y - 196;
								
												portraitLeft.visible = false;
												box.visible = false;
												portraitLeft.animation.play('enter');
											}
				
			case 'video':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
					swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
					portraitRight.visible = false;
					if (!portraitLeft.visible)
							{
							portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
							portraitLeft.animation.addByPrefix('enter', 'normal bob port', 24, false);
							portraitLeft.scale.set(1.3, 1.3);
							portraitLeft.antialiasing = true;
							portraitLeft.updateHitbox();
							portraitLeft.scrollFactor.set();
							// portraitLeft.screenCenter(X);
					
							portraitLeft.x = box.x + 64;
							portraitLeft.y = box.y - 196;
							noMore = true;
							portraitLeft.visible = false;
							box.visible = false;
							portraitLeft.animation.play('enter');
							}
					if (PlayState.videoDialogue == 1)
						{
							PlayState.videoDialogue += 1;
							LoadingState.loadAndSwitchState(new VideoState(Paths.video('bobcut3'), new PlayState()));
						}
					if (PlayState.videoDialogue == 2)
						{
							PlayState.videoDialogue += 1;
							LoadingState.loadAndSwitchState(new VideoState(Paths.video('bobcut3'), new PlayState()));
						}
			case 'video2':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
					swagDialogue.color = FlxColor.fromRGB(26, 96, 237);
					portraitRight.visible = false;
					if (!portraitLeft.visible)
						{
							portraitLeft.frames = Paths.getSparrowAtlas('dialogue/ports');
							portraitLeft.animation.addByPrefix('enter', 'normal bob port', 24, false);
							portraitLeft.scale.set(1.3, 1.3);
							portraitLeft.antialiasing = true;
							portraitLeft.updateHitbox();
							portraitLeft.scrollFactor.set();
							// portraitLeft.screenCenter(X);
							
							portraitLeft.x = box.x + 64;
							portraitLeft.y = box.y - 196;
							noMore = true;
							portraitLeft.visible = false;
							box.visible = false;
							portraitLeft.animation.play('enter');
						}
					if (PlayState.videoDialogue == 1)
						{
							PlayState.videoDialogue += 1;
							LoadingState.loadAndSwitchState(new VideoState(Paths.video('fourcut1'), new PlayState()));
						}
					if (PlayState.videoDialogue == 2)
						{
							
							PlayState.videoDialogue += 1;
							trace(PlayState.videoDialogue);
							LoadingState.loadAndSwitchState(new VideoState(Paths.video('fourcut1'), new PlayState()));
						}
					if (PlayState.videoDialogue == 4)
						{
								
							//PlayState.videoDialogue += 1;
							trace(PlayState.videoDialogue);
							LoadingState.loadAndSwitchState(new VideoState(Paths.video('fourcut2'), new PlayState()));
						}

		}
		if(nextDialogueThing != null)
			nextDialogueThing();
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(':');
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
