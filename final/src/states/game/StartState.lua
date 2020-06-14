--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    gSounds['intro']:play()
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 1,
        function()
            gStateStack:pop()
            gStateStack:push(SelectCharacterState({character = 1}))
            gStateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 0.5,
            function() end))
        end))
    end
end

function StartState:render()
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
                    VIRTUAL_WIDTH / gTextures['background']:getWidth(),
                    VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    love.graphics.setFont(gFonts['ff'])
    love.graphics.setColor(34, 34, 34, 255)
    love.graphics.printf('FINAL FIFTY', 2, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(212, 175, 55, 255)
    love.graphics.printf('FINAL FIFTY', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['ff-small'])
    love.graphics.printf('PRESS ENTER', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
end