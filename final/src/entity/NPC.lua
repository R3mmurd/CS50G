--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

NPC = Class{__includes = Entity}

function NPC:init(def)
    Entity.init(self, def)
end

function NPC:onInteract()
    local text = ENTITY_DEFS.npcs.texts[math.random(#ENTITY_DEFS.npcs.texts)]
    gStateStack:push(DialogueState(self.name .. ': ' .. text))
end