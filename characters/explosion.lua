Explosion = Entity:extend()

function Explosion:new( x, y )
    Explosion.super.new( self, x, y, resources.explosionWidth, resources.explosionHeight, resources.explosionScale, resources:getExplosionFrames() )  
    self.speed = 60
end

function Explosion:update(dt)
    if self.active then
        self.currentFrame = math.floor(self.currentFrame + self.speed * dt)
        if self.currentFrame > #self.frames then
            self.active = false
        end    
    end
end

