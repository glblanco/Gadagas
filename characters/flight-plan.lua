FlightPlan = Object:extend()

function FlightPlan:new()
    self.completed = false
end

function FlightPlan:update(character, dt)
    if not self.completed then
        self.doUpdate( self, character, dt )
    end
end

function FlightPlan:drawData()
    -- used by subclasses for debugging
end 

function FlightPlan:doUpdate(character, dt)
    -- subclasses should implement
end

StraightDownFlightPlan = FlightPlan:extend()
function StraightDownFlightPlan:doUpdate(character, dt)
    character.lookDown(character)
    character.y = character.y + character.speed * dt 
    local screenHeight = love.graphics.getHeight()
    if character.y > screenHeight + character.height then
        self.completed = true
    end
end

NeverEndingStraightDownFlightPlan = FlightPlan:extend()
function NeverEndingStraightDownFlightPlan:doUpdate(character, dt)
    character.lookDown(character)
    character.y = character.y + character.speed * dt 
    local screenHeight = love.graphics.getHeight()
    if character.y > screenHeight + character.height then
        character.y = 0
    end
end

StraightRightFlightPlan = FlightPlan:extend()
function StraightRightFlightPlan:doUpdate(character, dt)
    character.lookRight(character)
    character.x = character.x + character.speed * dt 
    local screenWidth = love.graphics.getWidth()
    if character.x > screenWidth + character.width then
        self.completed = true
    end
end

StraightLeftFlightPlan = FlightPlan:extend()
function StraightLeftFlightPlan:doUpdate(character, dt)
    character.lookLeft(character)
    character.x = character.x - character.speed * dt 
    local screenWidth = love.graphics.getWidth()
    if character.x + character.width < 0 then
        self.completed = true
    end
end

CircularFlightPlan = FlightPlan:extend()
function CircularFlightPlan:new( centerX, centerY, radius, direction )
    self.rotation = 0  -- start angle
    self.centerX = centerX
    self.centerY = centerY
    self.radius = radius
    self.direction = direction
end
function CircularFlightPlan:doUpdate(character, dt)
    local deltaRotation = (character.speed/self.radius)*dt
    if self.direction == "clockwise" then
        self.rotation = self.rotation + deltaRotation
    else  
        self.rotation = self.rotation - deltaRotation
    end
    character.x = self.radius * math.cos(self.rotation) + self.centerX
    character.y = self.radius * math.sin(self.rotation) + self.centerY
    local nextRotation = 0
    if self.direction == "clockwise" then
        nextRotation = self.rotation + deltaRotation 
    else
        nextRotation = self.rotation - deltaRotation   
    end
    nextX = self.radius * math.cos(nextRotation) + self.centerX
    nextY = self.radius * math.sin(nextRotation) + self.centerY
    character.orientation = math.atan2(nextY - character.y, nextX - character.x)
end

RightAndUpInTheMiddleFlightPlan = FlightPlan:extend()
function RightAndUpInTheMiddleFlightPlan:new()
    self.rotation = math.atan2(1, 0)  -- start angle
end
function RightAndUpInTheMiddleFlightPlan:doUpdate(character, dt)
    local screenWidth = love.graphics.getWidth()
    if character.x < (screenWidth/2) - 3*character.width then
        -- straight right
        character.lookRight(character)
        character.x = character.x + character.speed * dt    
        self.startY = character.y     
    elseif character.x < (screenWidth/2) - character.width - 1 then
        -- circular motion
        local radius = 2*character.width                 
        local ox = (screenWidth/2) - 3*character.width   
        local oy = self.startY - 2*character.height
        self.rotation = self.rotation - (character.speed/radius)*dt 
        character.x = radius * math.cos(self.rotation) + ox
        character.y = radius * math.sin(self.rotation) + oy
        self.nextRotation = self.rotation - (character.speed/radius)*dt 
        nextX = radius * math.cos(self.nextRotation) + ox
        nextY = radius * math.sin(self.nextRotation) + oy
        character.orientation = math.atan2(nextY - character.y, nextX - character.x)
    else
        -- straight up
        character.lookUp(character)
        character.y = character.y - character.speed * dt 
        if character.y + character.height < 0 then
            self.completed = true
        end
    end
end

LeftAndUpInTheMiddleFlightPlan = FlightPlan:extend()
function LeftAndUpInTheMiddleFlightPlan:new()
    self.rotation = math.atan2(1, 0)  -- start angle
end
function LeftAndUpInTheMiddleFlightPlan:doUpdate(character, dt)
    local screenWidth = love.graphics.getWidth()
    if character.x > (screenWidth/2) + 3*character.width then
        -- straight left
        character.lookLeft(character)
        character.x = character.x - character.speed * dt         
        self.startY = character.y   
    elseif character.x > (screenWidth/2) + character.width + 1 then
        -- circular motion
        local radius = 2*character.width                 
        local ox = (screenWidth/2) + 3*character.width   
        local oy = self.startY - 2*character.height
        self.rotation = self.rotation + (character.speed/radius)*dt 
        character.x = radius * math.cos(self.rotation) + ox
        character.y = radius * math.sin(self.rotation) + oy
        self.nextRotation = self.rotation + (character.speed/radius)*dt 
        nextX = radius * math.cos(self.nextRotation) + ox
        nextY = radius * math.sin(self.nextRotation) + oy
        character.orientation = math.atan2(nextY - character.y, nextX - character.x)
    else
        -- straight up
        character.lookUp(character)
        character.y = character.y - character.speed * dt 
        if character.y + character.height < 0 then
            self.completed = true
        end
    end
end

BezierFlightPlan = FlightPlan:extend()
function BezierFlightPlan:new( bezierCurve, timeDelay )
    BezierFlightPlan.super.new(self)
    self.bezierCurve = bezierCurve
    self.timeDelay = timeDelay
    self.time = 0
end
function BezierFlightPlan:doUpdate(character, dt)
    if (self.time - self.timeDelay) <= 0 then
        character.isAlive = false
    else   
        character.isAlive = true
        -- current position
        local x, y = self.bezierCurve:evaluate(((self.time-self.timeDelay)*character.speed/400)%1)
        character.x = x
        character.y = y
        -- next position
        local nextX, nextY = self.bezierCurve:evaluate(((self.time-self.timeDelay+(dt))*character.speed/400)%1)
        character.orientation = math.atan2(nextY - y, nextX - x)
        -- check if plan completed
        if self.hasCompleted(self,character,dt) then
            self.completed = true
        end
    end
    character.dt = dt
    self.time = self.time + dt
end
function BezierFlightPlan:hasCompleted(character, dt)
    local num = curve:getControlPointCount()
    local lx,ly = curve:getControlPoint(num)
    local delta = character.speed * 10 * dt
    return  lx - delta < character.x and
            lx + delta > character.x and
            ly - delta < character.y and
            ly + delta > character.y   
end
