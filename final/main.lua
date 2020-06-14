--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com

    Credits:
    - Some codes from previous lectures of GD50 have been reused.
    - font.ttf: GD50
    - finalf.ttf: https://www.dafont.com/final-fantasy.font
    - Music and graphics: https://opengameart.org/
]]

require 'src/Dependencies'

function love.load()
    love.window.setTitle('Final Fifty')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gSounds['intro']:setLooping(true)
    gSounds['town']:setLooping(true)
    gSounds['town']:setVolume(0.5)
    gSounds['world']:setLooping(true)
    gSounds['world']:setVolume(0.5)
    gSounds['battle']:setLooping(true)

    gStateStack = StateStack()
    gStateStack:push(StartState())

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end