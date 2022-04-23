Game = Object:extend()

function Game:new()

    self.lives = {}
    self.enemies = {}
    self.objects = {}
    self.playerBullets = {}
    self.enemyBullets = {}
    self.explosions = {}    
    
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local spacePerPlayer = (resources.characterFrameWidth+2)*2
    local y = screenHeight - spacePerPlayer
    local livesCount = 3
    for i=1,livesCount do
        table.insert(self.lives, Player(((livesCount-i)*spacePerPlayer)+20,y))
    end
    self:activateNextPlayer()
    
    self.grid = HoverGrid(10,15)
    table.insert(self.enemies, A3Squadron(self.grid))
    table.insert(self.objects, self.grid)
    
    self.pause           = nil
    self.scoreBoard      = ScoreBoard()
    self.gameOverBoard   = GameOverBoard()

end

function Game:update(dt)
    if not self:isOver() then
        -- Check that there is an active player
        local player = self:currentPlayer()
        if player:isDead() and (self:playerKilledPauseElapsed() or self:isOver())  then
            self:resume()
            self:destroyCurrentPlayer()       
            self:activateNextPlayer()
        end
        -- Update all players
        for i,player in ipairs(self.lives) do
            player:update(dt)
        end
        -- Update explosions
        self:updateList(self.explosions,dt)
        -- Update the rest of the game objects, removing them if not active any more
        if not self:isPaused() then
            self:updateList(self.enemies,dt) 
            self:updateList(self.playerBullets,dt)
            self:updateList(self.enemyBullets,dt)
            self:updateList(self.objects,dt)     
        else
            self.pause:update(dt) 
        end
    end
end

function Game:playerKilledPauseElapsed()
    return self.pause 
            and self.pause:is( PlayerKilledPause ) 
            and self.pause:elapsed()
end

function Game:updateList( aList, dt )
    if aList then
        for i,item in ipairs(aList) do
            item:update(dt)
            if not item.active then
                table.remove(aList,i)
            end
        end  
    end
end

function Game:draw()
    self:drawPlayers()
    self:drawEnemies()
    self:drawObjects()
    self:drawExplosions()
    self:drawBullets()
    self:drawScore()
    self:drawDebugData()
    if self:isPaused() then
        self:notifyPause()
    end
    if self:isOver() then
        self:notifyGameOver()
    end
end

function Game:notifyPause()
    self.pause:draw()
end

function Game:isPaused()
    return self.pause 
end

function Game:enemyKilled( enemy )
    self.scoreBoard:add(100)
end

function Game:livesRemaining()
    local count = 0
    for i,object in ipairs(self.lives) do
        if not object:isDead() then
            count = count + 1
        end
    end
    return count
end

function Game:playerKilled()
    local lives = self:livesRemaining()
    if lives > 0 then
        self.pause = PlayerKilledPause( (#self.lives - 1) .. " UP" )
    end
end

function Game:resume()
    self.pause = nil
end

function Game:destroyCurrentPlayer()
    table.remove(self.lives,1)  
end

function Game:drawObjects()
    for i,object in ipairs(self.objects) do
        setMainColor()
        object:draw()
    end
end

function Game:drawExplosions()
    for i,explosion in ipairs(self.explosions) do
        setMainColor()
        explosion:draw()
    end
end

function Game:drawBullets()
    for i,bullet in ipairs(self.playerBullets) do
        setMainColor()
        bullet:draw()
        if debug then
            setDebugColor()
            love.graphics.print("player bullet " .. i .. " ->  x:" .. bullet.x .. " y:" .. bullet.y .. " w:" .. bullet.width .. " h: " .. bullet.height, 10, 15*i + 100)
        end  
    end
    for i,bullet in ipairs(self.enemyBullets) do
        setMainColor()
        bullet:draw()
        if debug then
            setDebugColor()
            love.graphics.print("enemy bullet " .. i .. " ->  x:" .. bullet.x .. " y:" .. bullet.y .. " w:" .. bullet.width .. " h: " .. bullet.height, 10, 15*i + 300)
        end  
    end
end

function Game:drawPlayers()
    local PI = 3.14159265358
    for i,player in ipairs(self.lives) do
        setMainColor()
        player:draw()
        if debug then
            setDebugColor()
            love.graphics.print("player " .. i .. " ->  x:" .. player.x .. " y:" .. player.y .. " w:" .. player.width .. " h: " .. player.height .. 
                                " r:" .. math.floor(player.orientation * 180 / PI) .. ' d:' .. (player:isDead() and 'true' or 'false'), 
                                10, 15*i + 10)
        end    
    end
end

function Game:drawEnemies()
    for i,enemy in ipairs(self.enemies) do
        setMainColor()
        enemy:draw()
        if debug then
            setDebugColor()
            if not enemy:isSquadron() then
                love.graphics.print("enemy " .. i .. "[" .. enemy.uuid .. "] ->  x:" .. enemy.x .. " y:" .. enemy.y .. 
                        " w:" .. enemy.width .. " h: " .. enemy.height .. " cf: " .. enemy.currentFrame .. 
                        " s: " .. enemy.speed .. ' nf: ' ..#enemy.frames .. ' active:' .. (enemy.active and 'true' or 'false'), 
                        10, (15*#lives+10)+(15*i+10))
            end
        end
    end
end

function Game:drawDebugData()
    if debug then
        setDebugColor()
        love.graphics.print("game over: " .. (self:isOver() and "true" or "false"),10,455)        
        love.graphics.print("game paused: " .. (self:isPaused() and "true" or "false"),10,470)               
        love.graphics.print("player bullets: " .. (#self.playerBullets),10,485)
        love.graphics.print("enemy bullets: " .. (#self.enemyBullets),10,500)
        love.graphics.print("lives: " .. (#self.lives),10,515)
        love.graphics.print("enemies: " .. (#self.enemies).. ' ' .. (math.random(0, 1)),10,530)
    end
end

function Game:drawScore()
    self.scoreBoard:draw()
end

function Game:notifyGameOver()
    self.gameOverBoard:draw()
end

function Game:isOver()
    return self:livesRemaining() <= 0 
end

function Game:currentPlayer()
    return self.lives[1]
end

function Game:activateNextPlayer()
    if not self:isOver() then
        self:currentPlayer():activate()
    end
end