--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

MAX_POINTS_TO_PADDLE_GROWTH = 1000

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.numLiveBricks = params.numLiveBricks
    self.lockedBrick = params.lockedBrick

    -- By Alejandro: Table of balls
    self.balls = {}
    table.insert(self.balls, 1, params.ball)

    self.level = params.level

    -- By Alejandro: Table of power ups
    self.powerUps = {}

    -- By Alejandro: hits counter.
    self.hits_counter = 0

    -- By Alejandro: points for paddle growth
    self.paddleGrowthPoints = MAX_POINTS_TO_PADDLE_GROWTH

    self.recoverPoints = 5000

    -- give ball random starting velocity (By Alejandro: to the first ball)
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    -- By Alejandro: upate all balls
    for kb, ball in pairs(self.balls) do
        ball:update(dt)

        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
        
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end

        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                current_score = not brick.locked and (brick.tier * 200 + brick.color * 25) or 0

                -- add to score
                self.score = self.score + current_score

                -- By Alejandro: Update the points for paddle growth
                self.paddleGrowthPoints = self.paddleGrowthPoints - current_score

                if self.paddleGrowthPoints < 0 then
                    -- reset the points
                    self.paddleGrowthPoints = MAX_POINTS_TO_PADDLE_GROWTH
                    self.paddle:inc_size()
                end

                -- trigger the brick's hit function, which removes it from play
                brick:hit()

                -- By Alejandro: Increment hits counter
                self.hits_counter = self.hits_counter + 1

                if not brick.inPlay then
                    self.numLiveBricks = self.numLiveBricks - 1
                end

                if self.lockedBrick ~= nil and math.random(self.numLiveBricks) == 1 then
                    -- create a new key power up 
                    table.insert(self.powerUps, PowerUp(brick.x + brick.width/2 - 8, brick.y + 16, KEY_POWER_UP))
                else
                    -- Check probability of generating ball power up
                    -- Generating a good gap
                    local p = 10+10^#self.powerUps+10^#self.balls
                    if math.random(p) < self.hits_counter then
                        -- create a new ball power up 
                        table.insert(self.powerUps, PowerUp(brick.x + brick.width/2 - 8, brick.y + 16, BALL_POWER_UP))
                        -- reset the hits counter
                        self.hits_counter = 0
                    end
                end

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    local ball = nil

                    for i, b in pairs(self.balls) do
                        ball = b
                        break
                    end

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = ball,
                        recoverPoints = self.recoverPoints
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
            
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
            
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
            
                -- bottom edge if no X collisions or top collision, last possibility
                else
                
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
        if ball.y > VIRTUAL_HEIGHT then
            -- ball is out of game
            table.remove(self.balls, kb)
        end
    end

    -- By Alejandro: Update the powerUps
    for k, powerUp in pairs(self.powerUps) do
        powerUp:update(dt)

        if powerUp.y > VIRTUAL_HEIGHT then
            -- power up is out of game
            table.remove(self.powerUps, k)
        elseif powerUp:collides(self.paddle) then
            -- powerUp collides with de paddle
            if powerUp.skin == BALL_POWER_UP then
                -- Spawn two more balls
                newBall1 = Ball(math.random(7))
                newBall1.x = self.paddle.x + self.paddle.width/2 - 4
                newBall1.y = self.paddle.y - 8
                newBall1.dx = math.random(-200, 200)
                newBall1.dy = math.random(-50, -60) 
                table.insert(self.balls, newBall1)
                newBall2 = Ball(math.random(7))
                newBall2.x = self.paddle.x + self.paddle.width/2 - 4
                newBall2.y = self.paddle.y - 8
                newBall2.dx = math.random(-200, 200)
                newBall2.dy = math.random(-50, -60) 
                table.insert(self.balls, newBall2)
            elseif powerUp.skin == KEY_POWER_UP and self.lockedBrick ~= nil then
                -- Unlock the locked brick
                self.lockedBrick.locked = false
                self.lockedBrick = nil
            end
            -- when a power up is taken, it must be exit of the game
            table.remove(self.powerUps, k)
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    -- By Alejandro: 
    if #self.balls == 0 then
        self.paddle:dec_size()
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints,
                numLiveBricks = self.numLiveBricks,
                lockedBrick = self.lockedBrick
            })
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    -- By Alejandro: render all power ups
    for k, powerUp in pairs(self.powerUps) do
        powerUp:render()
    end

    self.paddle:render()

    -- By Alejandro: render all balls
    for k, ball in pairs(self.balls) do
        ball:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end
