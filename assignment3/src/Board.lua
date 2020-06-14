--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}
    self.level = level
    self.maxPattern = math.min(self.level, 6)
    self.maxColor = 8

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(self.maxColor), math.random(self.maxPattern)))
        end
    end

    while self:calculateMatches() or not self:existsMatch() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

--[[
   Function to add match in a row
]]
function Board:addRowMatch(matches, low, high, y)
    local match = {}

    -- is there a shiny tile in the match
    local isThereShiny = false

    -- go backwards from here by matchNum
    for x = high, low, -1 do
        isThereShiny = isThereShiny or self.tiles[y][x].shiny
        if not self.tiles[y][x].inMatch then 
            -- mark tile in match
            self.tiles[y][x].inMatch = true
            -- add each tile to the match that's in that match
            table.insert(match, self.tiles[y][x])
        end
    end

    if isThereShiny then
        -- create a math over the whole row
        for x = 1, 8 do
            if not self.tiles[y][x].inMatch then
                self.tiles[y][x].inMatch = true
                table.insert(match, self.tiles[y][x])                        
            end
        end
    end
    -- add this match to our total matches table
    table.insert(matches, match)
end


--[[
   Function to add match in a column
]]
function Board:addColMatch(matches, low, high, x)
    local match = {}

    local shinyTileYs = {}

    for y = high, low, -1 do
        if self.tiles[y][x].shiny then
            table.insert(shinyTileYs, y)
        end
        if not self.tiles[y][x].inMatch then
            self.tiles[y][x].inMatch = true
            table.insert(match, self.tiles[y][x])                        
        end
    end

    for i, y in pairs(shinyTileYs) do
        for x = 1, 8 do
            if not self.tiles[y][x].inMatch then
                self.tiles[y][x].inMatch = true
                table.insert(match, self.tiles[y][x])                        
            end
        end
    end

    table.insert(matches, match)
end


--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        -- every horizontal tile
        for x = 2, 8 do
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else  
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    self:addRowMatch(matches, x - matchNum, x - 1, y)
                end

                matchNum = 1
                
                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            self:addRowMatch(matches, 8 - matchNum + 1, 8, y)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    self:addColMatch(matches, y - matchNum, y - 1, x)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            self:addColMatch(matches, 8 - matchNum + 1, 8, x)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local tile = Tile(x, y, math.random(self.maxColor), math.random(self.maxPattern))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

--[[
    Function that check if a movemente will cause a match
]]
function Board:willThereBeMatch(tile, x, y)
    -- To check whether 3 tiles in a row have the same color
    local allSameColor = true

    -- Horizontal color neighborhood
    local hNeighborhood = {}
    local xMin = math.max(1, x - 2)
    local xMax = math.min(8, x + 2)
    for j = xMin, xMax do
        table.insert(hNeighborhood, j, self.tiles[y][j].color)
    end

    -- Move the color horizontally if it is necessary
    hNeighborhood[tile.gridX] = hNeighborhood[x]
    hNeighborhood[x] = tile.color

    -- Window shift to check for match
    for j1 = xMin, xMax - 2 do
        allSameColor = true
        -- Check the current window
        for j2 = j1, j1 + 2 do
            allSameColor = allSameColor and hNeighborhood[j2] == tile.color    
        end

        -- if the window has all tiles with the same color, there is match
        if allSameColor then
            return true
        end
    end

    -- The same previous thing but vertically
    local vNeighborhood = {}
    local yMin = math.max(1, y - 2)
    local yMax = math.min(8, y + 2)
    
    for i = yMin, yMax do
        table.insert(vNeighborhood, i, self.tiles[i][x].color)
    end

    vNeighborhood[tile.gridY] = vNeighborhood[y]
    vNeighborhood[y] = tile.color

    for i1 = yMin, yMax - 2 do
        allSameColor = true
        for i2 = i1, i1 + 2 do
            allSameColor = allSameColor and vNeighborhood[i2] == tile.color    
        end
        if allSameColor then
            return true
        end
    end
    
    return false
end

--[[
    Function that check if a tile can be moved to the selected position
]]
function Board:canMove(tile, x, y)
    if x < 1 or x > 8 or y < 1 or y > 8 then
        return false
    end

    return self:willThereBeMatch(tile, x, y) or self:willThereBeMatch(self.tiles[y][x], tile.gridX, tile.gridY)
end

--[[
    Function that checks if exists any match in the board
]]
function Board:existsMatch()
    for y = 1, 8 do
        for x = 1, 8 do
            tile = self.tiles[y][x]
            if self:canMove(tile, x - 1, y) or self:canMove(tile, x + 1, y) or self:canMove(tile, x, y - 1) or self:canMove(tile, x, y + 1) then
                print("Can move:", tostring(x), tostring(y))
                return true
            end
        end
    end
    print("No movements available")
    return false
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
