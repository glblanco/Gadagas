Enemy = Character:extend()

function Enemy:new( spriteInfo, x, y, speed, flightPlan, attackPlan )
    Enemy.super.new( self, spriteInfo, x, y )
    self.speed = speed
    self.flightPlan = flightPlan
    self.attackPlan = attackPlan
    self.hoverTime = 0
    self.laps = 0
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

function Enemy:updateHoverMode(dt)
    if self.active then 
        self.orientation = math.atan2(0, -1)
        if #self.frames == 9 then
            self.hoverTime = self.hoverTime + dt
            if self.hoverTime>3*dt then
                if self.currentFrame <= 7 then
                    self.currentFrame = 8
                else 
                    self.currentFrame = 7
                end    
                self.hoverTime = 0
                self.laps = self.laps + 1
            elseif self.currentFrame < 7 then
                self.currentFrame = 7
            end
        else
            self.currentFrame = 7
        end      
    end                   
end

function Enemy:attack()
    local bullet = Bullet(self.x,self.y,"down")
    table.insert(game.enemyBullets, bullet)
end 

function Enemy:draw()
    Enemy.super.draw(self)
    if self.visible then
        if self.flightPlan then
            if debug then
                self.flightPlan:drawDebugData(self)
            end
        end
    end
end

function Enemy:isSquadron()
    return false
end

function Enemy:die()
    self.active = false
    self.visible = false
    self:explode()
    game:enemyKilled(self)
end

function Enemy:explode()
    table.insert(game.explosions,EnemyExplosion(self.x,self.y))
end

function Enemy:isDead()
    return not self.active
end

-------

GreenEnemy = Enemy:extend()
function GreenEnemy:new( x, y, speed, flightPlan )
    local info = SpriteInfo( 2, 8, 0 )
    GreenEnemy.super.new( self, info, x, y, speed, flightPlan )
end

BlueEnemy = Enemy:extend()
function BlueEnemy:new( x, y, speed, flightPlan )
    local info = SpriteInfo( 3, 8, 0 )
    BlueEnemy.super.new( self, info, x, y, speed, flightPlan )
end

RedEnemy = Enemy:extend()
function RedEnemy:new( x, y, speed, flightPlan )
    local info = SpriteInfo( 4, 8, 0 )
    RedEnemy.super.new( self, info, x, y, speed, flightPlan )
end

YellowEnemy = Enemy:extend()
function YellowEnemy:new( x, y, speed, flightPlan )
    local info = SpriteInfo( 3, 8, 1 )
    YellowEnemy.super.new( self, info, x, y, speed, flightPlan )
end
