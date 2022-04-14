
UpInTheMiddleFlightPlan = FlightPlan:extend()
function UpInTheMiddleFlightPlan:drawDebugData(character)
    setDebugColor()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local x1 = screenWidth/2 - 3*character.width
    local x2 = screenWidth/2 - character.width
    local x3 = screenWidth/2 
    local x4 = screenWidth/2 + character.width
    local x5 = screenWidth/2 + 3*character.width
    love.graphics.line( x1, 0, x1, screenHeight )
    love.graphics.line( x2, 0, x2, screenHeight )
    love.graphics.line( x3, 0, x3, screenHeight )
    love.graphics.line( x4, 0, x4, screenHeight )
    love.graphics.line( x5, 0, x5, screenHeight )
end 

RightAndUpInTheMiddleFlightPlan = UpInTheMiddleFlightPlan:extend()
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
            self.markComplete(self)
        end
    end
end

LeftAndUpInTheMiddleFlightPlan = UpInTheMiddleFlightPlan:extend()
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
            self.markComplete(self)
        end
    end
end

HorizontalHoverFlightPlan = FlightPlan:extend()
function HorizontalHoverFlightPlan:new(startX,startY)
    HorizontalHoverFlightPlan.super.new(self)
    self.startX = startX
    self.startY = startY
    self.direction = "right"
end
function HorizontalHoverFlightPlan:doUpdate(character, dt)
    character.updateHoverMode(character,dt)
    local extent = 1.5*character.width
    if self.direction == "right" then
        if character.x < self.startX + extent then
            character.x = character.x + character.speed * dt
        else
            self.direction = "left"
        end
    elseif self.direction == "left" then
        if character.x > self.startX - extent then
            character.x = character.x - character.speed * dt
        else
            self.direction = "right"
        end
    end      
end

BezierFlightPlan = FlightPlan:extend()
function BezierFlightPlan:new( bezierCurve, timeDelay )
    BezierFlightPlan.super.new(self)
    self.bezierCurve = bezierCurve
    self.time = -timeDelay
end
function BezierFlightPlan:doUpdate(character, dt)
    if self.time < 0 then
        character.isAlive = false
    else   
        character.isAlive = true
        -- current position
        local x, y = self.nextPosition(self,character,dt)
        character.x = x
        character.y = y
        -- next position
        local nextX, nextY = self.nextPosition(self,character,2*dt)
        local deltaX = nextX - x
        local deltaY = nextY - y
        character.orientation = math.atan2(deltaY, deltaX)
        -- check if plan completed
        if self.hasCompleted(self,character,dt,deltaY,deltaX) then
            self.markComplete(self)
        end
    end
    self.time = self.time + dt
end
function BezierFlightPlan:nextPosition(character, dt)
    return self.bezierCurve:evaluate(((self.time+dt)*character.speed/400)%1)
end
function BezierFlightPlan:hasCompleted(character, dt, deltaY, deltaX)
    local delta = math.abs(character.speed * 10 * dt)
    return  math.abs(deltaY) >= delta or math.abs(deltaX) >= delta 
end
function BezierFlightPlan:drawDebugData(character)
    setDebugColor()
    love.graphics.line(self.bezierCurve:render())
    -- love.graphics.print(
    --    ' complete:'..(self.complete and 'true' or 'false')..
    --    ' active:'..(self.active and 'true' or 'false')
    --    ,10,400)
end 
