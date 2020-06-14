--[[
    GD50
    Final Fifty

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by: Alejandro Mujica
    aledrums@gmail.com
]]

Tile = Class{}

function Tile:init(x, y, id)
    self.x = x
    self.y = y
    self.id = id
end

function Tile:update(dt)

end

function Tile:render(xPaddle, yPaddle)
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][self.id],
        (self.x - 1 + xPaddle) * TILE_SIZE, (self.y - 1 + yPaddle) * TILE_SIZE)
end