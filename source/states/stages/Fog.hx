package states.stages;

import flixel.system.FlxAssets.FlxGraphicAsset;
import backend.BaseStage;
import states.stages.objects.*;
import states.PlayState;
import backend.Controls;

class Fog extends BaseStage
{
	// If you're moving your stage from PlayState to a stage file,
	// you might have to rename some variables if they're missing, for example: camZooming -> game.camZooming
	
	public var lx = 200;
	public var ly = 500;
	public var rx = 800;
	public var ry = 300;
	var lefthand:FlxSprite;
	var righthand:FlxSprite;
	var light:FlxSprite;
	var stag:FlxSprite;
	var foggy:FlxSprite;

	var leftvocs:FlxSound = new FlxSound();
	var rightvocs:FlxSound = new FlxSound(); 
	var backvocs:FlxSound = new FlxSound(); 
	var frontvocs:FlxSound = new FlxSound();

	public var opf = 0;
	public var plf = 0;

	public var controls(get, never):Controls;
    private function get_controls()
    {
        return Controls.instance;
    }
	
	override function create()
	{
		lefthand = new FlxSprite(lx, ly, Paths.image("lefthand"));
		righthand = new FlxSprite(rx, ry, Paths.image("righthand"));
		light = new FlxSprite(lx+311, ly-419, Paths.image("lightbeam"));
		
		stag = new FlxSprite(0,0,Paths.image("bg"));
		foggy = new FlxSprite(0,0);
		foggy.frames = Paths.getSparrowAtlas("bgfog");
		foggy.animation.addByPrefix('idle', 'fog', 4);
		foggy.animation.play('idle');
		foggy.blend = "add";
		foggy.alpha = 0.7;
		trace("loaded fog stage");
		// Spawn your stage sprites here.
		// Characters are not ready yet on this function, so you can't add things above them yet.
		// Use createPost() if that's what you want to do.
		new FlxTimer().start(1.5, moveleft, 0);
		new FlxTimer().start(1.3, moveright, 0);

		leftvocs.loadEmbedded(Paths.voices('fog', 'Left'));
		rightvocs.loadEmbedded(Paths.voices('fog', 'Right'));
		backvocs.loadEmbedded(Paths.voices('fog', 'Back'));
		frontvocs.loadEmbedded(Paths.voices('fog', 'Opponent'));

		FlxG.sound.list.add(leftvocs);
		FlxG.sound.list.add(rightvocs);
		FlxG.sound.list.add(backvocs);
		FlxG.sound.list.add(frontvocs);
		

		
		leftvocs.volume=0;
		rightvocs.volume=0;
		backvocs.volume=0;
		frontvocs.volume=0;

	}
	
	override function createPost()
	{
		// Use this function to layer things above characters!
		lefthand.camera = game.camHUD;
		righthand.camera = game.camHUD;
		light.camera = game.camHUD;
		light.blend = "screen";
		light.alpha = 0.4;
		game.dadGroup.blend = "darken";
		add(light);
		add(lefthand);
		add(righthand);
		addBehindDad(stag);
		addBehindDad(foggy);
		
	}

	override function update(elapsed:Float)
	{
		light.x = lefthand.x+311;
		light.y = lefthand.y-419;
		if(controls.justPressed('turn_left')){
			trace("func is doing left");
			plf=(plf+3)%4;
		}
		else if(controls.justPressed('turn_right')){
			trace("func is doing right");
			plf=(plf+1)%4;
		}
		rupd();
		
	}

	public function rupd() {
		switch (Math.abs(opf-plf)){
			case 0:
				frontvocs.volume=1;
				leftvocs.volume=0;
				rightvocs.volume=0;
				backvocs.volume=0;
			case 1:
				frontvocs.volume=0;
				leftvocs.volume=0;
				rightvocs.volume=1;
				backvocs.volume=0;
			case 2:
				frontvocs.volume=0;
				leftvocs.volume=0;
				rightvocs.volume=0;
				backvocs.volume=1;
			case 3:
				frontvocs.volume=0;
				leftvocs.volume=1;
				rightvocs.volume=0;
				backvocs.volume=0;
		}
	}

