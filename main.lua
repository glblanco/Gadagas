function requireLibraries()
    -- First require classic, since we use it to create our classes.
    Object    = require "external/classic"
    Starfield = require "external/starfield"    
    DKJson    = require "external/dkjson" 
    --Lynput    = require "external/lynput"    
    require "utils/control"     
    require "utils/simple-control"    
    require "utils/uuid-generator"   
    require "utils/sound-fx"        
    require "game"
    require "game-view"
    require "game-stats"    
    require "entity"
    require "pause"
    require "levels"
    require "events"
    require "information-boards"
    require "resources"  
    require "starfield"  
    require "highscores/highscore-manager"  
    require "highscores/highscore-form"  
    require "skins/skin1"    
    require "skins/skin2"    
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

    control = SimpleControl()

    resources = ResourcesSkin2()
    uuidGenerator = UUIDGenerator()
    game = Game()
    
    highscoreManager = HighScoreManager()
    highscoreForm = nil

    loadStarfield()
    
    debugMode = false
    activeScreen = "GAME"
end

function love.update(dt)
    
    if activeScreen == "GAME" then
        game:update(dt)
        if game.started and game:isOver() and not game:isPaused() then
            highscoreForm = HighScoreForm(game.stats)
            activeScreen = "HIGHSCORE"
        end
    end
    
    if activeScreen == "HIGHSCORE" then
        highscoreForm:update(dt)
        if highscoreForm:shouldStopDisplay() then
            game = Game()
            activeScreen = "GAME"
        end
    end
    
    updateStarfield(dt)
    control:update(dt)
end

function love.draw() 
    drawStarfield()

    if activeScreen == "GAME" then
        game:draw()
    elseif activeScreen == "HIGHSCORE" then
        highscoreForm:draw()
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

function raise( event )
    event:action( game )
end    

