--[[
    GD50
    Final Fifty

    Author: Alejandro Mujica
    aledrums@gmail.com
]]

SelectCharacterState = Class{__includes = BaseState}

function SelectCharacterState:init(def)
    self.character = def.character or 1
    self.selected = def.selected or 'male'
    self.character_type = ENTITY_DEFS.characters[self.character]
    self.party = def.party or {}
end

function SelectCharacterState:update(dt)
    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('left') then
        if self.selected == 'male' then
            self.selected = 'female'
        else
            self.selected = 'male'
        end
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        table.insert(self.party, self.character, self.selected)
        if self.character < NUM_CHARACTERS then
            gStateStack:pop()
            gStateStack:push(SelectCharacterState({
                character = self.character + 1,
                selected = self.selected,
                party = self.party
            }))
        else
            gSounds['intro']:stop()
            gStateStack:push(FadeInState({
                r = 255, g = 255, b = 255
            }, 1,
            function()
                gStateStack:pop()

                gStateStack:push(GamePlayState({
                    party = self.party
                }))
                gStateStack:push(DialogueState("" .. 
                "Welcome to the world of Final Fifty! There is a curse that has to be broken. "..
                "To break the curse you have to defeat the Man-eater flower at the west from this town. "..
                "Go north to gain experience with weak slimes, go south to face second level worms, "..
                "go east for third level snakes, and finally, go west to deal with strong pumpkins and "..
                "find the final boss. Good luck!"
                 ))
                gStateStack:push(FadeOutState({
                    r = 255, g = 255, b = 255
                }, 1,
                function() end))
            end))
        end
    end
end

function SelectCharacterState:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(self.character_type.type, 0, 20, VIRTUAL_WIDTH, 'center')

    local x = VIRTUAL_WIDTH / 2 - ENTITY_WIDTH / 2 - 30
    local y = VIRTUAL_HEIGHT / 2 - ENTITY_HEIGHT

    love.graphics.draw(gTextures[self.character_type.male.texture], 
                       gFrames[self.character_type.male.texture][8], x, y)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(self.character_type.male.name, x - ENTITY_WIDTH, y - 10, ENTITY_WIDTH*3, 'center')

    if self.selected == 'male' then
        love.graphics.draw(gTextures['cursor-up'], x, y + ENTITY_HEIGHT + 10)
    end

    x = VIRTUAL_WIDTH / 2 - ENTITY_WIDTH / 2 + 30

    love.graphics.draw(gTextures[self.character_type.female.texture], 
                       gFrames[self.character_type.female.texture][8], x, y)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(self.character_type.female.name, x - ENTITY_WIDTH, y - 10, ENTITY_WIDTH*3, 'center')

    if self.selected == 'female' then
        love.graphics.draw(gTextures['cursor-up'], x, y + ENTITY_HEIGHT + 10)
    end
end

