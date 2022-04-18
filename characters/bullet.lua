Bullet = Entity:extend()

function Bullet:new( x, y, direction )

    Bullet.super.new( self, x, y, resources.bulletWidth, resources.bulletHeight )

    self.frames = resources:getBulletFrames()
    self.speed = 350
    self.direction = direction
    self.active = true
    self.orientation = 0
    self.scale = resources.bulletScale

    if self.direction == "up" then
        self.currentFrame = 2
    else
        self.currentFrame = 8
    end

end

function Bullet:update(dt)
    if self.active then
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

function Bullet:die()
    self.active = false
end 

function Bullet:impacts(target) 
    return  target.x - target.width/2 <= self.x + self.width/2
                and self.x - self.width/2 <= target.x + target.width/2
            and target.y - target.height/2 <= self.y + self.height/2
                and self.y - self.height/2 <= target.y + target.height/2
end

function Bullet:hit(target)
    if self.active and target.active then
        self.die(self)
        target.die(target)
    end
end