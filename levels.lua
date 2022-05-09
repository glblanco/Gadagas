Level = Object:extend()
function Level:new( game, name, timeStep ) 
    self.game = game
    self.complete = false
    self.active = false
    self.name = name
    self.squadrons = {}
    self.currentSquadron = 0
    self.time = 0    
    self.timeStep = timeStep
end
function Level:activate()
    self.active = true
end
function Level:update( dt )
    if self.active then   
        if self.time == 0 then
            self.currentSquadron = self.currentSquadron + 1
            if self.currentSquadron <= #self.squadrons then
                local squad = self.squadrons[ self.currentSquadron ]
                self.game:addEnemy(squad)
            end
        end
        self.time = self.time + dt
        if self.time > self.timeStep or self:allActiveSquadronsAreDead() then
            self.time = 0
        end
        if self:allSquadronsAreDead() then
            self:markAsComplete()
            raise(LevelCompletedEvent(self))
        end
    end
end
function Level:markAsComplete()
    self.complete = true
    self.active = false
end
function Level:hasStarted()
    return self.active and not self.complete
end
function Level:allActiveSquadronsAreDead() 
    local ret = true
    for i=1,self.currentSquadron do
        if self.currentSquadron <= #self.squadrons then
            ret = ret and self.squadrons[self.currentSquadron]:isDead()
        end
    end
    return ret
end    
function Level:allSquadronsAreDead()
    local ret = true
    for i,squadron in ipairs(self.squadrons) do
        ret = ret and squadron:isDead()
    end
    return ret
end



DemoLevel = Level:extend()
function DemoLevel:new( game, name, timeStep ) 
    DemoLevel.super.new( self, game, name, timeStep )
end
function DemoLevel:activate()
    DemoLevel.super.activate(self)
    -- add the grid
    local grid = HoverGrid(10,15)
    self.game:addObject(grid)
    -- create a list of squadrons to be deployed every interval
    local trajectory1 = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    local squadron1 = A3Squadron(grid, trajectory1)
    table.insert(self.squadrons,squadron1)
    local trajectory2 = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    local squadron2 = A3Squadron(grid, trajectory2)
    table.insert(self.squadrons,squadron2)
end


ConfigurableLevel = Level:extend()
function ConfigurableLevel:new( game, name, config, timeStep ) 
    ConfigurableLevel.super.new( self, game, name, timeStep )
    self.config = config
end
function ConfigurableLevel:activate()
    ConfigurableLevel.super.activate(self)
    -- add the grid
    local grid = HoverGrid(10,15)
    self.game:addObject(grid)
    -- add squadrons to the level
    for i,squadConfig in ipairs(self.config) do
        local squadron = ConfigurableSquadron(squadConfig,grid)   
        table.insert(self.squadrons,squadron)
    end   
end


