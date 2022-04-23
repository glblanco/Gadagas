function requireLibraries()
    -- First require classic, since we use it to create our classes.
    Object = require "external/classic"
    require "entity"
    require "resources"
    require "utils/control"
    require "utils/uuid-generator"
    require "characters/character"
    require "characters/player"
    require "characters/enemy"
    require "characters/attack-plan"
    require "characters/flight-plan"
    require "characters/flight-plans/demos"
    require "characters/flight-plans/simple-paths"
    require "characters/flight-plans/composite-plans"        
    require "characters/flight-plans/snap-to-grid"        
    require "characters/squadron"
    require "characters/bullet"
    require "characters/explosion"
end 

function love.load()
    
    requireLibraries()
    
    lives = {}
    enemies = {}
    objects = {}
    playerBullets = {}
    enemyBullets = {}
    explosions = {}    

    control = Control()
    resources = Resources()
    uuidGenerator = UUIDGenerator()

    debug = false
    
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local spacePerPlayer = (resources.characterFrameWidth+2)*2
    local y = screenHeight - spacePerPlayer
    local livesCount = 3
    for i=1,livesCount do
        table.insert(lives, Player(((livesCount-i)*spacePerPlayer)+20,y))
    end

    nextPlayer()
    
    grid = HoverGrid(10,15)
    table.insert(enemies, A3Squadron(grid))
    table.insert(objects, grid)
    -- table.insert(explosions, EnemyExplosion(200,200))
    -- table.insert(explosions, PlayerExplosion(200,200))
    
    pause = 0
    gameOver = false
    score = 0
end

function love.update(dt)
    if not player.visible and pause > 1 then
        pause = 0
        table.remove(lives,1)        
        nextPlayer()
    end
    if #lives <= 0 then
        gameOver = true
    else
        for i,player in ipairs(lives) do
            player:update(dt)
            if not player.visible then
                pause = pause + dt
            end
        end
        updateList(explosions,dt)
        if pause == 0 then
            updateList(enemies,dt) 
            updateList(playerBullets,dt)
            updateList(enemyBullets,dt)
            updateList(objects,dt)     
        end
    end
    control:update(dt)
end

function updateList( aList, dt )
    for i,item in ipairs(aList) do
        item:update(dt)
        if not item.active then
            table.remove(item,i)
        end
    end  
end

function love.draw() 
    local PI = 3.14159265358
    for i,player in ipairs(lives) do
        setMainColor()
        player:draw()
        if debug then
            setDebugColor()
            love.graphics.print("player " .. i .. " ->  x:" .. player.x .. " y:" .. player.y .. " w:" .. player.width .. " h: " .. player.height .. " r:" .. math.floor(player.orientation * 180 / PI) , 10, 15*i + 10)
        end    
    end
    for i,enemy in ipairs(enemies) do
        setMainColor()
        enemy:draw()
        if debug then
            setDebugColor()
            if not enemy:isSquadron() then
                love.graphics.print("enemy " .. i .. "[" .. enemy.uuid .. "] ->  x:" .. enemy.x .. " y:" .. enemy.y .. " w:" .. enemy.width .. " h: " .. enemy.height .. " cf: " .. enemy.currentFrame .. " s: " .. enemy.speed .. ' nf: ' ..#enemy.frames .. ' active:' .. (enemy.active and 'true' or 'false'), 10, (15*#lives+10)+(15*i+10))
            end
        end
    end
    for i,object in ipairs(objects) do
        setMainColor()
        object:draw()
    end
    for i,bullet in ipairs(playerBullets) do
        setMainColor()
        bullet:draw()
        if debug then
            setDebugColor()
            love.graphics.print("player bullet " .. i .. " ->  x:" .. bullet.x .. " y:" .. bullet.y .. " w:" .. bullet.width .. " h: " .. bullet.height, 10, 15*i + 100)
        end  
    end
    for i,bullet in ipairs(enemyBullets) do
        setMainColor()
        bullet:draw()
        if debug then
            setDebugColor()
            love.graphics.print("enemy bullet " .. i .. " ->  x:" .. bullet.x .. " y:" .. bullet.y .. " w:" .. bullet.width .. " h: " .. bullet.height, 10, 15*i + 300)
        end  
    end
    for i,explosion in ipairs(explosions) do
        setMainColor()
        explosion:draw()
    end
    if gameOver then
        setTextColor()
        love.graphics.print("Game over",love.graphics.getWidth()*0.9/2,love.graphics.getHeight()*0.8/2)
    end
    setTextColor()
        love.graphics.print("Score: "..score,love.graphics.getWidth()*0.9/2,love.graphics.getHeight()*0.05)
    if debug then
        setDebugColor()
        love.graphics.print("player bullets: " .. (#playerBullets),10,485)
        love.graphics.print("enemy bullets: " .. (#enemyBullets),10,500)
        love.graphics.print("lives: " .. (#lives),10,515)
        love.graphics.print("enemies: " .. (#enemies).. ' ' .. (math.random(0, 1)),10,530)
    end
end

function setTextColor()
    love.graphics.setColor(1,0,0)
end

function setMainColor()
    love.graphics.setColor(1,1,1)
end

function setDebugColor()
    love.graphics.setColor(163/255, 163/255, 155/255)
end

function nextPlayer()
    if #lives > 0 then
        player = lives[1]
        player:activate()
    end
end