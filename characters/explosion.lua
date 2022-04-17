Explosion = Entity:extend()

function Explosion:new( x, y )

    self.scale = 2
    local frame_width = 32
    local frame_height = 32

    Explosion.super.new( self, x, y, frame_width*self.scale, frame_width*self.scale )
    image = love.graphics.newImage("resources/sprites.png")
    local width = image:getWidth()
    local height = image:getHeight() 

    local aframes = {}
    for spriteColumn=1,5 do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (2 * 18 * 8) + 1 + (spriteColumn-1) * (frame_width+2), 
                        1 ,
                        frame_width, frame_height, 
                        width, height))
    end

    self.speed = 60
    self.frames = aframes
    self.currentFrame = 1
    self.isAlive = true
end

function Explosion:update(dt)
    if self.isAlive then
        self.currentFrame = math.floor(self.currentFrame + self.speed * dt)
        if self.currentFrame > #self.frames then
            self.isAlive = false
        end    
    end
end

function Explosion:draw()
    if self.isAlive then
        setMainColor()
        love.graphics.draw(image, self.frames[self.currentFrame], 
                self.x, 
                self.y, 
                0, 
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
