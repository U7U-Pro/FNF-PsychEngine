package states;

import flixel.system.debug.DebuggerUtil;
import lime.ui.WindowAttributes;
import flixel.system.debug.Window;
import flixel.math.FlxRandom;
import shaders.Fog;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

import backend.WeekData;
import backend.Song;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = 'The Fog'; // This is also used for Discord RPC
	public static var curSelected:Int = 1;

	var logo = new FlxSprite();
	var start:FlxSprite = new FlxSprite(0, 0); // 
	var options:FlxSprite = new FlxSprite(0, 0); // 
	var bg:FlxSprite= new FlxSprite(0,0);

	var optionShit:Array<String> = [
		'story_mode',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("The Fog", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg.frames = Paths.getSparrowAtlas('bgfog');
		bg.screenCenter();
		bg.animation.addByPrefix('play', 'fog', 4);
		bg.animation.play('play');

		//bg.shader = new Fog();
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		//add(magenta);

		start.x = random(0, FlxG.width-410);
		start.y = random(0, FlxG.height-150);
		start.frames = Paths.getSparrowAtlas('start');
		start.animation.addByPrefix('idle', 'start idle', 1);
		start.animation.addByPrefix('selected', 'start selected', 6);
		start.animation.play('idle');

		options.x = random(0, FlxG.width-650);
		options.y = random(0, FlxG.height-200);
		options.frames = Paths.getSparrowAtlas('options');
		options.animation.addByPrefix('idle', 'options idle', 1);
		options.animation.addByPrefix('selected', 'options selected', 6);
		options.animation.play('idle');
		
		changeItem();

		logo.frames = Paths.getSparrowAtlas('logo');
		logo.screenCenter();
		logo.animation.addByPrefix('logo', 'logo', 0.5);
		logo.animation.play('logo');
		add(logo);
		add(options);
		add(start);

		var timeA:FlxTimer = new FlxTimer().start(2.5, moveStart, 0);
		var timeB:FlxTimer = new FlxTimer().start(3.1, moveOptions, 0);
		moveOptions(timeB);
		moveStart(timeA);

		if(FlxG.sound.music!=null){
			FlxG.sound.music.kill();
		}
		FlxG.sound.playMusic(Paths.music('menu'));

		

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P || controls.UI_LEFT_P || controls.UI_DOWN_P || controls.UI_RIGHT_P)
				changeItem();
			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxTween.tween(options, {"scale.x": 0, "scale.y":0, alpha: 0}, 2.0, {ease: FlxEase.linear});
				FlxTween.tween(logo, {"scale.x": 0, "scale.y":0, alpha: 0}, 2.0, {ease: FlxEase.linear});
				switch (optionShit[curSelected])
				{
					case 'story_mode':
						FlxTween.tween(start, { "scale.x": 0, "scale.y":0, alpha: 0 }, 2.0, {
							ease: FlxEase.linear, 
							onComplete: gomenu
						});
					case 'options':
						OptionsState.onPlayState = false;
						if (PlayState.SONG != null)
						{
							PlayState.SONG.arrowSkin = null;
							PlayState.SONG.splashSkin = null;
							PlayState.stageUI = 'normal';
						}
						FlxTween.tween(start, {"scale.x": 0, "scale.y":0, alpha: 0}, 2.0, {ease: FlxEase.linear, onComplete: goopt});
				}				
				
			}
		}
		

		super.update(elapsed);
	}
	
	function gomenu(tween:FlxTween):Void{
		try{
			PlayState.storyPlaylist = ["fog"];
			PlayState.isStoryMode = true;
			WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));
			PlayState.SONG = Song.loadFromJson("fog", "fog");
		}catch(e:Dynamic){
			trace('ERROR! $e');
			return;
		}
		new FlxTimer().start(1, function(tmr:FlxTimer)
			{						
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
		MusicBeatState.switchState(new PlayState());
	}
	function goopt(tween:FlxTween):Void{
		MusicBeatState.switchState(new OptionsState());
	}

	public function random(min:Int, max:Int){
		return min + Std.int(Math.random() * (max - min + 1));
	}

	function moveStart(timer:FlxTimer){
		var chance1 = random(0,5), xs = random(0, FlxG.width-410), ys=random(0, FlxG.height-150);
		if(chance1>1){
			FlxTween.completeTweensOf(start);
			FlxTween.tween(start, {x:xs, y:ys}, 3.0, {ease: FlxEase.sineInOut});
		}
	}

	function moveOptions(timer:FlxTimer){
		var chance2= random(0,5), xo=random(0, FlxG.width-650), yo=random(0, FlxG.height-200);
		if(chance2>1){
			FlxTween.completeTweensOf(options);
			FlxTween.tween(options, {x:xo, y:yo}, 3.0, {ease: FlxEase.sineInOut});
		}
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		if(curSelected==1){
			start.animation.play('selected');
			start.alpha = 1;
			options.animation.play('idle');
			options.alpha = 0.3;
			curSelected = 0;
		} else {
			options.animation.play('selected');
			options.alpha = 1;
			start.animation.play('idle');
			start.alpha = 0.3;
			curSelected = 1;
		}
	}
}
