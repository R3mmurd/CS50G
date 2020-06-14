--[[
    GD50
    Final Fifty

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by: Alejandro Mujica
    aledrums@gmail.com
]]

TileMap = Class{}

function TileMap:init(width, height, paddle)
    self.tiles = {}
    self.width = width
    self.height = height
    self.xPaddle = paddle and paddle.x or 0
    self.yPaddle = paddle and paddle.y or 0
end

function TileMap:render()
    for y = 1, self.height do
        for x = 1, self.width do
            self.tiles[y][x]:render(self.xPaddle, self.yPaddle)
        end
    end
end