Level1 = ConfigurableLevel:extend()
function Level1:new( game, name, timeStep ) 
    -- create a list of squadrons 
    local trajectory1 = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    local mirroredTrajectory1 = mirrorVertically( trajectory1 )
    local trajectory2 = {0,600, 100,500, 200,450, 300,400, 400,350, 450,200, 450,100, 450,0}
    local mirroredTrajectory2 = mirrorVertically( trajectory2 )    
    local trajectory3 = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    local mirroredTrajectory3 = mirrorVertically( trajectory3 )        
    local pattern1 = {
            ["order"] = 1,
            ["speed"] = 120,
            ["trajectory"] = trajectory1,
            ["mirroredTrajectory"] = mirroredTrajectory1,
            ["squadron"] = {
                { enemyType = "blue",   startTime = 0.5,    path = "trajectory",         gridX = 2, gridY = 3  }, 
                { enemyType = "red",    startTime = 1,      path = "trajectory",         gridX = 2, gridY = 4  }, 
                { enemyType = "yellow", startTime = 1.5,    path = "trajectory",         gridX = 2, gridY = 5  }, 
                { enemyType = "yellow", startTime = 1.5,    path = "mirroredTrajectory", gridX = 2, gridY = 11 }, 
                { enemyType = "red",    startTime = 1,      path = "mirroredTrajectory", gridX = 2, gridY = 12 },
                { enemyType = "green",  startTime = 0.5,    path = "mirroredTrajectory", gridX = 2, gridY = 13 },
                { enemyType = "blue",   startTime = 2,      path = "trajectory",         gridX = 3, gridY = 3  }, 
                { enemyType = "red",    startTime = 2.5,    path = "trajectory",         gridX = 3, gridY = 4  }, 
                { enemyType = "yellow", startTime = 3,      path = "trajectory",         gridX = 3, gridY = 5  }, 
                { enemyType = "yellow", startTime = 3,      path = "mirroredTrajectory", gridX = 3, gridY = 11 }, 
                { enemyType = "red",    startTime = 2.5,    path = "mirroredTrajectory", gridX = 3, gridY = 12 }, 
                { enemyType = "green",  startTime = 2,      path = "mirroredTrajectory", gridX = 3, gridY = 13 }
            }
        }
    local pattern2 = {
            ["order"] = 2,
            ["speed"] = 130,
            ["trajectory2"] = trajectory2,
            ["mirroredTrajectory2"] = mirroredTrajectory2,
            ["squadron"] = {        
                { enemyType = "red",    startTime = 0.5,    path = "trajectory2",         gridX = 1, gridY = 2 }, 
                { enemyType = "red",    startTime = 1,      path = "trajectory2",         gridX = 1, gridY = 3 }, 
                { enemyType = "red",    startTime = 1.5,    path = "trajectory2",         gridX = 1, gridY = 4 }, 
                { enemyType = "yellow", startTime = 1.5,    path = "mirroredTrajectory2", gridX = 1, gridY = 12}, 
                { enemyType = "yellow", startTime = 1,      path = "mirroredTrajectory2", gridX = 1, gridY = 13}, 
                { enemyType = "yellow", startTime = 0.5,    path = "mirroredTrajectory2", gridX = 1, gridY = 14},
                { enemyType = "red",    startTime = 2,      path = "trajectory2",         gridX = 1, gridY = 5 }, 
                { enemyType = "red",    startTime = 2.5,    path = "trajectory2",         gridX = 1, gridY = 6 }, 
                { enemyType = "red",    startTime = 3,      path = "trajectory2",         gridX = 1, gridY = 7 }, 
                { enemyType = "yellow", startTime = 3,      path = "mirroredTrajectory2", gridX = 1, gridY = 9 }, 
                { enemyType = "yellow", startTime = 2.5,    path = "mirroredTrajectory2", gridX = 1, gridY = 10}, 
                { enemyType = "yellow", startTime = 2,      path = "mirroredTrajectory2", gridX = 1, gridY = 11}
            }
        }            
    local pattern3 = {
            ["order"] = 3,
            ["speed"] = 140,
            ["trajectory3"] = trajectory3,
            ["mirroredTrajectory3"] = mirroredTrajectory3,
            ["squadron"] = {               
                { enemyType = "blue",    startTime = 0.5,   path = "trajectory3",         gridX = 4, gridY = 4 }, 
                { enemyType = "blue",    startTime = 1,     path = "trajectory3",         gridX = 4, gridY = 5 }, 
                { enemyType = "blue",    startTime = 1.5,   path = "trajectory3",         gridX = 4, gridY = 6 },
                { enemyType = "green",   startTime = 1.5,   path = "mirroredTrajectory3", gridX = 4, gridY = 10}, 
                { enemyType = "green",   startTime = 1,     path = "mirroredTrajectory3", gridX = 4, gridY = 11}, 
                { enemyType = "green",   startTime = 0.5,   path = "mirroredTrajectory3", gridX = 4, gridY = 12},
                { enemyType = "blue",    startTime = 2,     path = "trajectory3",         gridX = 5, gridY = 4 }, 
                { enemyType = "blue",    startTime = 2.5,   path = "trajectory3",         gridX = 5, gridY = 5 }, 
                { enemyType = "blue",    startTime = 3,     path = "trajectory3",         gridX = 5, gridY = 6 },
                { enemyType = "green",   startTime = 3,     path = "mirroredTrajectory3", gridX = 5, gridY = 10}, 
                { enemyType = "green",   startTime = 2.5,   path = "mirroredTrajectory3", gridX = 5, gridY = 11}, 
                { enemyType = "green",   startTime = 2,     path = "mirroredTrajectory3", gridX = 5, gridY = 12}
            }
        }
    local patterns = {}
    table.insert(patterns,pattern1)
    table.insert(patterns,pattern2)
    table.insert(patterns,pattern3)

    Level1.super.new( self, game, name, patterns, timeStep )
end

JsonLevel = ConfigurableLevel:extend()
function JsonLevel:new( game, name, file, timeStep ) 
    JsonLevel.super.new( self, game, name, nil, timeStep )
    self.file = file
end
function JsonLevel:activate()
    -- add the grid
    local grid = HoverGrid(10,15)
    self.game:addObject(grid)
    self.config = self:readConfigFromFile()
    JsonLevel.super.activate(self)    
end
function JsonLevel:readConfigFromFile()
    -- read json from file
    local jsonStr = love.filesystem.read(self.file)
    -- transform the json into a table with the configurations
    local aconfig = DKJson.decode(jsonStr)
    return aconfig
end


