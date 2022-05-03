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
        local squadron = ConfigurableSquadron(squadConfig,grid,120)   
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
            {"blue",0.5,trajectory1,2,3}, 
            {"red",1,trajectory1,2,4}, 
            {"yellow",1.5,trajectory1,2,5}, 
            {"yellow",1.5,mirroredTrajectory1,2,11}, 
            {"red",1,mirroredTrajectory1,2,12},
            {"green",0.5,mirroredTrajectory1,2,13},
            {"blue",2,trajectory1,3,3}, 
            {"red",2.5,trajectory1,3,4}, 
            {"yellow",3,trajectory1,3,5}, 
            {"yellow",3,mirroredTrajectory1,3,11}, 
            {"red",2.5,mirroredTrajectory1,3,12}, 
            {"green",2,mirroredTrajectory1,3,13}
        }
    local pattern2 = {
            {"red",0.5,trajectory2,1,2}, 
            {"red",1,trajectory2,1,3}, 
            {"red",1.5,trajectory2,1,4}, 
            {"yellow",1.5,mirroredTrajectory2,1,12}, 
            {"yellow",1,mirroredTrajectory2,1,13}, 
            {"yellow",0.5,mirroredTrajectory2,1,14},
            {"red",2,trajectory2,1,5}, 
            {"red",2.5,trajectory2,1,6}, 
            {"red",3,trajectory2,1,7}, 
            {"yellow",3,mirroredTrajectory2,1,9}, 
            {"yellow",2.5,mirroredTrajectory2,1,10}, 
            {"yellow",2,mirroredTrajectory2,1,11}
        }            
    local pattern3 = {
            {"blue",0.5,trajectory3,4,4}, 
            {"blue",1,trajectory3,4,5}, 
            {"blue",1.5,trajectory3,4,6},
            {"green",1.5,mirroredTrajectory3,4,10}, 
            {"green",1,mirroredTrajectory3,4,11}, 
            {"green",0.5,mirroredTrajectory3,4,12},
            {"blue",2,trajectory3,5,4}, 
            {"blue",2.5,trajectory3,5,5}, 
            {"blue",3,trajectory3,5,6},
            {"green",3,mirroredTrajectory3,5,10}, 
            {"green",2.5,mirroredTrajectory3,5,11}, 
            {"green",2,mirroredTrajectory3,5,12}
        }
    local patterns = {}
    table.insert(patterns,pattern1)
    table.insert(patterns,pattern2)
    table.insert(patterns,pattern3)
    Level1.super.new( self, game, name, patterns, timeStep )
end

