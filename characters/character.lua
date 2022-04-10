Character = Entity:extend()

function Character:new( spriteRow, maxFrames, x, y )

    Character.super.new( self, x, y, 18, 18 )

    image = love.graphics.newImage("resources/sprites.png")
    local width = image:getWidth()
    local height = image:getHeight() 

    local aframes = {}
    local frame_width = 16
    local frame_height = 16
    local scale = 2
    for spriteColumn=0,maxFrames do
        table.insert(aframes, 
                love.graphics.newQuad(
                        1 + spriteColumn * (frame_width+2), 
                        1 + spriteRow * (frame_height+2),
                        frame_width, frame_height, 
                        width, height))
    end

    self.speed = 0
    self.frames = aframes
    self.currentFrame = 1
    self.isAlive = true

end

function Character:update(dt)
   
end

function Character:draw()
    if self.isAlive then
        love.graphics.draw(image, self.frames[self.currentFrame], self.x, self.y)
    end
end

function Character:keyPressed(key)
    
end