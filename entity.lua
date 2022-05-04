Entity = Object:extend()

function Entity:new(x, y, dimensions, frames)
    self.x = x
    self.y = y
    self.width  = dimensions.width
    self.height = dimensions.height
    self.scale  = dimensions.scale
    self.active  = true      -- determines whether the entity should receive updates
    self.visible = true     -- determines whether the entity should be drawn
    self.orientation = 0
    self.frames = frames 
    self.currentFrame = 1
    self.uuid = uuidGenerator.next()
end

function Entity:update(dt)
    -- subclasses should implement
end

function Entity:draw()
    if self.visible then
        setMainColor()
        love.graphics.draw(resources:getSpriteImage(), self.frames[self.currentFrame], 
                self.x,
                self.y,
                self.orientation,
                self.scale, 
                self.scale,
                self.width/(2*self.scale),
                self.height/(2*self.scale)) 
        if debugMode then
            -- draw bounding box
            setDebugColor()
            love.graphics.rectangle( "line", self.x - self.width/2, self.y - self.height/2, self.width, self.height )
        end        
    end
end

function Entity:equals( entity )
    return entity and self.uuid == entity.uuid
end 

function Entity:collides(target) 
    return  target.x - target.width/2 <= self.x + self.width/2
                and self.x - self.width/2 <= target.x + target.width/2
            and target.y - target.height/2 <= self.y + self.height/2
                and self.y - self.height/2 <= target.y + target.height/2
end