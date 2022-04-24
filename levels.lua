Level = Object:extend()

function Level:new()
    self.complete = false
    self.active = false
    self.squadron = nil
end

function Level:activate()
    local grid = HoverGrid(10,15)
    self.squadron = A3Squadron(grid)
    table.insert(game.enemies, self.squadron)
    table.insert(game.objects, grid)
    self.active = true
end

function Level:update( dt )
    if self.squadron and self.squadron:isDead() and not self.complete then
        self:markAsComplete()
        game:levelComplete()
    end
end

function Level:markAsComplete()
    self.complete = true
    self.active = false
end

