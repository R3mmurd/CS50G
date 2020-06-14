--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

TheEndState = Class{__includes = BaseState}

function TheEndState:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        for k, s in pairs(gSounds) do
            s:stop()
        end
        gStateStack:clear()
        gStateStack:push(StartState())
    end
end

function TheEndState:render()
    love.graphics.clear(0, 0, 0, 255)
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('The man-eater flower has been defeated and the curse has been broken. Thanks!', 
    0, 10, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('The end', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
end