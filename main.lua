function love.load()
    
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
    require "characters/squadron"

    lives = {}
    enemies = {}
    debug = true
    
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local spacePerPlayer = 18*2
    local y = screenHeight - spacePerPlayer
    local livesCount = 3
    for i=1,livesCount do
        table.insert(lives, Player(((livesCount-i)*spacePerPlayer)+20,y))
    end
    lives[1].activate(lives[1])

    --table.insert(enemies, TwinSquadron())
    --table.insert(enemies, DownwardYellowSquadron())
    --table.insert(enemies, SampleBezierGreenSquadron())
    --table.insert(enemies, BlueEnemy(200,200,40, CircularFlightPlan(300,300,100,"counterclockwise")))
    --table.insert(enemies, RedEnemy(0,400,120, Demo1CompositeFlightPlan()))
    table.insert(enemies, BlueEnemy(0,400,100, Demo2CompositeFlightPlan(true)))
    --table.insert(enemies, YellowEnemy(500,100,20, HorizontalHoverFlightPlan(500,100)))
    --table.insert(enemies, RedEnemy(500,200,80, HorizontalHoverFlightPlan(500,100)))
    --table.insert(enemies, GreenEnemy(30,30,50, GoToCoordinateFlightPlan(30,30,600,500)))
end

function love.update(dt)
    for i,player in ipairs(lives) do
        player:update(dt)
    end
    for i,enemy in ipairs(enemies) do
        enemy:update(dt)
    end
end

function love.draw() 
    local PI = 3.14159265358
    for i,player in ipairs(lives) do
        setWhiteColor()
        player:draw()
        if debug then
            setDebugColor()
            love.graphics.print("player " .. i .. " ->  x:" .. player.x .. " y:" .. player.y .. " w:" .. player.width .. " h: " .. player.height .. " r:" .. math.floor(player.orientation * 180 / PI), 10, 15*i + 10)
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
end

function setWhiteColor()
    love.graphics.setColor(1,1,1)
end

function setDebugColor()
    --love.graphics.setColor(1, 0, 0)
    love.graphics.setColor(163/255, 163/255, 155/255)
end

function love.keypressed(key)
    for i,player in ipairs(lives) do
        --player:notify...
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    for i,player in ipairs(lives) do
        --player:notify...
    end
end