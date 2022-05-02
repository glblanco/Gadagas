Level = Object:extend()
function Level:new( game, name ) 
    self.game = game
    self.complete = false
    self.active = false
    self.name = name
    self.squadrons = {}
    self.currentSquadron = 0
    self.time = 0    
end
function Level:activate()
    self.active = true
end
function Level:update( dt )
    local timeStep = 15 -- seconds
    if self.active then   
        if self.time == 0 then
            self.currentSquadron = self.currentSquadron + 1
            if self.currentSquadron <= #self.squadrons then
                local squad = self.squadrons[ self.currentSquadron ]
                self.game:addEnemy(squad)
            end
        end
        self.time = self.time + dt
        if self.time > timeStep or self:allActiveSquadronsAreDead() then
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



Level1 = Level:extend()
function Level1:new( game, name ) 
    Level1.super.new( self, game, name )
end
function Level1:activate()
    Level1.super.activate(self)
    
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

    local trajectory3 = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    local squadron3 = A3Squadron(grid, trajectory3)
    table.insert(self.squadrons,squadron3)
end
