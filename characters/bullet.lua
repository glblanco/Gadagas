Bullet = Entity:extend()

function Bullet:new( x, y, direction )
    
    self.scale = 2
    local frame_width = 16
    local frame_height = 16    
    
    Bullet.super.new( self, x, y, frame_width*self.scale, frame_width*self.scale )

    image = love.graphics.newImage("resources/sprites.png")
    local width = image:getWidth()
    local height = image:getHeight() 

    local aframes = {}
    for spriteRow=1,3 do
        for spriteColumn=1,3 do
            table.insert(aframes, 
                love.graphics.newQuad(
                        (2 * 18 * 8) + 1 + (spriteColumn-1) * (frame_width+2), 
                        (6.5*(frame_height+2)+1) + (spriteRow-1) * (frame_height+2),
                        frame_width, frame_height, 
                        width, height))
        end
    end

    self.frames = aframes
    self.speed = 350
    self.direction = direction
    self.isAlive = true
    self.orientation = 0

    if self.direction == "up" then
        self.currentFrame = 2
    else
        self.currentFrame = 8
    end

end

function Bullet:update(dt)
    if self.isAlive then
        if self.direction == "up" then
            self.y = self.y - self.speed * dt
        else
            self.y = self.y + self.speed * dt
        end
    end 
    --If the bullet is out of the screen
    if (self.y < -self.height/2) or (self.y > ( love.graphics.getHeight() + self.height/2 )) then
        self.die(self)
    end
end

function Bullet:draw()
    if self.isAlive then
        setMainColor()
        love.graphics.draw(image, self.frames[self.currentFrame], 
                self.x, 
                self.y, 
                self.orientation, 
                self.scale, 
                self.scale,
                self.width/(2*self.scale),
                self.height/(2*self.scale)) 
        if debug then
            setDebugColor()
            love.graphics.rectangle( "line", self.x - self.width/2, self.y - self.height/2, self.width, self.height )
        end        
    end
end

function Bullet:die()
    self.isAlive = false
end 

function Bullet:impacts(target) 
    return  target.x - target.width/2 <= self.x + self.width/2
                and self.x - self.width/2 <= target.x + target.width/2
            and target.y - target.height/2 <= self.y + self.height/2
                and self.y - self.height/2 <= target.y + target.height/2
end

function Bullet:hit(target)
    if self.isAlive and target.isAlive then
        self.die(self)
        target.die(target)
    end
end