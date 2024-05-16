
function onCreate()

	makeLuaSprite('obj1', 'skybox0', -670, -338)
	setObjectOrder('obj1', 0)
	scaleObject('obj1', 2, 2)
	addLuaSprite('obj1', true)
	
	makeAnimatedLuaSprite('obj3', 'eternal_malice', 787, -266)
	setObjectOrder('obj3', 1)
	scaleObject('obj3', 2, 2)
	addAnimationByPrefix('obj3', 'anim', 'sun instance 10', 24, true)
	playAnim('obj3', 'anim', true)
	addLuaSprite('obj3', true)
	
	makeLuaSprite('obj5', 'bgshit2', -604, 8)
	setObjectOrder('obj5', 2)
	scaleObject('obj5', 2, 2)
	addLuaSprite('obj5', true)
	
	makeLuaSprite('obj6', 'bgshit3', -568, 918)
	setObjectOrder('obj6', 3)
	scaleObject('obj6', 2, 2)
	addLuaSprite('obj6', true)
	
	makeLuaSprite('obj7', 'bgshit1', 1716, -214)
	setObjectOrder('obj7', 1)
	scaleObject('obj7', 2, 2)
	addLuaSprite('obj7', true)
	
	makeLuaSprite('obj8', 'bridgeshit4', 81, 845)
	setObjectOrder('obj8', 5)
	scaleObject('obj8', 2, 2)
	addLuaSprite('obj8', true)
	
	makeLuaSprite('obj9', 'floor5', -813, 909)
	setObjectOrder('obj9', 6)
	scaleObject('obj9', 2.3, 2.3)
	addLuaSprite('obj9', true)
	
	makeAnimatedLuaSprite('obj10', 'SHAFT', 1184, 97)
	setObjectOrder('obj10', 5)
	scaleObject('obj10', 2, 2)
	addAnimationByPrefix('obj10', 'anim', 'sheft instance 10', 24, true)
	playAnim('obj10', 'anim', true)
	addLuaSprite('obj10', true)

	doTweenY('twe1', 'obj3', -66, 3, 'easeInOut')
end

function onTweenCompleted(tag)
		if tag == 'twe1' then
			doTweenY('twe2', 'obj3', -266, 3, 'easeInOut')
		elseif tag == 'twe2' then
			doTweenY('twe1', 'obj3', -66, 3, 'easeInOut')
		end
	end