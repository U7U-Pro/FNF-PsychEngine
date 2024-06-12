function onCreate()
    local offset = 0

    --death
    setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'deathU7U')


    
    --adrenalin e 
    makeAnimatedLuaSprite('blob', 'adrenaline', -50, screenHeight-400)
    addAnimationByPrefix('blob', 'pulse', 'adrenaline pulse')
    setObjectCamera('blob', 'camHUD')
    addLuaSprite('blob', true)

    makeLuaText('acc', 'its not workin', 400, 150, screenHeight-140)
    setTextAlignment('acc', 'left')
    setTextFont('acc', 'mingliu.ttf')
    setTextBorder('acc', 1, '#FF0000')
    setTextColor('acc', '#00FF00')
    setTextSize('acc', 50)
    setObjectCamera('acc', 'camHUD')
    setObjectOrder('acc', getObjectOrder('blob')+1)
    addLuaText('acc')

    --timebar bullshit please kill me
    setProperty('timeBar.angle', 270)
    setProperty('iconP1.alpha', 0)
    setProperty('iconP2.alpha', 0)
    setProperty('healthBar.alpha', 0)
    setProperty('timeBar.x', -130+offset)
    setProperty('timeBar.y', 420)
    setProperty('scoreTxt.alpha', 0)
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
    scaleObject('pills', 0.7, 0.7)
    addAnimationByPrefix('pills', '0down', 'pills0')
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

    --chunking tron
    makeLuaSprite('chunk', 'chunkotron', 300, screenHeight-256)
    setObjectCamera('chunk', 'camHUD')
    addLuaSprite('chunk',true)

    makeLuaText('scorec', 'score', 310, getProperty('chunk.x')+128, getProperty('chunk.y')+89)
    setTextAlignment('scorec', 'left')
    setTextFont('scorec', 'mingliu.ttf')
    setTextSize('scorec', 80)
    setTextColor('scorec', '#00FF00')
    setTextBorder('scorec', '1', '#FF0000')
    addLuaText('scorec')

    makeAnimatedLuaSprite('slurp', 'alphabet', getProperty('chunk.x')+70, getProperty('chunk.y')+79)
    addAnimationByPrefix('slurp', 's', '$ normal instance 1')
    setObjectCamera('slurp', 'camHUD')
    playAnim('slurp', 's')
    addLuaSprite('slurp', true)

    makeGraphic('black', screenWidth, screenHeight, '#000000')
    setObjectCamera('black', 'camHUD')
    addLuaSprite('black', false)
    setProperty('black.alpha', 0)
end

function onUpdate(elapsed)
    --kill opponent strums cuz whythe hell not????
    for i = 0, 4, 1 do
        setPropertyFromGroup('opponentStrums', i, 'alpha', tonumber(0))
    end
end

function onUpdateScore(miss)
    if miss == true then
        playSound('missnote'..getRandomInt(1,3))
    end
    setTextString('acc', string.format("%.2f", tostring(rating*100)).."%")
    setProperty('scorec.text', score)
    local cursprite = getMisses()..'down'
    playAnim('pills', cursprite)
    if getMisses()>9 then
        setObjectOrder('packet', getObjectOrder('chunk')+1)
        setObjectOrder('pills', getObjectOrder('packet')+1)
        screenCenter('pills')
        screenCenter('packet')
        doTweenX('pcenter', 'pills.scale', 2, 1, 'expoInOut')
        doTweenY('pcenter2', 'pills.scale', 2, 1, 'expoInOut')
        doTweenX('pacenter', 'packet.scale', 2, 1, 'expoInOut')
        doTweenY('pacenter2', 'packet.scale', 2, 1, 'expoInOut')
        doTweenAlpha('fade', 'black', 100, 1, 'expoInOut')
        playAnim('pills', 'death')
    end
end



function onTweenCompleted(tag)
    if tag == 'pcenter' then
        setHealth(0)
    end
end