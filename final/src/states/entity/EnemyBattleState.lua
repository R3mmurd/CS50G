--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

EnemyBattleState = Class{__includes = EntityBaseState}

function EnemyBattleState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('default')
end
