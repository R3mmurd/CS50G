--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

-- By Alejandro: Minimum values to reach each medal
local THIRD_PLACE_MIN = 1
local SECOND_PLACE_MIN = 2
local FIRST_PLACE_MIN = 3

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score

    -- By Alejandro:
    if self.score >= FIRST_PLACE_MIN then
        -- Medal for first place
        self.medal = love.graphics.newImage('1stplace.png')
    elseif self.score >= SECOND_PLACE_MIN then
        -- Medal for second place
        self.medal = love.graphics.newImage('2ndplace.png')
    elseif self.score >= THIRD_PLACE_MIN then
        -- Medal for third place
        self.medal = love.graphics.newImage('3rdplace.png')
    else
        -- No medal
        self.medal = nil
    end
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- By Alejandro: render medal if there is
    if self.medal ~= nil then
        love.graphics.draw(self.medal, VIRTUAL_WIDTH/2-self.medal:getWidth()/2, 20)
    end
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
