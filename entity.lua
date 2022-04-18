Entity = Object:extend()

function Entity:new(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.active = true
    self.orientation = 0
    -- subclasses should fill in the below if the draw method is to be used as is
    self.frames = nil 
    self.scale = 1
end

function Entity:update(dt)
    -- subclasses should implement
end

function Entity:draw()
    if self.active then
        setMainColor()
        love.graphics.draw(resources.image, self.frames[self.currentFrame], 
                self:drawableX(), 
                self:drawableY(), 
                self:drawableOrientation(), 
                self.scale, 
                self.scale,
                self.width/(2*self.scale),
                self.height/(2*self.scale)) 
        if debug then
            -- draw boundign box
            setDebugColor()
            love.graphics.rectangle( "line", self.x - self.width/2, self.y - self.height/2, self.width, self.height )
        end        
    end
end

function Entity:drawableX()
    return self.x
end

function Entity:drawableY()
    return self.y
end

function Entity:drawableOrientation()
    return self.orientation 
end

function Entity:collides(target) 
    return  target.x - target.width/2 <= self.x + self.width/2
                and self.x - self.width/2 <= target.x + target.width/2
            and target.y - target.height/2 <= self.y + self.height/2
                and self.y - self.height/2 <= target.y + target.height/2
end