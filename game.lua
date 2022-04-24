Game = Object:extend()

function Game:new()

    self.lives = {}
    self.enemies = {}
    self.objects = {}
    self.playerBullets = {}
    self.enemyBullets = {}
    self.explosions = {}    
    self.levels = {}
    
    self:initializeLives()
    self:initializeLevels()

    self.pause           = nil
    self.scoreBoard      = ScoreBoard()
    self.gameOverBoard   = GameOverBoard()
    self.winnerBoard     = WinnerBoard()

    self:activateNextPlayer()
end

function Game:livesPerGame()
    return 3
end    

function Game:initializeLives()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local spacePerPlayer = (resources.characterFrameWidth+2)*2
    local y = screenHeight - spacePerPlayer
    local livesCount = self:livesPerGame()
    for i=1,livesCount do
        table.insert(self.lives, Player(((livesCount-i)*spacePerPlayer)+20,y))
    end
end

function Game:initializeLevels()
    table.insert(self.levels, Level())
    table.insert(self.levels, Level())
end

function Game:update(dt)
    
    if not self:isOver() then
        -- Check that there is an active player
        local player = self:currentPlayer()
        if player:isDead() and (self:playerKilledPauseElapsed() or self:playerLost())  then
            self:resume()
            self:destroyCurrentPlayer()       
            self:activateNextPlayer()
        end
        -- Check whether the current level has started
        local level = self:currentLevel()
        if not level.active and not level.complete then
            self:activateNextLevel()
        end
        -- Check whether the current level is complete
        if level.complete and self:levelCompletedPauseElapsed()  then -- TODO this is not pausing
            self:resume()
            self:destroyCurrentLevel()       
            self:activateNextLevel()
        end
        -- Update levels (regardless of pauses)
        self:updateList(self.levels,dt,false) 
        -- Update explosions (regardless of pauses)
        self:updateList(self.explosions,dt,true)
        -- Update the rest of the game objects, removing them if not active any more
        if not self:isPaused() then
            self:updateList(self.lives,dt,false)
            self:updateList(self.enemies,dt,true) 
            self:updateList(self.playerBullets,dt,true)
            self:updateList(self.enemyBullets,dt,true)
            self:updateList(self.objects,dt,true)     
        else
            self.pause:update(dt) 
        end
    end
end

function Game:updateList( aList, dt, removeInactiveItems )
    if aList then
        for i,item in ipairs(aList) do
            item:update(dt)
            if removeInactiveItems and not item.active then
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
    self:drawMessages()
end

function Game:drawMessages()
    if self:isPaused() then
        self:notifyPause()
    end
    if self:playerLost() then
        self:notifyLoss()
    end
    if self:playerWon() then
        self:notifyWin()
    end  
end

function Game:notifyPause()
    self.pause:draw()
end

function Game:isPaused()
    return self.pause 
end

function Game:levelCompletedPauseElapsed()
    return self.pause 
        -- and self.pause:is( LevelCompletedPause ) 
        and self.pause:elapsed()
end     

function Game:playerKilledPauseElapsed()
    return self.pause 
        and self.pause:is( PlayerKilledPause ) 
        and self.pause:elapsed()
end

function Game:enemyKilled( enemy )
    self.scoreBoard:add(100)
end

function Game:levelComplete()
    local levels = self:levelsRemaining()
    if levels > 0 then
        self.pause = LevelCompletedPause( "Next Level" ) -- TODO appropriate text 
    end
end    

function Game:levelsRemaining()
    local count = 0
    for i,object in ipairs(self.levels) do
        if not object.complete then -- TODO verify implementation
           count = count + 1
        end
    end
    return count
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

function Game:destroyCurrentLevel()
    table.remove(self.levels,1)  
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
        if self:isPaused() then
            love.graphics.print("pause delay: " .. (self.pause.delay),10,395)   
            love.graphics.print("pause: " .. (self.pause.board.message),10,410)   
        end
        if self:currentLevel() then
            love.graphics.print("current level complete: " .. (self:currentLevel().complete and "true" or "false"),10,425)   
        end
        love.graphics.print("levels: " .. (#self.levels),10,440)   
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

function Game:notifyLoss()
    self.gameOverBoard:draw()
end

function Game:notifyWin()
    self.winnerBoard:draw()
end

function Game:playerLost()
    return self:livesRemaining() <= 0 
end

function Game:playerWon()
    return self:levelsRemaining() <= 0 
end

function Game:isOver()
    return self:livesRemaining() <= 0 
        or self:levelsRemaining() <= 0 
end

function Game:currentPlayer()
    return self.lives[1]
end

function Game:currentLevel()
    return self.levels[1]
end

function Game:activateNextPlayer()
    if not self:isOver() then
        self:currentPlayer():activate()
    end
end

function Game:activateNextLevel()
    if not self:isOver() then
        local level = self:currentLevel()
        if level then
            level:activate()
        end
    end
end