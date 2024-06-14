
function onCreate()

	makeLuaSprite('sky', 'skybox0', -800, -300)
	setObjectOrder('sky', 0)
	scaleObject('sky', 2.5, 2.2)
	addLuaSprite('sky', true)
	
	makeAnimatedLuaSprite('malice', 'eternal_malice', 787, -266)
	setObjectOrder('malice', 1)
	scaleObject('malice', 2, 2)
	addAnimationByPrefix('malice', 'anim', 'sun instance 10', 24, true)
	playAnim('malice', 'anim', true)
	addLuaSprite('malice', true)
	
	makeLuaSprite('buildinging', 'bgshit2', -604, 8)
	setObjectOrder('buildinging', 2)
	scaleObject('buildinging', 2, 2)
	addLuaSprite('buildinging', true)
	
	makeLuaSprite('scratches', 'bgshit3', -568, 918)
	setObjectOrder('scratches', 3)
	scaleObject('scratches', 2, 2)
	addLuaSprite('scratches', true)
	
	makeLuaSprite('building', 'bgshit1', 1716, -214)
	setObjectOrder('building', 1)
	scaleObject('building', 2, 2)
	addLuaSprite('building', true)
	
	makeLuaSprite('bridge', 'bridgeshit4', 81, 845)
	setObjectOrder('bridge', 5)
	scaleObject('bridge', 2, 2)
	addLuaSprite('bridge', true)
	
	makeLuaSprite('floor', 'floor5', -813, 909)
	setObjectOrder('floor', 6)
	scaleObject('floor', 2.3, 2.5)
	addLuaSprite('floor', true)
	
	makeAnimatedLuaSprite('shaft', 'SHAFT', 1184, 97)
	setObjectOrder('shaft', 5)
	scaleObject('shaft', 2, 2)
	addAnimationByPrefix('shaft', 'anim', 'sheft instance 10', 24, true)
	playAnim('shaft', 'anim', true)
	addLuaSprite('shaft', true)
	
	doTweenY('tw1', 'malice', 200, 3, 'cubicInOut')
end

function onTweenCompleted(tag)
	if tag == 'tw1' then
		doTweenY('tw2', 'malice', -266, 3, 'cubicInOut')
	elseif tag == 'tw2' then
		doTweenY('tw1', 'malice', 200, 3, 'cubicInOut')
	end
end