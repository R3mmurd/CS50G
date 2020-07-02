    --[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- random color for lock and key.
    local lockAndKeyColor = math.random(4)

    -- columns to generate key and lock
    local lockColumn = math.random(math.floor(width / 2), width)
    local keyColumn = math.random(math.floor(width / 2), width)

    -- positions to generate the goal post
    local goalColumn = 1
    local goalRow = 4

    local postBlock = lockAndKeyColor - 1

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if lockColumn ~= x and keyColumn ~= x and math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            goalColumn = x
            goalRow = 4
            tileID = TILE_ID_GROUND

            local blockHeight = 4
            local keyHeight = 6

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                goalRow = 2
                keyHeight = 4
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- spawn the key if x is the column for it
            if x == keyColumn then
                generatedKey = true
                table.insert(objects,
                    GameObject {
                        texture = 'keys_and_locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (keyHeight - 1) * TILE_SIZE - 4,
                        width = 16,
                        height = 16,
                        frame = lockAndKeyColor,
                        collidable = true,
                        consumable = true,
                        solid = false,

                        -- key has its own function to add it to the player
                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            player.keyTaken = true
                        end
                    }
                )
            end

            -- spawn the lock if x is the column for it
            if x == lockColumn then
                generatedLock = true
                table.insert(objects,

                    -- lock
                    GameObject {
                        texture = 'keys_and_locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = lockAndKeyColor + 4,
                        collidable = true,
                        hit = false,
                        solid = true,
                        isTheLock = true,
                        
                        onCollide = function(player, obj)
                            if player.keyTaken then
                                -- spawn the posts
                                for i = 1, 3 do
                                    table.insert(objects,
                                        GameObject {
                                            texture = 'posts',
                                            x = (goalColumn - 1) * TILE_SIZE - TILE_SIZE / 2,
                                            y = (goalRow + (i - 1) - 1) * TILE_SIZE,
                                            width = 16,
                                            height = 16,
                                            frame = postBlock*3 + i,
                                            collidable = true,
                                            consumable = true,
                                            solid = false,

                                            onConsume = function(player, object)
                                                gStateMachine:change('play', {
                                                    score = player.score,
                                                    levelWidth = math.floor(player.level.tileMap.width * 1.25)
                                                })
                                            end
                                        }
                                    )
                                end
                                -- spawn the flag
                                table.insert(objects,
                                    GameObject {
                                        texture = 'flags',
                                        x = (goalColumn - 1) * TILE_SIZE,
                                        y = (goalRow - 1) * TILE_SIZE,
                                        width = 16,
                                        height = 16,
                                        frame = lockAndKeyColor,
                                        collidable = true,
                                        consumable = false,
                                        solid = false
                                    }
                                )
                            end
                        end
                    }
                )

            -- chance to spawn a block
            elseif math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end