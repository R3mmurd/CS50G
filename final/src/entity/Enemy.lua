--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

Enemy = Class{__includes = BattleEntity}

function Enemy:init(def)
    BattleEntity.init(self, def)
    statusGenerated = def.statusGenerated
end