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
    debug = false
    
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
    --local trajectory = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    --table.insert(enemies, BlueEnemy(0,400,100, BezierAndHoverCompositeFlightPlan(trajectory,true,200,200,0)))
    --table.insert(enemies, YellowEnemy(0,400,100, BezierAndHoverCompositeFlightPlan(trajectory,false,200,200,0)))
    table.insert(enemies, A1Squadron())
    
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