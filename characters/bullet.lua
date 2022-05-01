Bullet = Entity:extend()

function Bullet:new( x, y, direction )

    Bullet.super.new( self, x, y, resources.bulletWidth, resources.bulletHeight, 
                    resources.bulletScale, resources:getBulletFrames() )

    self.speed = 350
    self.direction = direction
    
    self.currentFrame = resources:getBulletFrameLookingUp()
    if self.direction == "up" then
        self.orientation = 0
    else
        self.orientation = math.rad(180)
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
    self.visible = false
end 

function Bullet:hit(target)
    if self.active and target.active then
        self.die(self)
        target.die(target)
    end
end