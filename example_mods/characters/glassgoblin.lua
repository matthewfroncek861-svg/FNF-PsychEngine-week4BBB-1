local tweenDir = 1 -- Direction multiplier for ping-pong
local currentTweenX = 'dadMoveX'
local currentTweenY = 'dadMoveY'

function onCreatePost()
    -- Start the tweens
    doTweenX(currentTweenX, 'dad', 260, 2, 'sineInOut')
    doTweenY(currentTweenY, 'dad', 180, 6, 'sineInOut')
end

function onTweenCompleted(tag)
    if tag == currentTweenX then
        -- Reverse direction for X tween
        local newX = (getProperty('dad.x') == 260) and defaultOpponentStrumX0 or 260
        doTweenX(currentTweenX, 'dad', newX, 2, 'sineInOut')
    end

    if tag == currentTweenY then
        -- Reverse direction for Y tween
        local newY = (getProperty('dad.y') == 180) and defaultOpponentStrumY0 or 180
        doTweenY(currentTweenY, 'dad', newY, 6, 'sineInOut')
    end
end
