--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

GamePlayState = Class{__includes = BaseState}

function GamePlayState:init(def)
    world = World(def)
end

function GamePlayState:update(dt)
    world:update(dt)
end

function GamePlayState:render()
    world:render()
end
