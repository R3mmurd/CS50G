--[[
    GD50
    Breakout Remake

    -- PowerUp Class --

    Author: Alejandro Mujica
    aledrums@gmail.com

    Represents a Base Power Up that spawns randomly to be taken by the paddle.
]]

-- Number of skin for the needed types of power ups.
BALL_POWER_UP = 9
KEY_POWER_UP = 10

PowerUp = Class{}

function PowerUp:init(x, y, skin)
    -- simple positional and dimensional variables
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16

    -- this variable are for keeping track of our velocity on the
    -- Y axis, since the power up can move only vertically
    self.dy = 60
    
    -- this will effectively be the color of our ball, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    love.graphics.draw(gTextures['main'], gFrames['powerUps'][self.skin],
        self.x, self.y)
end

function PowerUp:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    return true
end
