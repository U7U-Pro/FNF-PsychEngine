function onCreate()
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
    setProperty('dadGroup.x', getGraphicMidpointX('obj1')-200)
    setProperty('dadGroup.y', -20)
    setProperty('timeTxt.alpha', 0)
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

end

function onStepHit()
    if mustHitSection == false then
        doTweenZoom('poop', 'camgame', 1.5, 0.3, 'easeInOut')
        for i = 0, 3 do
            noteTweenAlpha('dd'..i, i, 1, 0.3, 'easeInOut')
        end
        for i = 4, 7 do
            noteTweenAlpha('db'..i, i, 0.4, 0.3, 'easeInOut')
        end
    else
        doTweenZoom('poop', 'camgame', 1.2, 0.3, 'easeInOut')
        for i = 0, 3 do
            noteTweenAlpha('dd'..i, i, 0,4, 0.3, 'easeInOut')
        end
        for i = 4, 7 do
            noteTweenAlpha('db'..i, i, 1, 0.3, 'easeInOut')
        end
    end
end
