function love.load()
    
    -- First require classic, since we use it to create our classes.
    Object = require "external/classic"
    require "external/entity"
    require "characters/character"
    require "characters/player"
    require "characters/enemy"
    require "characters/flight-plan"
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

    table.insert(enemies, TwinSquadron())
    --table.insert(enemies, DownwardYellowSquadron())
    --table.insert(enemies, SampleBezierGreenSquadron())

    curve = love.math.newBezierCurve({25,425, 25,525, 75,425, 125,525, 300,400, 400,450, 500,0, 550,30, 600,400, 700,200})
    flightPlan = BezierFlightPlan(curve,0)
    table.insert(enemies, GreenEnemy(0,0,40, flightPlan))
    table.insert(enemies, GreenEnemy(200,200,40, CircularFlightPlan(300,300,100)))
    
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
    love.graphics.setColor(255,255,255,255)
    for i,player in ipairs(lives) do
        player:draw()
        if debug then
            love.graphics.print("player " .. i .. " ->  x:" .. player.x .. " y:" .. player.y .. " w:" .. player.width .. " h: " .. player.height .. " r:" .. math.floor(player.orientation * 180 / PI), 10, 15*i + 10)
        end    
    end
    for i,enemy in ipairs(enemies) do
        enemy:draw()
        if debug then
            if not enemy:isSquadron() then
                love.graphics.print("enemy " .. i .. " ->  x:" .. enemy.x .. " y:" .. enemy.y .. " w:" .. enemy.width .. " h: " .. enemy.height .. " cf: " .. enemy.currentFrame .. " s:" .. enemy.speed, 10, (15*#lives+10)+(15*i+10))
            end
        end
    end

    if debug then
        love.graphics.setColor(255/255, 200/255, 40/255, 127/255)
        love.graphics.line(curve:render())
        love.graphics.circle( "line", 300, 300, 100 )
        local character = lives[1]
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        local x1 = screenWidth/2 - 3*character.width
        local x2 = screenWidth/2 - character.width
        local x3 = screenWidth/2 
        local x4 = screenWidth/2 + character.width
        local x5 = screenWidth/2 + 3*character.width
        love.graphics.line( x1, 0, x1, screenHeight )
        love.graphics.line( x2, 0, x2, screenHeight )
        love.graphics.line( x3, 0, x3, screenHeight )
        love.graphics.line( x4, 0, x4, screenHeight )
        love.graphics.line( x5, 0, x5, screenHeight )
    end
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