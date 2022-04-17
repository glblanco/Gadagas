function requireLibraries()
    -- First require classic, since we use it to create our classes.
    Object = require "external/classic"
    require "external/entity"
    require "characters/character"
    require "characters/player"
    require "characters/enemy"
    require "characters/flight-plan"
    require "characters/flight-plans/demos"
    require "characters/flight-plans/simple-paths"
    require "characters/flight-plans/composite-plans"        
    require "characters/flight-plans/snap-to-grid"        
    require "characters/squadron"
    require "control"
end 

function love.load()
    
    requireLibraries()
    
    lives = {}
    enemies = {}
    objects = {}
    input = Control()

    debug = true
    
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local spacePerPlayer = 18*2
    local y = screenHeight - spacePerPlayer
    local livesCount = 3
    for i=1,livesCount do
        table.insert(lives, Player(((livesCount-i)*spacePerPlayer)+20,y))
    end

    player = lives[1]
    player.activate(player)
    
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
    end
    input.update(dt)
end

function love.draw() 
    local PI = 3.14159265358
    for i,player in ipairs(lives) do
        setWhiteColor()
        player:draw()
        if debug then
            setDebugColor()
            love.graphics.print("player " .. i .. " ->  x:" .. player.x .. " y:" .. player.y .. " w:" .. player.width .. " h: " .. player.height .. " r:" .. math.floor(player.orientation * 180 / PI) .. ' shoot: ' .. (player.shoot and "true" or "false")  , 10, 15*i + 10)
        end    
    end
    for i,enemy in ipairs(enemies) do
        setWhiteColor()
        enemy:draw()
        if debug then
            setDebugColor()
            if not enemy:isSquadron() then
                love.graphics.print("enemy " .. i .. " ->  x:" .. enemy.x .. " y:" .. enemy.y .. " w:" .. enemy.width .. " h: " .. enemy.height .. " cf: " .. enemy.currentFrame .. " s: " .. enemy.speed .. ' nf: ' ..#enemy.frames, 10, (15*#lives+10)+(15*i+10))
            end
        end
    end
    for i,object in ipairs(objects) do
        setWhiteColor()
        object:draw()
    end
end

function setWhiteColor()
    love.graphics.setColor(1,1,1)
end

function setDebugColor()
    --love.graphics.setColor(1, 0, 0)
    love.graphics.setColor(163/255, 163/255, 155/255)
end
