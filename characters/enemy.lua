Enemy = Character:extend()

function Enemy:new( spriteRow, maxFrames, x, y, column, speed, flightPlan )
    Player.super.new( self, spriteRow, maxFrames, x, y, column )
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

GreenEnemy = Enemy:extend()
function GreenEnemy:new( x, y, speed, flightPlan )
    GreenEnemy.super.new( self, 2, 8, x, y, 0, speed, flightPlan )
end

BlueEnemy = Enemy:extend()
function BlueEnemy:new( x, y, speed, flightPlan )
    BlueEnemy.super.new( self, 3, 8, x, y, 0, speed, flightPlan )
end

RedEnemy = Enemy:extend()
function RedEnemy:new( x, y, speed, flightPlan )
    RedEnemy.super.new( self, 4, 8, x, y, 0, speed, flightPlan )
end

YellowEnemy = Enemy:extend()
function YellowEnemy:new( x, y, speed, flightPlan )
    YellowEnemy.super.new( self, 8, 7, x, y, 1, speed, flightPlan )
end
