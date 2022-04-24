GameView = Object:extend()

function GameView:new()
    self.game = nil
end

function GameView:setGame( game )
    self.game = game
end

function GameView:draw()
    self:drawPlayers()
    self:drawEnemies()
    self:drawObjects()
    self:drawExplosions()
    self:drawBullets()
    self:drawScore()
    self:drawDebugData()
    self:drawMessages()
end

function GameView:drawPlayers()
    local PI = 3.14159265358
    for i,player in ipairs(self.game.lives) do
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

function GameView:drawEnemies()
    for i,enemy in ipairs(self.game.enemies) do
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

function GameView:drawObjects()
    for i,object in ipairs(self.game.objects) do
        setMainColor()
        object:draw()
    end
end

function GameView:drawExplosions()
    for i,explosion in ipairs(self.game.explosions) do
        setMainColor()
        explosion:draw()
    end
end

function GameView:drawBullets()
    for i,bullet in ipairs(self.game.playerBullets) do
        setMainColor()
        bullet:draw()
        if debug then
            setDebugColor()
            love.graphics.print("player bullet " .. i .. " ->  x:" .. bullet.x .. " y:" .. bullet.y .. " w:" .. bullet.width .. " h: " .. bullet.height, 10, 15*i + 100)
        end  
    end
    for i,bullet in ipairs(self.game.enemyBullets) do
        setMainColor()
        bullet:draw()
        if debug then
            setDebugColor()
            love.graphics.print("enemy bullet " .. i .. " ->  x:" .. bullet.x .. " y:" .. bullet.y .. " w:" .. bullet.width .. " h: " .. bullet.height, 10, 15*i + 300)
        end  
    end
end

function GameView:drawScore()
    self.game.scoreBoard:draw()
end

function GameView:drawDebugData()
    if debug then
        setDebugColor()
        if self.game:isPaused() then
            love.graphics.print("pause delay: " .. (self.game.pause.delay),10,395)   
            love.graphics.print("pause: " .. (self.game.pause.board.message),10,410)   
        end
        if self.game:currentLevel() then
            love.graphics.print("current level complete: " .. (self.game:currentLevel().complete and "true" or "false"),10,425)   
        end
        love.graphics.print("levels: " .. (#self.game.levels),10,440)   
        love.graphics.print("game over: " .. (self.game:isOver() and "true" or "false"),10,455)        
        love.graphics.print("game paused: " .. (self.game:isPaused() and "true" or "false"),10,470)               
        love.graphics.print("player bullets: " .. (#self.game.playerBullets),10,485)
        love.graphics.print("enemy bullets: " .. (#self.game.enemyBullets),10,500)
        love.graphics.print("lives: " .. (#self.game.lives),10,515)
        love.graphics.print("enemies: " .. (#self.game.enemies),10,530)
    end
end

function GameView:drawMessages()
    if self.game:isPaused() then
        self:notifyPause()
    end
    if self.game:playerLost() then
        self:notifyLoss()
    end
    if self.game:playerWon() then
        self:notifyWin()
    end  
end

function GameView:notifyPause()
    self.game.pause:draw()
end

function GameView:notifyLoss()
    self.game.gameOverBoard:draw()
end

function GameView:notifyWin()
    self.game.winnerBoard:draw()
end

