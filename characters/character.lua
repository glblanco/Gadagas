SpriteInfo = Object:extend()
function SpriteInfo:new( row, maxFrames, column )
    self.column = column        -- is the character in the first or second set?
    self.row = row              -- which is the line the character occupies in the sprite - starting at 0
    self.maxFrames = maxFrames  -- number of images available for the character
end


Character = Entity:extend()

function Character:new( spriteInfo, x, y )

    self.scale = 2
    local frame_width = 16
    local frame_height = 16

    Character.super.new( self, x, y, frame_width*self.scale, frame_width*self.scale )

    image = love.graphics.newImage("resources/sprites.png")
    local width = image:getWidth()
    local height = image:getHeight() 

    local aframes = {}
    for spriteColumn=0,spriteInfo.maxFrames do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (spriteInfo.column * 18 * 8) + 1 + spriteColumn * (frame_width+2), 
                        1 + spriteInfo.row * (frame_height+2),
                        frame_width, frame_height, 
                        width, height))
    end

    self.speed = 0
    self.frames = aframes
    self.currentFrame = 1
    self.isAlive = true
    self.orientation = 0

end

function Character:lookUp()
    self.currentFrame = 1
    self.orientation = math.atan2(-1, 0)
end

function Character:lookDown()
    self.currentFrame = 1
    self.orientation = math.atan2(1, 0)
end

function Character:lookRight()
    self.currentFrame = 1
    self.orientation = math.atan2(0, 1)
end

function Character:lookLeft()
    self.currentFrame = 1
    self.orientation = math.atan2(0, -1)
end

function Character:update(dt)
   
end

function Character:drawableX()
    return self.x
end

function Character:drawableY()
    return self.y
end

function Character:drawableOrientation()
    -- images are looking right, not left
    return self.orientation + math.rad(180)
end

function Character:draw()
    if self.isAlive then
        love.graphics.draw(image, self.frames[self.currentFrame], 
                self.drawableX(self), 
                self.drawableY(self), 
                self.drawableOrientation(self), 
                self.scale, 
                self.scale,
                self.width/(2*self.scale),
                self.height/(2*self.scale)) 
    end

    if debug then
        love.graphics.rectangle( "line", self.x - self.width/2, self.y - self.height/2, self.width, self.height )
    end
end
