function onCreate()
    local offset = 500
    --timebar bullshit please kill me
    setProperty('timeBar.angle', 270)
    setProperty('iconP1.alpha', 0)
    setProperty('iconP2.alpha', 0)
    setProperty('healthBar.alpha', 0)
    setProperty('timeBar.x', -130+offset)
    setProperty('timeBar.y', 420)
    scaleObject('timeBar', 0.4, 8)
    setObjectCamera('timeBar', 'camHUD')
    
    makeAnimatedLuaSprite('stime', 'sewageTime', 20+offset, getProperty('timerBar.y'))
    screenCenter('stime', 'y')
    setObjectCamera('stime', 'camHUD')
    addAnimationByPrefix('stime', 'throb', 'sewageTime throb')
    addLuaSprite('stime', true)

    setObjectOrder('timeBar', getObjectOrder('stime')-1)

    setProperty('timeBar.leftBar.color', getColorFromHex('00FF00'))
    setProperty('timeBar.rightBar.color', getColorFromHex('006600'))

    --fart ed
    makeAnimatedLuaSprite('fart', 'fart', 35+offset, 48)
    setObjectCamera('fart', 'camHUD')
    addAnimationByPrefix('fart', 'move', 'gassyboy')
    addLuaSprite('fart', true)

    setProperty('timeTxt.x', 50+offset)
    setProperty('timeTxt.y', 40)
    setObjectOrder('timeTxt', getObjectOrder('fart')+1)

    --drugs
    makeAnimatedLuaSprite('packet', 'packet', screenWidth-(0.7*550), screenHeight-(0.7*250))
    setObjectCamera('packet', 'camHUD')
    scaleObject('packet',0.7, 0.7)
    addAnimationByPrefix('packet', 'idle', 'paracetamol packie')
    addLuaSprite('packet', true)

    makeAnimatedLuaSprite('pills', 'pillies', getProperty('packet.x')+20, getProperty('packet.y')+20)
    setObjectCamera('pills', 'camHUD')
    scaleObject('packet', 0.7, 0.7)
    addAnimationByPrefix('pills', '0down', 'pills')
    addAnimationByPrefix('pills', '1down', 'pills 1down')
    addAnimationByPrefix('pills', '2down', 'pills 2down')
    addAnimationByPrefix('pills', '3down', 'pills 3down')
    addAnimationByPrefix('pills', '4down', 'pills 4down')
    addAnimationByPrefix('pills', '5down', 'pills 5down')
    addAnimationByPrefix('pills', '6down', 'pills 6down')
    addAnimationByPrefix('pills', '7down', 'pills 7down')
    addAnimationByPrefix('pills', '8down', 'pills 8down')
    addAnimationByPrefix('pills', '9down', 'pills 9down')
    addAnimationByPrefix('pills', 'death', 'pills DEATH')
    playAnim('pills', '0down')
    addLuaSprite('pills', true)
end

function noteMiss()
    playAnim('pills', getMisses..'down')


end