
function onCreate()

	makeLuaSprite('obj1', 'skybox', -650, -91)
	setObjectOrder('obj1', 0)
	scaleObject('obj1', 1.6, 1.6)
	addLuaSprite('obj1', true)
	
	makeLuaSprite('obj3', 'ground', -668, 863)
	setObjectOrder('obj3', 2)
	scaleObject('obj3', 1.6, 1.6)
	addLuaSprite('obj3', true)
	
	makeLuaSprite('obj5', 'far_back_houses', -521, 285)
	setObjectOrder('obj5', 2)
	scaleObject('obj5', 1.6, 1.6)
	setScrollFactor('obj5', 1.5, 1)
	addLuaSprite('obj5', true)
	
	makeLuaSprite('obj7', 'u7u_pro_house', 1646, 342)
	setObjectOrder('obj7', 5)
	scaleObject('obj7', 1.6, 1.6)
	setScrollFactor('obj7', 1.3, 1)
	addLuaSprite('obj7', true)
	
	makeLuaSprite('obj8', 'Yaldi_house', 139, 403)
	setObjectOrder('obj8', 5)
	scaleObject('obj8', 1.3, 1.3)
	setScrollFactor('obj8', 1.1, 1)
	addLuaSprite('obj8', true)
	
	makeLuaSprite('obj9', 'roadd', -733, 1002)
	setObjectOrder('obj9', 6)
	scaleObject('obj9', 1.7, 1.7)
	addLuaSprite('obj9', true)

	makeAnimatedLuaSprite('frontpeeps', 'crowd', 39, 453)
	setObjectOrder('frontpeeps', 7)
	scaleObject('frontpeeps', 1.3, 1.3)
	setScrollFactor('frontpeeps', 1.1, 1)
	addAnimationByPrefix('frontpeeps', 'anim', 'people', 24, true)
	--addAnimation('frontpeeps', 'anim', {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19})
	playAnim('frontpeeps', 'anim', true)
	addLuaSprite('frontpeeps', true)
	
	setObjectOrder('boyfriendGroup', 10)
	setObjectOrder('dadGroup', 10)
end