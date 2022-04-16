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

function Squadron:dettach( character )
    self.enemies.remove(character)
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
    local speed = 80
    local timeStep = 2
    local curve = love.math.newBezierCurve({-35,425, 25,525, 75,425, 125,525, 300,400, 400,450, 500,0, 550,30, 600,400, 900,200})
    for i=0,5 do
        table.insert(self.enemies, GreenEnemy(0,0,speed,BezierFlightPlan(curve,i*timeStep)))
    end
end

TwinSquadron = Squadron:extend()
function TwinSquadron:new() 
    TwinSquadron.super.new( self )
    local screenWidth = love.graphics.getWidth()
    local speed = 100
    table.insert(enemies, BlueEnemy(10,500,speed,RightAndUpInTheMiddleFlightPlan()))
    table.insert(enemies, RedEnemy(screenWidth-10,500,speed,LeftAndUpInTheMiddleFlightPlan()))
end

A1Squadron = Squadron:extend()
function A1Squadron:new()
    A1Squadron.super.new( self )    
    local trajectory = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    local speed = 120
    local delay = 0.5
    for i=1,3 do
        local hoverX = 50 + 50*i 
        local hoverY = 150
        table.insert(enemies, BlueEnemy(0, 400, speed, BezierAndHoverCompositeFlightPlan(trajectory,false,hoverX,hoverY,i*delay)))
        table.insert(enemies, YellowEnemy(0, 400, speed, BezierAndHoverCompositeFlightPlan(trajectory,true,hoverX,hoverY,i*delay)))        
    end
    for i=1,3 do
        local hoverX = 50 + 50*i 
        local hoverY = 200
        local startDelay = 1.5
        table.insert(enemies, BlueEnemy(0, 400, speed, BezierAndHoverCompositeFlightPlan(trajectory,false,hoverX,hoverY,startDelay+i*delay)))
        table.insert(enemies, YellowEnemy(0, 400, speed, BezierAndHoverCompositeFlightPlan(trajectory,true,hoverX,hoverY,startDelay+i*delay)))        
    end
end

A2Squadron = Squadron:extend()
function A2Squadron:new( grid )
    A2Squadron.super.new( self )    
    local trajectory = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    local speed = 120
    local delay = 0.5
    for i=1,3 do
        local row = 1
        local col = i + 3 
        table.insert(enemies, BlueEnemy(0, 400, speed, BezierAndSnapToGridFlightPlan(trajectory,false,grid,row,col,i*delay)))
        table.insert(enemies, YellowEnemy(0, 400, speed, BezierAndSnapToGridFlightPlan(trajectory,true,grid,row,col,i*delay)))        
    end
    for i=1,3 do
        local startDelay = 1.5
        local row = 2
        local col = i + 3
        table.insert(enemies, BlueEnemy(0, 400, speed, BezierAndSnapToGridFlightPlan(trajectory,false,grid,row,col,startDelay+i*delay)))
        table.insert(enemies, YellowEnemy(0, 400, speed, BezierAndSnapToGridFlightPlan(trajectory,true,grid,row,col,startDelay+i*delay)))        
    end
end