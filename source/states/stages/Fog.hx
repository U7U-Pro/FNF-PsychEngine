package states.stages;

import substates.GameOverSubstate;
import haxe.Timer;
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
	public var rx = 900;
	public var ry = 400;
	var lefthand:FlxSprite;
	var righthand:FlxSprite;
	var light:FlxSprite;
	var stag:FlxSprite;
	var stagl:FlxSprite;
	var stagr:FlxSprite;
	var foggy:FlxSprite;
	var foggyl:FlxSprite;
	var foggyr:FlxSprite;

	var leftvocs:FlxSound = new FlxSound();
	var rightvocs:FlxSound = new FlxSound(); 
	var backvocs:FlxSound = new FlxSound(); 
	var frontvocs:FlxSound = new FlxSound();

	public var opf = 0;
	public var plf = 0;
	var poop:String;

	public var canTurn:Bool = true;

	var score:Int;
	public var shit=0;

	public var controls(get, never):Controls;
    private function get_controls()
    {
        return Controls.instance;
    }
	
	override function create()
	{
		lefthand = new FlxSprite(lx, ly, Paths.image("lefthand"));
		lefthand.setGraphicSize(Std.int(lefthand.width*0.7), Std.int(lefthand.height*0.7));
		lefthand.updateHitbox();
		righthand = new FlxSprite(rx, ry);
		righthand.frames = Paths.getSparrowAtlas("righthand");
		righthand.animation.addByPrefix('idle', 'idle');
		righthand.animation.addByPrefix('up', 'up');
		righthand.animation.addByPrefix('down', 'down');
		righthand.animation.addByPrefix('left', 'left');
		righthand.animation.addByPrefix('right', 'right');
		righthand.animation.play('idle');
		righthand.setGraphicSize(Std.int(righthand.width*0.7), Std.int(righthand.height*0.7));
		righthand.updateHitbox();
		light = new FlxSprite(lx+311, ly-419, Paths.image("lightbeam"));
		
		stag = new FlxSprite(0,0,Paths.image("bg"));
		stagl=stag;
		stagl.x=stag.x-stag.width;
		stagr=stag;
		stagr.x=stag.x+stag.width;
		foggy = new FlxSprite(0,0);
		foggy.frames = Paths.getSparrowAtlas("bgfog");
		foggy.animation.addByPrefix('idle', 'fog', 4);
		foggy.animation.play('idle');
		foggy.blend = "add";
		foggy.alpha = 0.7;
		foggyl=foggy;
		foggyr=foggy;
		foggyl.x=foggy.x-foggy.width;
		foggyr.x=foggy.x-foggy.width;
		trace("loaded fog stage");
		// Spawn your stage sprites here.
		// Characters are not ready yet on this function, so you can't add things above them yet.
		// Use createPost() if that's what you want to do.
		new FlxTimer().start(1.3, moveleft, 0);
		new FlxTimer().start(1.4, moveright, 0);

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
		light.setGraphicSize(Std.int(light.width*0.7), Std.int(light.height*0.7));
		game.dadGroup.blend = "darken";
		add(light);
		add(lefthand);
		add(righthand);
		addBehindDad(stag);
		addBehindDad(stagr);
		addBehindDad(stagl);
		addBehindDad(foggy);
		addBehindDad(foggyl);
		addBehindDad(foggyr);
		boyfriendGroup.alpha=0;
		resetBg(FlxTween.tween(light, {}, 0));
	}

	override function update(elapsed:Float)
	{
		light.x = lefthand.x+Std.int(311*0.7);
		light.y = lefthand.y-Std.int(419*0.7);
		if(controls.justPressed('turn_left')){
			if(canTurn){ //YOU TURN LEFT SHIT GOES RIGHT
				plf=(plf+3)%4;
				canTurn=false;
				FlxTween.tween(foggy, { x: foggy.x+foggy.width }, 0.4, { ease: FlxEase.expoInOut});
				FlxTween.tween(foggyl, { x: foggyl.x+foggyl.width }, 0.4, { ease: FlxEase.expoInOut});
				FlxTween.tween(stag, { x: stag.x+stag.width }, 0.4, { ease: FlxEase.expoInOut, onComplete: resetBg});
				FlxTween.tween(stagl, { x: stagl.x+stagl.width }, 0.4, { ease: FlxEase.expoInOut});
				FlxTween.tween(dadGroup, {x:dadGroup.x+stag.width}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
				//trace('left $plf');
			}
			else{
				GameOverSubstate.characterName = "brokenneck";
				game.health=0;
			}
		}
		else if(controls.justPressed('turn_right')){
			if(canTurn){ //TURN RIGHT SHIT GOES LEFT HOLY FUCK
				plf=(plf+1)%4;
				canTurn=false;
				FlxTween.tween(foggy, { x: foggy.x-foggy.width }, 0.4, { ease: FlxEase.expoInOut});
				FlxTween.tween(foggyr, { x: foggyr.x-foggyr.width }, 0.4, { ease: FlxEase.expoInOut});
				FlxTween.tween(stag, { x: stag.x-stag.width }, 0.4, { ease: FlxEase.expoInOut, onComplete: resetBg});
				FlxTween.tween(stagr, { x: stagr.x-stagr.width }, 0.4, { ease: FlxEase.expoInOut});
				FlxTween.tween(dadGroup, {x:dadGroup.x-stag.width}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
				//trace('right $plf');
			}
			else{
				GameOverSubstate.characterName = "brokenneck";
				game.health=0;
			}
		}
		rupd();

		if(controls.NOTE_DOWN){
			righthand.animation.play('down');
		}
		if(controls.NOTE_LEFT){
			righthand.animation.play('left');
		}
		if(controls.NOTE_RIGHT){
			righthand.animation.play('right');
		}
		if(controls.NOTE_UP){
			righthand.animation.play('up');
		}
		if(controls.NOTE_DOWN_R  || controls.NOTE_LEFT_R || controls.NOTE_RIGHT_R || controls.NOTE_UP_R){
			righthand.animation.play('idle');
		}
	}


	public function checkDadLoc(tween:FlxTween){
		switch(poop){
			case "front":
				dadGroup.x=stag.x;
			case "left":
				dadGroup.x=-1*stag.width;
			case "right":
				dadGroup.x=stag.width;
			case "back":
				dadGroup.x=-2*stag.width;
		}
	}

	public function rupd() {
		
		if(opf==plf)
			poop="front";
		else if(opf==(plf+1)%4)
			poop="right";
		else if(opf==(plf+3)%4)
			poop="left";
		else
			poop="back";
		try{
			switch (poop){
				case "front":
					frontvocs.volume=1;
					leftvocs.volume=0;
					rightvocs.volume=0;
					backvocs.volume=0;
				case "right":
					frontvocs.volume=0;
					leftvocs.volume=0;
					rightvocs.volume=1;
					backvocs.volume=0;
				case "back":
					frontvocs.volume=0;
					leftvocs.volume=0;
					rightvocs.volume=0;
					backvocs.volume=1;
				case "left":
					frontvocs.volume=0;
					leftvocs.volume=1;
					rightvocs.volume=0;
					backvocs.volume=0;
			}
		}
		catch(e){
			throw(e);
		}
	}

	public function resetBg(tween:FlxTween) {
		trace('reset bg');
		
		stag.x=0;
		stagl.x=stag.x-stag.width;
		stagr.x=stag.x+stag.width;
		foggy.x=0;
		foggyl.x=foggy.x-foggy.width;
		foggyr.x=foggy.x+foggy.width;
		canTurn=true;
		
		trace('bgs:');
		trace(stagl.x);
		trace(stag.x);
		trace(stagr.x);
		trace('fogs:');
		trace(foggyl.x);
		trace(foggy.x);
		trace(foggyr.x);
	}


	function moveleft(timer:FlxTimer){
		var newx = random(lx-50, lx+50);
		var newy = random(ly-50, ly+50);
		if(random(1,5)>3){
			FlxTween.tween(lefthand, { x: newx, y: newy }, 2.0, { ease: FlxEase.expoInOut });
		}
	}

	function moveright(timer:FlxTimer){
		var newx = random(rx-50, rx+50);
		var newy = random(ry-50, ry+50);
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
				frontvocs.play();
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
			shit=1;
		}
	}
	override function sectionHit()
	{
		//trace(poop);

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
							frontvocs.stop();
							backvocs.stop();
							leftvocs.stop();
							rightvocs.stop();
							FlxG.sound.list.clear();
							FlxG.sound.list.killMembers();
							GameOverSubstate.characterName="choke";
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