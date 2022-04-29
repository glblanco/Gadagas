function requireLibraries()
    -- First require classic, since we use it to create our classes.
    Object = require "external/classic"
    require "game"
    require "game-view"
    require "entity"
    require "pause"
    require "levels"
    require "events"
    require "information-boards"
    require "resources"  
    require "skins/resources-skin1"    
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

    control = Control()
    resources = ResourcesSkin1()
    uuidGenerator = UUIDGenerator()
    game = Game()
    
    debug = false
    
end

function love.update(dt)
    game:update(dt)
    control:update(dt)
end

function love.draw() 
    game:draw()
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

function raise( event )
    event:action( game )
end    
