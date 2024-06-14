function onCreate()

    setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'deathGrid')

    setProperty('timeBar.x', -5000)
    setProperty('iconP1.alpha', 0)
    setProperty('iconP2.alpha', 0)
    setProperty('healthBar.alpha', 0)
    setProperty('scoreTxt.alpha', 0)

    --setObjectOrder('boyfriendGroup', 10)
    setObjectOrder('dadGroup', 3)
    setObjectOrder('game.opponentStrums', 5)

    setObjectCamera('boyfriendGroup', 'camhud')
    setProperty('boyfriendGroup.x', 900)
    setProperty('boyfriendGroup.y', 0)
    setProperty('dadGroup.x', getGraphicMidpointX('obj1')-220)
    setProperty('dadGroup.y', -20)
    setProperty('dadGroup.alpha', 0)
    setProperty('timeTxt.alpha', 0)

    makeLuaText('timee', '[-----------------------------------------------------------------------------------------------------------------------------------------------]', screenWidth, 0, 0)
    setTextFont('timee', 'mingliu.ttf')
    addLuaText('timee')
    runHaxeCode([[import Main;
        Main.fpsVar.visible = false;]])

    
end

function onUpdate(elapsed)
    runHaxeCode([[
             for (strum in game.opponentStrums)
             {
                 strum.cameras = [game.camGame];
                 strum.scrollFactor.set(1, 1);
             }

             for (note in game.unspawnNotes) 
             {
                 if (!note.mustPress) {
                     note.cameras = [game.camGame];
                     note.scrollFactor.set(1, 1);
                 } 
             };
         ]])
    for i = 0, 3 do
        noteTweenX('blub'..i, i, getGraphicMidpointX('obj1')+(i-2)*105, 1, 'easeInOut')
    end
    setProperty('timeTxt.alpha', 0)
    noteTweenX('joj1', 4, defaultPlayerStrumX0-290, 1, 'easeInOut')
    noteTweenX('joj2', 5, defaultPlayerStrumX1-290, 1, 'easeInOut')
    noteTweenX('joj3', 6, defaultPlayerStrumX2-290, 1, 'easeInOut')
    noteTweenX('joj4', 7, defaultPlayerStrumX3-290, 1, 'easeInOut')

    if curStep == 2304 then
        cameraFade('game', '#000000', 10)
        doTweenZoom('byebye', 'camGame', 0.05, 9, 'easeInOut')
    end
    if curStep == 2431 then
        cameraFade('hud', '#000000', 203-194.04)
    end
end


function onStepHit()
    if mustHitSection == false then
        for i = 0, 3 do
            noteTweenAlpha('dd'..i, i, 1, 0.3, 'easeInOut')
        end
        for i = 4, 7 do
            noteTweenAlpha('db'..i, i, 0.4, 0.3, 'easeInOut')
        end
    else
        for i = 0, 3 do
            noteTweenAlpha('dd'..i, i, 0.4, 0.3, 'easeInOut')
        end
        for i = 4, 7 do
            noteTweenAlpha('db'..i, i, 1, 0.3, 'easeInOut')
        end
    end
    local perc = (getSongPosition()/songLength)
    local st = ''
    for i = 0, math.floor(perc*143) do
        st = st..'X'
    end
    for i = math.floor(perc*143), 142 do
        st = st..'-'
    end
    setTextString('timee', '['..st..']')
end

function onSectionHit()
    if mustHitSection == false then
        runHaxeCode('game.defaultCamZoom = 0.7;')
    else
        runHaxeCode('game.defaultCamZoom = 0.5;')
    end
end


function onEndSong()
    runHaxeCode([[import Main;
    Main.fpsVar.visible = ClientPrefs.data.showFPS;]])
end

function onUpdateScore(miss)
    if miss == true then
        playSound('missnote'..getRandomInt(1,3))
    end
    if getMisses()>9 then
        setHealth(0)
    end
end