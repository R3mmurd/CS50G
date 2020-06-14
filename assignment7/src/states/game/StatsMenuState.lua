--[[
    GD50
    Pokemon

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

StatsMenuState = Class{__includes = BaseState}

function StatsMenuState:init(pokemon, stats, onClose)
    self.pokemon = pokemon
    self.HPIncrease = stats.HPIncrease
    self.attackIncrease = stats.attackIncrease
    self.defenseIncrease = stats.defenseIncrease
    self.speedIncrease = stats.speedIncrease

    self.previousHP = self.pokemon.HP - self.HPIncrease
    self.previousAttack = self.pokemon.attack - self.attackIncrease
    self.previousDefense = self.pokemon.defense - self.defenseIncrease
    self.previousSpeed = self.pokemon.speed - self.speedIncrease

    self.onClose = onClose or function() end
    
    self.statsMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH,
        height = 64,
        showCursor = false,
        font = gFonts['small'],
        items = {
            {
                text = 'HP: ' .. self.previousHP .. ' + ' .. self.HPIncrease .. ' = ' .. self.pokemon.HP,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'Attack: ' .. self.previousAttack .. ' + ' .. self.attackIncrease .. ' = ' .. self.pokemon.attack,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'Defense: ' .. self.previousDefense .. ' + ' .. self.defenseIncrease .. ' = ' .. self.pokemon.defense,
                onSelect = function()
                    self:close()
                end
            },
            {
                text = 'Speed: ' .. self.previousSpeed .. ' + ' .. self.speedIncrease .. ' = ' .. self.pokemon.speed,
                onSelect = function()
                    self:close()
                end
            }
        }
    }
end

function StatsMenuState:close()
    gStateStack:pop()
    self.onClose()
end

function StatsMenuState:update(dt)
    self.statsMenu:update(dt)
end

function StatsMenuState:render()
    self.statsMenu:render()
end