Squadron = Object:extend()
function Squadron:new()
    self.enemies = {}
    self.active = true
end

function Squadron:draw()
    for i,enemy in ipairs(self.enemies) do
        enemy:draw()
        if debug then
            -- local row,col = grid:getCellOccupiedBy(enemy)
            -- love.graphics.print("enemy " .. i .. " ->  x:" .. enemy.x .. " y:" .. enemy.y .. " w:" .. enemy.width .. " h: " .. enemy.height .. " cf: " .. enemy.currentFrame .. " s: " .. enemy.speed .. ' nf: ' ..#enemy.frames .. ' row: ' .. row .. ' col: ' .. col , 10, (15*#lives+10)+(15*i+10))
        end
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

function Squadron:isDead()
    local ret = true
    for i,enemy in ipairs(self.enemies) do
        ret = ret and enemy:isDead()
    end
    return ret 
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
    table.insert(self.enemies, BlueEnemy(10,500,speed,RightAndUpInTheMiddleFlightPlan()))
    table.insert(self.enemies, RedEnemy(screenWidth-10,500,speed,LeftAndUpInTheMiddleFlightPlan()))
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
        table.insert(self.enemies, BlueEnemy(0, 400, speed, BezierAndHoverCompositeFlightPlan(trajectory,false,hoverX,hoverY,i*delay)))
        table.insert(self.enemies, YellowEnemy(0, 400, speed, BezierAndHoverCompositeFlightPlan(trajectory,true,hoverX,hoverY,i*delay)))        
    end
    for i=1,3 do
        local hoverX = 50 + 50*i 
        local hoverY = 200
        local startDelay = 1.5
        table.insert(self.enemies, BlueEnemy(0, 400, speed, BezierAndHoverCompositeFlightPlan(trajectory,false,hoverX,hoverY,startDelay+i*delay)))
        table.insert(self.enemies, YellowEnemy(0, 400, speed, BezierAndHoverCompositeFlightPlan(trajectory,true,hoverX,hoverY,startDelay+i*delay)))        
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
        table.insert(self.enemies, BlueEnemy(0, 400, speed, BezierAndSnapToGridFlightPlan(trajectory,false,grid,row,col,i*delay)))
        table.insert(self.enemies, YellowEnemy(0, 400, speed, BezierAndSnapToGridFlightPlan(trajectory,true,grid,row,col,i*delay)))        
    end
    for i=1,3 do
        local startDelay = 1.5
        local row = 2
        local col = i + 3
        table.insert(self.enemies, BlueEnemy(0, 400, speed, BezierAndSnapToGridFlightPlan(trajectory,false,grid,row,col,startDelay+i*delay)))
        table.insert(self.enemies, YellowEnemy(0, 400, speed, BezierAndSnapToGridFlightPlan(trajectory,true,grid,row,col,startDelay+i*delay)))        
    end
end

A3Squadron = A2Squadron:extend()
function A3Squadron:new( grid )
    A3Squadron.super.new( self, grid )  
    self.grid = grid  
end 
function A3Squadron:update( dt )
    A3Squadron.super.update( self, dt )    
    -- send an enemy to attack the player 
    if self:shouldAttack(dt) then
        local enemy = self:chooseEnemyForAttack()
        if enemy then 
            local row, col = self.grid:getCellOccupiedBy(enemy)
            if row > 0 and col > 0 then
                flightPlan = KamikazeFlightPlan(enemy,self.grid)
                self.grid:setCharacterAt(row,col,nil) 
                enemy.flightPlan = flightPlan
                enemy.attackPlan = AttackPlan()
                enemy.currentFrame = 1
            end
        end 
    end 
end
function A3Squadron:shouldAttack( dt ) 
    return #self:activeEnemies() == #self:activeEnemiesInGrid()
end   
function A3Squadron:activeEnemies()
    local activeEnemies = {}
    for i=1,#self.enemies do
        local enemy = self.enemies[i]
        if enemy.active then
            table.insert(activeEnemies, enemy)  
        end 
    end
    return activeEnemies
end
function A3Squadron:activeEnemiesInGrid()
    local activeEnemies = {}
    for i=1,#self.enemies do
        local enemy = self.enemies[i]
        if enemy.active and self.grid:includes(enemy) then
            table.insert(activeEnemies, enemy)  
        end 
    end
    return activeEnemies
end
function A3Squadron:chooseEnemyForAttack() 
    local activeEnemies = self:activeEnemiesInGrid()
    local chosenAttacker = activeEnemies[ math.random( 1, #activeEnemies ) ] 
    return chosenAttacker
end 