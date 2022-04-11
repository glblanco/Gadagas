Enemy = Character:extend()

function Enemy:new( spriteRow, maxFrames, x, y, column )
    Player.super.new( self, spriteRow, maxFrames, x, y, column )
    self.speed = 60
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)

    --self.currentFrame = math.floor(self.currentFrame + self.speed * dt)
    --if self.currentFrame > #self.frames then
    --    self.currentFrame = 1
    --end    

end


GreenEnemy = Enemy:extend()
function GreenEnemy:new( x, y )
    GreenEnemy.super.new( self, 2, 8, x, y, 0 )
end

BlueEnemy = Enemy:extend()
function BlueEnemy:new( x, y )
    BlueEnemy.super.new( self, 3, 8, x, y, 0 )
end

RedEnemy = Enemy:extend()
function RedEnemy:new( x, y )
    RedEnemy.super.new( self, 4, 8, x, y, 0 )
end

YellowEnemy = Enemy:extend()
function YellowEnemy:new( x, y )
    YellowEnemy.super.new( self, 8, 7, x, y, 1 )
end
