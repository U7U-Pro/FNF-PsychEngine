package states.stages;

import backend.Song;
import backend.Song.SwagSong;
import flixel.addons.plugin.taskManager.FlxTask;
import objects.Note;
import objects.StrumNote;
import psychlua.FunkinLua;
import openfl.filters.ShaderFilter;
import shaders.OverlayShader;
import flixel.tweens.misc.VarTween;
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
	var behind:FlxSprite = new FlxSprite(200, 300, Paths.image('behind'));
	var you:FlxSprite = new FlxSprite(600, 500, Paths.image('you'));
	var turn:FlxSprite = new FlxSprite(600, 100, Paths.image('turn'));
	var around:FlxSprite = new FlxSprite(200, 500, Paths.image('around'));

	var leftvocs:FlxSound = new FlxSound();
	var rightvocs:FlxSound = new FlxSound(); 
	var backvocs:FlxSound = new FlxSound(); 
	var frontvocs:FlxSound = new FlxSound();

	public var opf = 0;
	public var plf = 0;
	var poop:String;

	public var canTurn:Bool = true;

	var t1:FlxTween; 
	var t2:FlxTween;
	var t3:FlxTween;
	var t4:FlxTween;
	var t5:FlxTween;
	var t6:FlxTween;
	var t7:FlxTween;

	public var controls(get, never):Controls;
    private function get_controls()
    {
        return Controls.instance;
    }

	var camMovement = 30;
	var velocity = 2;

	var campointx = 0;
	var campointy = 0;
	var camlockx = 0;
	var camlocky = 0;
	var camlock = false;
	var bfturn = false;
	var camon = true;
	
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
		light = new FlxSprite(lx+217, ly-293, Paths.image("lightbeam"));
		
		stag = new FlxSprite(0,0,Paths.image("bg"));
		stagl=stag.clone();
		stagl.x=stag.x-stag.width;
		stagr=stag.clone();
		stagr.x=stag.x+stag.width;
		foggy = new FlxSprite(0,0);
		foggy.frames = Paths.getSparrowAtlas("bgfog");
		foggy.animation.addByPrefix('idle', 'fog', 4);
		foggy.animation.play('idle');
		foggy.blend = "add";
		foggy.alpha = 0.7;
		foggyl=foggy.clone();
		foggyr=foggy.clone();
		foggyl.x=foggy.x-foggy.width;
		foggyr.x=foggy.x-foggy.width;
		trace("loaded fog stage");

		behind.camera = game.camHUD;
		you.camera = game.camHUD;
		turn.camera = game.camHUD;
		around.camera = game.camHUD;
		behind.alpha=0;
		you.alpha=0;
		turn.alpha=0;
		around.alpha=0;

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

		stag.camera = game.camGame;
		stagl.camera = game.camGame;
		stagr.camera = game.camGame;
		foggy.camera = game.camGame;
		foggyl.camera = game.camGame;
		foggyr.camera = game.camGame;
		add(stag);
		add(stagr);
		add(stagl);
		add(foggy);
		add(foggyl);
		add(foggyr);

		game.startLuasNamed('Fog');
		game.startLuasNamed('cameraMovement');

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
		add(behind);
		add(you);
		add(turn);
		add(around);
		
		boyfriendGroup.alpha=0;
		resetBg(FlxTween.tween(light, {}, 0));
	}

	override function update(elapsed:Float)
	{
		light.x = lefthand.x+140;
		light.y = lefthand.y-350;
		if(controls.justPressed('turn_left')){
			if(canTurn){ //YOU TURN LEFT SHIT GOES RIGHT
				plf=(plf+3)%4;
				canTurn=false;
				FlxTween.tween(foggy, { x: foggy.x+foggy.width }, 0.4, { ease: FlxEase.expoInOut});
				FlxTween.tween(foggyl, { x: foggyl.x+foggyl.width }, 0.4, { ease: FlxEase.expoInOut});
				FlxTween.tween(stag, { x: stag.x+stag.width }, 0.4, { ease: FlxEase.expoInOut, onComplete: resetBg});
				FlxTween.tween(stagl, { x: stagl.x+stagl.width }, 0.4, { ease: FlxEase.expoInOut});
				t1 = FlxTween.tween(dadGroup, {x:dadGroup.x+stag.width}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
				t1.start();
				FlxTween.tween(lefthand, {x:lefthand.x+1000}, 0.3, {ease: FlxEase.expoInOut, onComplete: resethands});
				FlxTween.tween(righthand, {x:righthand.x+1000}, 0.3, {ease: FlxEase.expoInOut});
			}
			else{
				GameOverSubstate.characterName = "brokenneck";
				GameOverSubstate.deathSoundName = "brokenneck";
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
				t2 = FlxTween.tween(dadGroup, {x:dadGroup.x-stag.width}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
				t2.start();
				FlxTween.tween(lefthand, {x:lefthand.x-1000}, 0.3, {ease: FlxEase.expoInOut, onComplete: resethands});
				FlxTween.tween(righthand, {x:righthand.x-1000}, 0.3, {ease: FlxEase.expoInOut});
			}
			else{
				GameOverSubstate.characterName = "brokenneck";
				GameOverSubstate.deathSoundName = "brokenneck";
				game.health=0;
			}
		}
		rupd();
		

		if(controls.NOTE_DOWN_P){
			if(righthand.y<ry+50){
				FlxTween.tween(righthand, {y: righthand.y+40},0.1,{ease:FlxEase.expoInOut});
			}
		}
		if(controls.NOTE_LEFT_P){
			if(righthand.x>rx-50){
				FlxTween.tween(righthand, {x: righthand.x-40},0.1,{ease:FlxEase.expoInOut});
			}
		}
		if(controls.NOTE_RIGHT_P){
			if(righthand.x<rx+50){
				FlxTween.tween(righthand, {x: righthand.x+40},0.1,{ease:FlxEase.expoInOut});
			}
		}
		if(controls.NOTE_UP_P){
			if(righthand.y>ry-50){
				FlxTween.tween(righthand, {y: righthand.y-40},0.1,{ease:FlxEase.expoInOut});
			}
		}
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
		if(!isTweening()){
			checkDadLoc();
		}

		var fuckme:Array<StrumNote> = game.opponentStrums.members;
		for (strum in fuckme)
			{
				strum.cameras = [game.camGame];
				strum.scrollFactor.set(1, 1);
			}
		for (i in 0...game.opponentStrums.length) {
			game.opponentStrums.members[i].x=dadGroup.x+930+(i-2)*105;
		}
	
		var fuckyou:Array<Note> = game.unspawnNotes;
		for (i in 0...fuckyou.length) {
			if (!fuckyou[i].mustPress) {
				fuckyou[i].cameras = [game.camGame];
				fuckyou[i].scrollFactor.set(1, 1);
			} 
		}

		if (camlock && camon) {
            camFollow.x=camlockx;
            camFollow.y=camlocky;
        }

	}

	public function isTweening() {
		@:privateAccess var tweens = FlxTween.globalManager._tweens;
		
        for (i in 0...tweens.length)
        {
            var tween = tweens[i];
            @:privateAccess if (tween.isTweenOf(game.dadGroup)){
				var varTween:VarTween = cast tween;
				var target = varTween._object;
				var fields = Reflect.fields(varTween._properties);
                return true;
			}
        }
		return false;
		
	}
public var colArray:Array<String> = ['purple', 'blue', 'green', 'red'];
	public function goodNoteHit(note:Note) {
		if(bfturn){
			switch (colArray[note.noteData % colArray.length]) {
				case 'purple':
					camlockx = campointx - camMovement;
					camlocky = campointy;
				case 'blue':
					camlocky = campointy + camMovement;
					camlockx = campointx;
				case 'green':
					camlocky = campointy - camMovement;
					camlockx = campointx;
				case 'red':
					camlockx = campointx + camMovement;
					camlocky = campointy;
			}
			new FlxTimer().start(1, camreset);
			game.cameraSpeed = velocity;
			camlock =true;
		}
	}

	public function camreset(timer:FlxTimer){
		camlock=false;
		game.cameraSpeed = 1;
		camFollow.x=campointx;
		camFollow.y=campointy;
	}

	public function checkDadLoc(?tween:FlxTween){
		switch(poop){
			case "front":
				dadGroup.x=0;
			case "left":
				dadGroup.x=-1920;
			case "right":
				dadGroup.x=1920;
			case "back":
				dadGroup.x=3000;
		}
	}

	public function rupd() {
		
		if(opf==plf)
			poop="front";
		else if(opf==(plf+1)%4)
			poop="right";
		else if(opf==(plf+3)%4)
			poop="left";
		else if(opf==(plf+2)%4)
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
		stagl.x=stag.x-1920;
		stagr.x=stag.x+1920;
		foggy.x=0;
		foggyl.x=foggy.x-1920;
		foggyr.x=foggy.x+1920;
		canTurn=true;
	}

	public function resethands(tween:FlxTween) {
		var newlx = random(lx-50, lx+50);
		var newly = random(ly-50, ly+50);
		var newrx = random(rx-50, rx+50);
		var newry = random(ry-50, ry+50);
		FlxTween.tween(lefthand, { x: newlx, y: newly }, 0.1, { ease: FlxEase.expoInOut });
		FlxTween.tween(righthand, { x: newrx, y: newry }, 0.1, { ease: FlxEase.expoInOut });
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

				var fuckme:Array<StrumNote> = game.opponentStrums.members;
				FlxTween.tween(fuckme[0], {x: dadGroup.x+960-(2*105), y: 300}, 0.4, {ease: FlxEase.expoInOut});
				FlxTween.tween(fuckme[1], {x: dadGroup.x+960-(1*105), y: 300}, 0.4, {ease: FlxEase.expoInOut});
				FlxTween.tween(fuckme[2], {x: dadGroup.x+960+(1*105), y: 300}, 0.4, {ease: FlxEase.expoInOut});
				FlxTween.tween(fuckme[3], {x: dadGroup.x+960+(2*105), y: 300}, 0.4, {ease: FlxEase.expoInOut});
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
		
		
	}
	override function sectionHit()
	{	
		var SONG:SwagSong = Song.loadFromJson('fog', 'fog');
		campointx=Std.int(camFollow.x);
		campointy=Std.int(camFollow.y);
		if(SONG.notes[curSection].mustHitSection){
			defaultCamZoom=0.8;
			bfturn=true;
			camlock=false;
		}else{
			defaultCamZoom=1;
			bfturn=false;
			camlock=false;
		}

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
							t3 = FlxTween.tween(dadGroup, {x:dadGroup.x-stag.width}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
							t3.start();
						} else {
							opf=random(0,3);
							switch(poop){
								case "left":
									t4=FlxTween.tween(dadGroup, {x:dadGroup.x-stag.width}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
									t4.start();
								case "right":
									t5=FlxTween.tween(dadGroup, {x:dadGroup.x+stag.width}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
									t5.start();
								case "back":
									t6=FlxTween.tween(dadGroup, {x:dadGroup.x-(2*stag.width)}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
									t6.start();
								default:
									t7=FlxTween.tween(dadGroup, {x:stag.x}, 0.4, {ease:FlxEase.expoInOut, onComplete: checkDadLoc});
									t7.start();

							}
						}
					case "check":
						if(opf!=plf){
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
			case "behind":
				behind.alpha=1;
				FlxTween.tween(behind, {alpha: 0}, 1, {ease: FlxEase.circInOut});
			case "you":
				you.alpha=1;
				FlxTween.tween(you, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
			case "turn":
				turn.alpha=1;
				FlxTween.tween(turn, {alpha: 0}, 1, {ease: FlxEase.circInOut});
			case "around":
				around.alpha=1;
				FlxTween.tween(around, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
			case "tint":
				if(value2!=null){
					//game.camGame.filters.push(new ShaderFilter(new OverlayShader()));
					game.initLuaShader('game.camGame', 'tint');
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