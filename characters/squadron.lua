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

SampleBezierGreenSquadron = Squadron:extend()
function SampleBezierGreenSquadron:new()
    SampleBezierGreenSquadron.super.new( self )
    local speed = 50
    local timeStep = 5
    local curve = love.math.newBezierCurve({25,425, 25,525, 75,425, 125,525, 300,400, 400,450, 500,0, 550,30, 600,400, 700,200})
    for i=1,6 do
        table.insert(self.enemies, GreenEnemy(0,0,speed,BezierFlightPlan(curve,i*timeStep)))
    end
end

TwinSquadron = Squadron:extend()
function TwinSquadron:new() 
    TwinSquadron.super.new( self )
    local screenWidth = love.graphics.getWidth()
    table.insert(enemies, BlueEnemy(10,500,40,RightAndUpInTheMiddleFlightPlan()))
    table.insert(enemies, RedEnemy(screenWidth-10,500,40,LeftAndUpInTheMiddleFlightPlan()))
end