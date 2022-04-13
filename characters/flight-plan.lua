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

RightAndUpInTheMiddleFlightPlan = FlightPlan:extend()
function RightAndUpInTheMiddleFlightPlan:doUpdate(character, dt)

    local screenWidth = love.graphics.getWidth()
    if character.x < (screenWidth/2) - character.width then
        character.lookRight(character)
        character.x = character.x + character.speed * dt         
    else
        character.lookUp(character)
        character.y = character.y - character.speed * dt 
        if character.y + character.height < 0 then
            self.completed = true
        end
    end
end

LeftAndUpInTheMiddleFlightPlan = FlightPlan:extend()
function LeftAndUpInTheMiddleFlightPlan:doUpdate(character, dt)

    local screenWidth = love.graphics.getWidth()
    if character.x > (screenWidth/2) + character.width then
        character.lookLeft(character)
        character.x = character.x - character.speed * dt         
    else
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
end
function BezierFlightPlan:doUpdate(character, dt)
    
    character.lookRight(character)
    -- current position
    local x, y = self.bezierCurve:evaluate(((love.timer.getTime()-self.timeDelay)/character.speed)%1)
    character.x = x
    character.y = y
    -- next position
    local nextX, nextY = self.bezierCurve:evaluate(((love.timer.getTime()+dt-self.timeDelay)/character.speed)%1)
    character.orientation = math.atan2(nextY - y, nextX - x)
end
