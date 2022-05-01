Level = Object:extend()
function Level:new( game, name ) 
    self.game = game
    self.complete = false
    self.active = false
    self.squadron = nil
    self.name = name
end
function Level:activate()
    self.active = true
end
function Level:update( dt )
    -- To be implemented by subclasses
end
function Level:markAsComplete()
    self.complete = true
    self.active = false
end
function Level:hasStarted()
    return self.active and not self.complete
end


Level1 = Level:extend()
function Level1:new( game, name ) 
    Level1.super.new( self, game, name )
end
function Level1:activate()
    Level1.super.activate(self)
    local grid = HoverGrid(10,15)
    local trajectory = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    self.squadron = A3Squadron(grid, trajectory)
    self.game:addEnemy(self.squadron)
    self.game:addObject(grid)
end
function Level1:update( dt )
    Level1.super.update(self,dt)
    if self.active and self.squadron and self.squadron:isDead() then
        self:markAsComplete()
        raise(LevelCompletedEvent(self))
    end
end


