Enemy = Character:extend()

function Enemy:new( spriteInfo, x, y, speed, flightPlan )
    Player.super.new( self, spriteInfo, x, y )
    self.speed = speed
    self.flightPlan = flightPlan
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    if self.flightPlan then
        self.flightPlan.update(self.flightPlan, self, dt)
    end
end

function Enemy:rotateThroughFrames(dt)
    self.currentFrame = math.floor(self.currentFrame + self.speed * dt)
    if self.currentFrame > #self.frames then
        self.currentFrame = 1
    end    
end

function Enemy:isSquadron()
    return false
end

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
    local info = SpriteInfo( 8, 7, 1 )
    YellowEnemy.super.new( self, info, x, y, speed, flightPlan )
end
