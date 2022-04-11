Squadron = Object:extend()
function Squadron:new()
    self.enemies = {}
end

function Squadron:draw()
    for i,enemy in ipairs(self.enemies) do
        enemy:draw()
    end
end

function Squadron:update( dt )
    for i,enemy in ipairs(self.enemies) do
        enemy:update(dt)
    end
end

function Squadron:isSquadron()
    return true
end

TestCrazySquadron = Squadron:extend()
function TestCrazySquadron:new()
    TestCrazySquadron.super.new( self )
    table.insert(self.enemies, GreenEnemy(100,200,40,StraightRightFlightPlan()))
    table.insert(self.enemies, RedEnemy(200,200,80,StraightLeftFlightPlan()))
    table.insert(self.enemies, BlueEnemy(300,200,60,StraightDownFlightPlan()))
    table.insert(self.enemies, YellowEnemy(400,200,100,NeverEndingStraightDownFlightPlan()))  
end

DownwardYellowSquadron = Squadron:extend()
function DownwardYellowSquadron:new()
    DownwardYellowSquadron.super.new( self )
    local screenWidth = love.graphics.getWidth()
    local step = screenWidth / 7
    local speed = 40
    for i=1,6 do
        table.insert(self.enemies, YellowEnemy(step*i,0,speed,NeverEndingStraightDownFlightPlan()))
    end
    for i=1,5 do
        table.insert(self.enemies, YellowEnemy(step*i+(step/2),-50,speed,NeverEndingStraightDownFlightPlan()))
    end
end