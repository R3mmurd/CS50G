--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

NPCIdleState = Class{__includes = EntityBaseState}

function NPCIdleState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('idle-' .. self.entity.direction)
end
