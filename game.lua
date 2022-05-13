Game = Object:extend()

function Game:new()

    self.lives          = {}
    self.enemies        = {}
    self.objects        = {}
    self.playerBullets  = {}
    self.enemyBullets   = {}
    self.explosions     = {}    
    self.levels         = {}
        
    self.pause           = nil
    self.stats           = GameStats()
    self.view            = GameView()
    self.soundFX         = SoundFX()
    self.started         = false

    self.soundFX:startThemeSong()
end

function Game:livesPerGame()
    return 3
end    

function Game:start()
    self:initializeLives()
    self:initializeLevels()
    self:activateNextPlayer()
    self:activateNextLevel()
    self.started = true
    self.soundFX:stopThemeSong()    
end    

function Game:initializeLives()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local spacePerPlayer = (resources:getCharacterDimensions().frameWidth+2)*2
    local y = screenHeight - spacePerPlayer
    local livesCount = self:livesPerGame()
    for i=1,livesCount do
        table.insert(self.lives, Player(((livesCount-i)*spacePerPlayer)+20,y))
    end
end

function Game:initializeLevels()
    table.insert(self.levels, JsonLevel(game, "Level 1", "levels/level1.json", 10))
    table.insert(self.levels, JsonLevel(game, "Level 2", "levels/level2.json", 10))
    table.insert(self.levels, JsonLevel(game, "Level 3", "levels/level3.json", 10))
end

function Game:update(dt)
        
    -- Start the game if user pressed a key
    if not self.started then
        if control:start() then
            game:start()
        end
    end

    -- If the game ispaused, update the pause timer
    if self:isPaused() then
        self.pause:update(dt) 
        if self:userRequestedPauseElapsed() then
            self:resume()
        end   
        if self:gameOverPauseElapsed() then
            self:resume()
        end           
    else
        -- Check if the game was manually paused
        if control:pause() then
            self.pause = UserRequestedPause()
        end               
    end    

    -- If the game is ongoing, update the characters
    if not self:isOver() then

        local player = self:currentPlayer()
        local level = self:currentLevel()

        -- Check that there is an active player
        if player and player:isDead() and self:playerKilledPauseElapsed() then
            self:resume()
            self:destroyCurrentPlayer()       
            self:activateNextPlayer()
        end

        -- Check whether the current level is complete
        if level and level.complete and self:levelCompletedPauseElapsed() then 
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

            -- Check for collisions between characters
            for i, squadron in ipairs(self.enemies) do 
                local activeEnemies = squadron:getActiveEnemies()
                for j, enemy in ipairs(activeEnemies) do
                    if player:collides(enemy) then
                        player:die()
                        enemy:die() -- TODO this should not score points
                    end
                end
            end                       

        end

        -- Pause if the game ended
        if self:isOver() then
            self.pause = GameOverPause()
        end

    end

end

function Game:addEnemy( enemy )
    table.insert(self.enemies, enemy)
end

function Game:addObject( object )
    table.insert(self.objects, object)
end

function Game:addPlayerBullet( object )
    self.stats:bulletShot()
    table.insert(self.playerBullets, object)
    if self.soundFX then self.soundFX:shoot() end
end

function Game:addEnemyBullet( object )
    table.insert(self.enemyBullets, object)
end

function Game:addExplosion( object )
    table.insert(self.explosions, object)
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
    self.view:setGame(self)
    self.view:draw()
end

function Game:isPaused()
    return self.pause 
end

function Game:levelCompletedPauseElapsed()
    return self.pause 
        and self.pause:is( LevelCompletedPause ) 
        and self.pause:elapsed()
end     

function Game:playerKilledPauseElapsed()
    return self.pause 
        and self.pause:is( PlayerKilledPause ) 
        and self.pause:elapsed()
end

function Game:userRequestedPauseElapsed()
    return self.pause 
        and self.pause:is( UserRequestedPause ) 
        and self.pause:elapsed()
end

function Game:gameOverPauseElapsed()
    return self.pause 
        and self.pause:is( GameOverPause ) 
        and self.pause:elapsed()
end

function Game:handlePlayerKilledEvent()
    local lives = self:livesRemaining()
    if lives > 0 then
        self.pause = PlayerKilledPause( (self:livesPerGame() - self:livesRemaining()) .. " UP" )
    end
    self.soundFX:killPlayer()
end

function Game:handleEnemyKilledEvent( enemy )
    self.stats:enemyKilled( enemy )
    self.view:updateScore(self.stats.score)
end

function Game:handleLevelCompletedEvent()
    local levels = self:levelsRemaining()
    if levels > 0 then
        local nextLevel = self.levels[2]
        self.pause = LevelCompletedPause( nextLevel.name ) 
    end
    self.soundFX:startLevel()
    self.enemies = {}
    self.objects = {}
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

function Game:resume()
    self.pause = nil
end

function Game:destroyCurrentPlayer()
    table.remove(self.lives,1)  
end

function Game:destroyCurrentLevel()
    table.remove(self.levels,1)  
end

function Game:playerLost()
    return self:livesRemaining() <= 0 
end

function Game:playerWon()
    return self:levelsRemaining() <= 0 
end

function Game:isOver()
    -- return false
    return self:playerWon()
        or self:playerLost()
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
        if level and not level:hasStarted() then
            level:activate()
        end
    end
end