	function moveleft(timer:FlxTimer){
		var newx = random(lx-100, lx+100);
		var newy = random(ly-100, ly+100);
		if(random(1,5)>3){
			FlxTween.tween(lefthand, { x: newx, y: newy }, 2.0, { ease: FlxEase.expoInOut });
		}
	}

	function moveright(timer:FlxTimer){
		var newx = random(rx-100, rx+100);
		var newy = random(ry-100, ry+100);
		if(random(1,5)>3){
			FlxTween.tween(righthand, { x: newx, y: newy }, 2.0, { ease: FlxEase.expoInOut });
		}
	}

	public function random(min:Int, max:Int){
		return min + Std.int(Math.random() * (max - min + 1));
	}

	
	override function countdownTick(count:Countdown, num:Int)
	{
		switch(count)
		{
			case THREE: //num 0
			case TWO: //num 1
			case ONE: //num 2
			case GO: //num 3
			case START:
				leftvocs.play();
				rightvocs.play();
				backvocs.play();
				frontvocs.play(); //num 4
		}
	}

	// Steps, Beats and Sections:
	//    curStep, curDecStep
	//    curBeat, curDecBeat
	//    curSection
	override function stepHit()
	{
		// Code here
	}
	override function beatHit()
	{
		if(curBeat==96){
			
		}
	}
	override function sectionHit()
	{
		trace('opf $opf');
		trace('plf $plf');
	}

	// Substates for pausing/resuming tweens and timers
	override function closeSubState()
	{
		if(paused)
		{
			//timer.active = true;
			//tween.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			//timer.active = false;
			//tween.active = false;
		}
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "behave":
				switch(value1){
					case "spin":
						if(value2=="a"){
							opf=(plf+2)%4;
						} else {
							opf=random(0,3);
						}
					case "check":
						if(opf!=plf){
							frontvocs.fadeOut(0.5);
							backvocs.fadeOut(0.5);
							leftvocs.fadeOut(0.5);
							rightvocs.fadeOut(0.5);
							frontvocs.destroy();
							backvocs.destroy();
							leftvocs.destroy();
							rightvocs.destroy();
							game.health=0;
						}
				}
		}
	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events that doesn't need different assets based on its values
		switch(event.event)
		{
			case "My Event":
				//precacheImage('myImage') //preloads images/myImage.png
				//precacheSound('mySound') //preloads sounds/mySound.ogg
				//precacheMusic('myMusic') //preloads music/myMusic.ogg
		}
	}
	override function eventPushedUnique(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events where its values affect what assets should be preloaded
		switch(event.event)
		{
			case "My Event":
				switch(event.value1)
				{
					// If value 1 is "blah blah", it will preload these assets:
					case 'blah blah':
						//precacheImage('myImageOne') //preloads images/myImageOne.png
						//precacheSound('mySoundOne') //preloads sounds/mySoundOne.ogg
						//precacheMusic('myMusicOne') //preloads music/myMusicOne.ogg

					// If value 1 is "coolswag", it will preload these assets:
					case 'coolswag':
						//precacheImage('myImageTwo') //preloads images/myImageTwo.png
						//precacheSound('mySoundTwo') //preloads sounds/mySoundTwo.ogg
						//precacheMusic('myMusicTwo') //preloads music/myMusicTwo.ogg
					
					// If value 1 is not "blah blah" or "coolswag", it will preload these assets:
					default:
						//precacheImage('myImageThree') //preloads images/myImageThree.png
						//precacheSound('mySoundThree') //preloads sounds/mySoundThree.ogg
						//precacheMusic('myMusicThree') //preloads music/myMusicThree.ogg
				}
		}
	}
}