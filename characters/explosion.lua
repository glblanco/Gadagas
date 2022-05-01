Explosion = Entity:extend()

function Explosion:new( x, y, dimensions, frames )
    Explosion.super.new( self, x, y, dimensions, frames )  
    self.currentFrame = 1  
    self.speed = 59
end

function Explosion:update(dt)
    if self.active then
        self.currentFrame = math.floor(self.currentFrame + self.speed * dt)
        if self.currentFrame >= #self.frames then
            self.active = false
            self.visible = false
        end    
    end
end

---

EnemyExplosion = Explosion:extend()
function EnemyExplosion:new( x, y )
    EnemyExplosion.super.new( self, x, y, 
            resources:getExplosionDimensions(), 
            resources:getEnemyExplosionFrames() )  
end

PlayerExplosion = Explosion:extend()
function PlayerExplosion:new( x, y )
    PlayerExplosion.super.new( self, x, y, 
            resources:getExplosionDimensions(), 
            resources:getPlayerExplosionFrames() )  
end