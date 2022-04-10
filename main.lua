function love.load()
    
    -- First require classic, since we use it to create our classes.
    Object = require "classic"
    require "entity"
    require "characters/character"
    require "characters/player"
    require "characters/enemy"
    
    lives = {}
    enemies = {}
    
    local y = love.graphics.getHeight() - 36
    for i=0,2 do
        table.insert(lives, Player(i*20,y))
    end
    lives[1].activate(lives[1])

    table.insert(enemies, GreenEnemy(100,200))
    table.insert(enemies, RedEnemy(200,200))
    table.insert(enemies, BlueEnemy(300,200))
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
    end
    for i,enemy in ipairs(enemies) do
        enemy:draw()
    end
end

function love.keypressed(key)
    for i,player in ipairs(lives) do
        --player:keypressed(key)
    end
end