GameView = Object:extend()

function GameView:new()
    self.game = nil
    self.scoreBoard      = ScoreBoard()
    self.statsBoard      = StatsBoard()    
    self.gameOverBoard   = GameOverBoard()
    self.winnerBoard     = WinnerBoard()   
    self.menuBoard       = MenuBoard() 
end

function GameView:setGame( game )
    self.game = game
    self.statsBoard.stats = game.stats
end

function GameView:draw()
    if self.game.started then
        self:drawPlayers()
        self:drawEnemies()
        self:drawObjects()
        self:drawExplosions()
        self:drawBullets()
        self:drawScore()
        self:drawStats()
        self:drawDebugData()
        self:drawMessages()
    else 
        self:drawMenu()
    end
end

function GameView:drawMenu()
    self.menuBoard:draw()
end

function GameView:drawPlayers()
    local PI = 3.14159265358
    for i,player in ipairs(self.game.lives) do
        setMainColor()
        player:draw()
        if debugMode then
            setDebugColor()
            love.graphics.print("player " .. i .. -- " ->  x:" .. player.x .. " y:" .. player.y .. 
                                " w:" .. player.width .. " h: " .. player.height .. 
                                " fs:" .. #player.frames ..
                                " cf:" .. player.currentFrame ..
                                " r:" .. math.floor(player.orientation * 180 / PI) .. 
                                ' d:' .. (player:isDead() and 'true' or 'false'), 
                                10, 15*i + 10)
        end    
    end
end

function GameView:drawEnemies()
    for i,enemy in ipairs(self.game.enemies) do
        setMainColor()
        enemy:draw()
        if debugMode then
            setDebugColor()
            if not enemy:isSquadron() then
                love.graphics.print("enemy " .. i .. -- "[" .. enemy.uuid .. "] " ..
                        -- "->  x:" .. enemy.x .. " y:" .. enemy.y .. 
                        " w:" .. enemy.width .. " h: " .. enemy.height .. " cf: " .. enemy.currentFrame .. 
                        " s:" .. enemy.speed .. ' nf: ' ..#enemy.frames .. ' active:' .. (enemy.active and 'true' or 'false'),
                        10, (15*#self.game.lives+10)+(15*i+10))
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
        if debugMode then
            setDebugColor()
            love.graphics.print("explosion " .. i .. " ->  x:" .. explosion.x .. " y:" .. explosion.y .. " w:" .. explosion.width .. " h: " .. explosion.height, 10, 15*i + 100)
        end  
    end
end

function GameView:drawBullets()
    for i,bullet in ipairs(self.game.playerBullets) do
        setMainColor()
        bullet:draw()
        if debugMode then
            setDebugColor()
            love.graphics.print("player bullet " .. i .. " ->  x:" .. bullet.x .. " y:" .. bullet.y .. " w:" .. bullet.width .. " h: " .. bullet.height, 10, 15*i + 100)
        end  
    end
    for i,bullet in ipairs(self.game.enemyBullets) do
        setMainColor()
        bullet:draw()
        if debugMode then
            setDebugColor()
            love.graphics.print("enemy bullet " .. i .. " ->  x:" .. bullet.x .. " y:" .. bullet.y .. " w:" .. bullet.width .. " h: " .. bullet.height, 10, 15*i + 300)
        end  
    end
end

function GameView:drawScore()
    self.scoreBoard:draw()
end

function GameView:drawStats()
    self.statsBoard:draw()
end

function GameView:drawDebugData()
    if debugMode then
        setDebugColor()
        if self.game:isPaused() then
            love.graphics.print("pause delay: " .. (self.game.pause.delay),10,365)   
            love.graphics.print("pause: " .. (self.game.pause.board:getMessage()),10,380)   
        end
        if self.game:currentLevel() then
            local level = self.game:currentLevel()
            love.graphics.print("current level: " .. level.name .. 
                        " active: " .. ( level.active and "true" or "false" ) .. 
                        " complete: " .. (level.complete and "true" or "false"),
                        10,425)   
        end
        love.graphics.print("levels: " .. (#self.game.levels),10,440)   
        love.graphics.print("game over: " .. (self.game:isOver() and "true" or "false"),10,455)        
        love.graphics.print("game paused: " .. (self.game:isPaused() and "true" or "false"),10,470)               
        love.graphics.print("player bullets: " .. (#self.game.playerBullets),10,485)
        love.graphics.print("enemy bullets: " .. (#self.game.enemyBullets),10,500)
        love.graphics.print("lives: " .. (#self.game.lives),10,515)
        love.graphics.print("enemies: " .. (#self.game.enemies),10,530)
        love.graphics.print("explosions: " .. (#self.game.explosions),10,545)

        for i,level in ipairs(self.game.levels) do
            love.graphics.print("level " .. i .. " name:" .. level.name .. " active:" .. (level.active and "true" or "false ") .." complete:" .. (level.complete and "true" or "false "),10,200+i*15)
        end
    end

    --love.graphics.print(highScoreManager:scoresAsJson(),10,10)
    
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
    self.gameOverBoard:draw()
end

function GameView:notifyWin()
    self.winnerBoard:draw()
end

function GameView:updateScore( score )
    self.scoreBoard:setScore( score )
end    