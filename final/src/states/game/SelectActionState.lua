--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

SelectActionState = Class{__includes = BaseState}

function SelectActionState:init(battleState, entity, onActionSelected)
    self.battleState = battleState
    self.entity = entity

    local menuItems = {}

    for k, a in pairs(self.entity.actions) do
        table.insert(menuItems, {
            text = a.name,
            onSelect = function()
                gSounds[a.sound_effect]:stop()
                local targets = a.target_type == 'enemy' and self.battleState.enemies or self.battleState.party.characters

                if a.require_target then
                    -- Select target on targets with a
                    gStateStack:push(SelectTargetState(self.battleState, targets,
                    -- callback for when a target has been selected
                    function(selectedTarget)
                        local amount = a.func(self.entity, selectedTarget, a.strength)
                        gSounds[a.sound_effect]:play()
                        -- update energy bar
                        Timer.tween(0.5, {
                            [self.battleState.energyBars[selectedTarget.name]] = {value = selectedTarget.currentHP}
                        })     
                        gStateStack:push(BattleMessageState(self.battleState, a.name .. ' for ' .. amount .. ' HP to ' .. selectedTarget.name .. '.',
                        function()               
                            gStateStack:pop()
                            onActionSelected()
                        end))
                    end))
                else
                    -- Apply action on targets
                    local amount = a.func(self.entity, targets, a.strength)
                    gSounds[a.sound_effect]:play()

                    -- update energy bars
                    for k, e in pairs(targets) do
                        Timer.tween(0.5, {
                            [self.battleState.energyBars[e.name]] = {value = e.currentHP}
                        })
                    end
                    gStateStack:push(BattleMessageState(self.battleState, a.name .. ' for ' .. amount .. ' HP to each target.',
                        function()
                            gStateStack:pop()
                            onActionSelected()
                        end))
                end
            end
        })
    end

    table.insert(menuItems, {
        text = 'Nothing',
        onSelect = function()
            -- only pop select action menu
            gStateStack:pop()
            onActionSelected()
        end
    })
    
    self.actionMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH ,
        height = 64,
        items = menuItems
    }
end

function SelectActionState:update(dt)
    for k, e in pairs(self.battleState.enemies) do
        e:update(dt)
    end
    self.actionMenu:update(dt)
end

function SelectActionState:render()
    self.actionMenu:render()
end