function love.load()
    
    -- First require classic, since we use it to create our classes.
    Object = require "classic"
    require "entity"
    require "characters/character"
    require "characters/player"
    require "characters/enemy"
    
    lives = {}
    enemies = {}
    debug = true
    
    local spacePerPlayer = 18*2
    local y = love.graphics.getHeight() - spacePerPlayer
    for i=1,3 do
        table.insert(lives, Player(((3-i)*spacePerPlayer)+20,y))
    end
    lives[1].activate(lives[1])

    table.insert(enemies, GreenEnemy(100,200))
    table.insert(enemies, RedEnemy(200,200))
    table.insert(enemies, BlueEnemy(300,200))
    table.insert(enemies, YellowEnemy(400,200))   
    
    enemies[1].lookUp(enemies[1])
    enemies[2].lookRight(enemies[2])
    enemies[3].lookDown(enemies[3])
    enemies[4].lookLeft(enemies[4])
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
    for i,player in ipairs(lives) do
        player:draw()
        if debug then
            love.graphics.print("player " .. i .. " ->  x:" .. player.x .. " y:" .. player.y .. " w:" .. player.width .. " h: " .. player.height , 10, 15*i + 10)
        end    
    end
    for i,enemy in ipairs(enemies) do
        enemy:draw()
        if debug then
            love.graphics.print("enemy " .. i .. " ->  x:" .. enemy.x .. " y:" .. enemy.y .. " w:" .. enemy.width .. " h: " .. enemy.height , 10, (15*#lives+10)+(15*i+10))
        end
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