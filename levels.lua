Level = Object:extend()
function Level:new( name ) 
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
function Level1:new() 
    Level1.super:new("Level 1")
end
function Level1:activate()
    Level1.super:activate()
    local grid = HoverGrid(10,15)
    self.squadron = A3Squadron(grid)
    table.insert(game.enemies, self.squadron)
    table.insert(game.objects, grid)
end
function Level1:update( dt )
    Level1.super:update(dt)
    if self:hasStarted() and self.squadron and self.squadron:isDead() then
        self:markAsComplete()
        game:levelComplete()
    end
end


