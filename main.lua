function requireLibraries()
    -- First require classic, since we use it to create our classes.
    Object = require "external/classic"
    require "entity"
    require "control"
    require "resources"
    require "characters/character"
    require "characters/player"
    require "characters/enemy"
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
    control = Control()
    resources = Resources()

    debug = true
    
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local spacePerPlayer = (resources.characterFrameWidth+2)*2
    local y = screenHeight - spacePerPlayer
    local livesCount = 3
    for i=1,livesCount do
        table.insert(lives, Player(((livesCount-i)*spacePerPlayer)+20,y))
    end

    player = lives[1]
    player:activate()
    
    local grid = HoverGrid(10,15)
    table.insert(enemies, A2Squadron(grid))
    table.insert(objects, grid)
        
end

function love.update(dt)
    for i,player in ipairs(lives) do
        player:update(dt)
    end
    for i,enemy in ipairs(enemies) do
        enemy:update(dt)
    end
    for i,object in ipairs(objects) do
        object:update(dt)
        if not object.active then
            table.remove(objects,i)
        end
    end
    for i,bullet in ipairs(playerBullets) do
        bullet:update(dt)
        if not bullet.active then
            table.remove(playerBullets,i)
        end
    end    
    control:update(dt)
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
                love.graphics.print("enemy " .. i .. " ->  x:" .. enemy.x .. " y:" .. enemy.y .. " w:" .. enemy.width .. " h: " .. enemy.height .. " cf: " .. enemy.currentFrame .. " s: " .. enemy.speed .. ' nf: ' ..#enemy.frames .. ' active:' .. (enemy.active and 'true' or 'false'), 10, (15*#lives+10)+(15*i+10))
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

    if debug then
        setDebugColor()
        love.graphics.print("player bullets: " .. (#playerBullets),10,485)
        love.graphics.print("enemy bullets: " .. (#enemyBullets),10,500)
        love.graphics.print("lives: " .. (#lives),10,515)
        love.graphics.print("enemies: " .. (#enemies),10,530)
    end
end

function setMainColor()
    love.graphics.setColor(1,1,1)
end

function setDebugColor()
    --love.graphics.setColor(1, 0, 0)
    love.graphics.setColor(163/255, 163/255, 155/255)
end
