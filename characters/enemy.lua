Enemy = Character:extend()

function Enemy:new( spriteInfo, x, y, speed, flightPlan, attackPlan )
    Enemy.super.new( self, spriteInfo, x, y )
    self.speed = speed
    self.flightPlan = flightPlan
    self.attackPlan = attackPlan
    self.hoverTime = 0
    self.laps = 0
    self.dt = 0
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    if self.active then 
        if self.flightPlan then
            self.flightPlan:update(self, dt)
        end
        if self.attackPlan then
            self.attackPlan:update(self, dt)
        end        
        self:checkForImpacts()
    end 
end

function Enemy:checkForImpacts()
    for i,bullet in ipairs(game.playerBullets) do
        if bullet:collides(self) then
            bullet:hit(self)
            break
        end
    end    
end

function Enemy:rotateThroughFrames(dt)
    self.currentFrame = math.floor(self.currentFrame + self.speed * dt)
    if self.currentFrame > #self.frames then
        self.currentFrame = 1
    end    
end

function findIndexOf( item, array )
    local ret = 0
    for i=1,#array do
        if array[i] == item then
            ret = i
            break
        end
    end
    return ret
end

function nextFrame( currentIndex, frames )
    local nextIndex = currentIndex + 1
    if nextIndex > #frames then
        nextIndex = 1
    end
    return nextIndex
end    

function Enemy:updateHoverMode(dt)
    if self.active then 
        self.orientation = 0
        local hoverFrames = resources:getHoverFramesIds( self )
        local currentIndex = findIndexOf(self.currentFrame,hoverFrames)
        self.hoverTime = self.hoverTime + dt
        self.dt = dt
        if currentIndex == 0 then
            self.currentFrame = hoverFrames[1]
        end
        if self.hoverTime>4*dt then
            self.currentFrame = hoverFrames[nextFrame(currentIndex,hoverFrames)]
            self.hoverTime = 0
            self.laps = self.laps + 1
        end      
    end                   
end

function Enemy:attack()
    local bullet = Bullet(self.x,self.y,"down")
    raise(EnemyShotBulletEvent(bullet))
end 

function Enemy:draw()
    Enemy.super.draw(self)
    if self.visible then
        if self.flightPlan then
            if debugMode then
                self.flightPlan:drawDebugData(self)
            end
        end
    end
end

function Enemy:isSquadron()
    return false
end

function Enemy:getActiveEnemies()
    local enemies = {}
    if self.active then
        table.insert( enemies, self )
    end
    return enemies
end    

function Enemy:die( byBullet )
    self.active = false
    self.visible = false
    self:explode()
    if byBullet then
        raise( EnemyKilledEvent(self) )
    end
end

function Enemy:explode()
    local explosion = EnemyExplosion(self.x,self.y)
    raise( ExplosionEvent(explosion) )
end

function Enemy:isDead()
    return not self.active
end

-------

GreenEnemy = Enemy:extend()
function GreenEnemy:new( x, y, speed, flightPlan )
    local info = resources:greenEnemySpriteInfo()
    GreenEnemy.super.new( self, info, x, y, speed, flightPlan )
end

BlueEnemy = Enemy:extend()
function BlueEnemy:new( x, y, speed, flightPlan )
    local info = resources:blueEnemySpriteInfo()
    BlueEnemy.super.new( self, info, x, y, speed, flightPlan )
end

RedEnemy = Enemy:extend()
function RedEnemy:new( x, y, speed, flightPlan )
    local info = resources:redEnemySpriteInfo()
    RedEnemy.super.new( self, info, x, y, speed, flightPlan )
end

YellowEnemy = Enemy:extend()
function YellowEnemy:new( x, y, speed, flightPlan )
    local info = resources:yellowEnemySpriteInfo()
    YellowEnemy.super.new( self, info, x, y, speed, flightPlan )
end
