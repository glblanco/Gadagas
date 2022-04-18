Explosion = Entity:extend()

function Explosion:new( x, y )
    Explosion.super.new( self, x, y, resources.explosionWidth, resources.explosionHeight )  
    self.frames = resources:getExplosionFrames()
    self.scale = resources.explosionScale
    self.speed = 60
    self.currentFrame = 1
    self.active = true
end

function Explosion:update(dt)
    if self.active then
        self.currentFrame = math.floor(self.currentFrame + self.speed * dt)
        if self.currentFrame > #self.frames then
            self.active = false
        end    
    end
end

