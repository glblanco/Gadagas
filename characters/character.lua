Character = Entity:extend()

function Character:new( spriteRow, maxFrames, x, y, column )

    self.scale = 2
    local frame_width = 16
    local frame_height = 16

    Character.super.new( self, x, y, 16*self.scale, 16*self.scale )

    image = love.graphics.newImage("resources/sprites.png")
    local width = image:getWidth()
    local height = image:getHeight() 

    local aframes = {}
    for spriteColumn=0,maxFrames do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (column * 18 * 8) + 1 + spriteColumn * (frame_width+2), 
                        1 + spriteRow * (frame_height+2),
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
    self.currentFrame = #self.frames - 1
end

function Character:lookDown()
    self.currentFrame = #self.frames - 1
    self.orientation = math.rad(180)
end

function Character:lookRight()
    self.currentFrame = 1
    self.orientation = math.rad(180)
end

function Character:lookLeft()
    self.currentFrame = 1
end

function Character:update(dt)
   
end

function Character:drawableX()
    ret = self.x
    if self.orientation == math.rad(180) then 
        ret = self.x + self.width 
    end
    return ret
end

function Character:drawableY()
    ret = self.y
    if self.orientation == math.rad(180) then 
        ret = self.y + self.height 
    end
    return ret
end

function Character:draw()
    if self.isAlive then
        love.graphics.draw(image, self.frames[self.currentFrame], 
                self.drawableX(self), 
                self.drawableY(self), 
                self.orientation, 
                self.scale, 
                self.scale )
    end
end

function Character:keyPressed(key)
    
end