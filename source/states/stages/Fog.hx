package states.stages;

import flixel.system.FlxAssets.FlxGraphicAsset;
import backend.BaseStage;
import states.stages.objects.*;
import states.PlayState;

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
	
	
	override function create()
	{
		lefthand = new FlxSprite(lx, ly, Paths.image("lefthand"));
		righthand = new FlxSprite(rx, ry, Paths.image("righthand"));
		light = new FlxSprite(lx+311, ly-419, Paths.image("lightbeam"));
		
		stag = new FlxSprite(0,0,Paths.image("bg"));
		trace("loaded fog stage");
		trace('lx: $lx');
		// Spawn your stage sprites here.
		// Characters are not ready yet on this function, so you can't add things above them yet.
		// Use createPost() if that's what you want to do.
		new FlxTimer().start(1.5, moveleft, 0);
		new FlxTimer().start(1.3, moveright, 0);
	}
	
	override function createPost()
	{
		// Use this function to layer things above characters!
		lefthand.camera = game.camHUD;
		righthand.camera = game.camHUD;
		light.camera = game.camHUD;
		add(light);
		add(lefthand);
		add(righthand);
		
	}

	override function update(elapsed:Float)
	{
		light.x = lefthand.x+311;
		light.y = lefthand.y-419;
	}

	function moveleft(timer:FlxTimer){
		var newx = random(lx-100, lx+100);
		var newy = random(ly-100, ly+100);
		var difx = newx-lx;
		var dify = newy-ly;
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

	
	/*override function countdownTick(count:BaseStage.Countdown, num:Int)
	{
		switch(count)
		{
			case THREE: //num 0
			case TWO: //num 1
			case ONE: //num 2
			case GO: //num 3
			case START: //num 4
		}
	}*/

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
		// Code here
	}
	override function sectionHit()
	{
		// Code here
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
			case "My Event":
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