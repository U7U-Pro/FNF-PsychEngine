
function onCreate()

	makeLuaSprite('obj2', 'backwall', -983, -395)
	setObjectOrder('obj2', 2)
	scaleObject('obj2', 1.8, 1.8)
	addLuaSprite('obj2', true)
	
	makeLuaSprite('obj3', 'door', 1560, 162)
	setObjectOrder('obj3', 3)
	scaleObject('obj3', 2.8, 2.8)
	addLuaSprite('obj3', true)
	
	makeLuaSprite('obj4', 'floor', -1126, 795)
	setObjectOrder('obj4', 4)
	scaleObject('obj4', 2.1, 2.1)
	addLuaSprite('obj4', true)
	
	makeLuaSprite('obj5', 'sky', 350, -402)
	setObjectOrder('obj5', 0)
	scaleObject('obj5', 2, 2)
	addLuaSprite('obj5', true)
	
	local a = getRandomInt(1, 3)
	if a == 1 then 
		makeLuaSprite('obj6', 'hobos1', 1630, 672)
	elseif a == 2 then
		makeLuaSprite('obj6', 'hobos2', 1630, 672)
	else
		makeLuaSprite('obj6', 'hobos3', 1630, 672)
	end
	setObjectOrder('obj6', 1)
	scaleObject('obj6', 1.5, 1.5)
	addLuaSprite('obj6', true)
	
	makeLuaSprite('obj7', 'table', -1010, 508)
	setObjectOrder('obj7', 6)
	scaleObject('obj7', 1.8, 1.8)
	addLuaSprite('obj7', true)

	setObjectOrder('boyfriendGroup', 7)
	setObjectOrder('dadGroup', 7)
	
end