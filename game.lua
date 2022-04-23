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
    
    self.paused     = false
    self.pauseDelay = 0

    self.scoreBoard      = ScoreBoard()
    self.gameOverBoard   = GameOverBoard()
end

function Game:update(dt)
    if not self:isOver() then
        local player = self:currentPlayer()
        if not player.visible and self.pauseDelay > 1 then
            self.pauseDelay = 0
            self.paused = false
            self:destroyCurrentPlayer()       
            self:activateNextPlayer()
        end
        for i,player in ipairs(self.lives) do
            player:update(dt)
        end
        self:updateList(self.explosions,dt)
        if not self:isPaused() then
            self:updateList(self.enemies,dt) 
            self:updateList(self.playerBullets,dt)
            self:updateList(self.enemyBullets,dt)
            self:updateList(self.objects,dt)     
        else
            self.pauseDelay = self.pauseDelay + dt
        end
    end
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
        self:notifyPauseMotive()
    end
    if self:isOver() then
        self:notifyGameOver()
    end
end

function Game:notifyPauseMotive()
end

function Game:isPaused()
    return self.paused
end

function Game:enemyKilled( enemy )
    self.scoreBoard:add(100)
end

function Game:playerKilled()
    self.paused = true
    self.pauseDelay = 0
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
            love.graphics.print("player " .. i .. " ->  x:" .. player.x .. " y:" .. player.y .. " w:" .. player.width .. " h: " .. player.height .. " r:" .. math.floor(player.orientation * 180 / PI) , 10, 15*i + 10)
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
                love.graphics.print("enemy " .. i .. "[" .. enemy.uuid .. "] ->  x:" .. enemy.x .. " y:" .. enemy.y .. " w:" .. enemy.width .. " h: " .. enemy.height .. " cf: " .. enemy.currentFrame .. " s: " .. enemy.speed .. ' nf: ' ..#enemy.frames .. ' active:' .. (enemy.active and 'true' or 'false'), 10, (15*#lives+10)+(15*i+10))
            end
        end
    end
end

function Game:drawDebugData()
    if debug then
        setDebugColor()
        love.graphics.print("game over: " .. (self:isOver() and "true" or "false"),10,470)        
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
    return #self.lives <= 0 
end

function Game:currentPlayer()
    return self.lives[1]
end

function Game:activateNextPlayer()
    if not self:isOver() then
        self:currentPlayer():activate()
    end
end