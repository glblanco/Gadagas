
UpInTheMiddleFlightPlan = FlightPlan:extend()
function UpInTheMiddleFlightPlan:drawDebugData(character)
    setDebugColor()
    if self.active then
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
end 

RightAndUpInTheMiddleFlightPlan = UpInTheMiddleFlightPlan:extend()
function RightAndUpInTheMiddleFlightPlan:new()
    self.rotation = math.atan2(1, 0) -- start angle
end
function RightAndUpInTheMiddleFlightPlan:doUpdate(character, dt)
    local screenWidth = love.graphics.getWidth()
    if character.x < (screenWidth/2) - 3*character.width then
        -- straight right
        character:lookRight()
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
        character.orientation = math.atan2(nextY - character.y, nextX - character.x) + math.rad(90)
    else
        -- straight up
        character:lookUp()
        character.y = character.y - character.speed * dt 
        if character.y + character.height < 0 then
            self:markComplete()
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
        character:lookLeft()
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
        character.orientation = math.atan2(nextY - character.y, nextX - character.x) + math.rad(90)
    else
        -- straight up
        character:lookUp()
        character.y = character.y - character.speed * dt 
        if character.y + character.height < 0 then
            self:markComplete()
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
    character:updateHoverMode(dt)
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
    self.time = -1 * timeDelay
end
function BezierFlightPlan:doUpdate(character, dt)
    if self.time < 0 then
        character.visible = false
    elseif self.time >= 0 then
        character.visible = true
        -- current position
        local x, y = self:nextPosition(character,dt)
        character.x = x
        character.y = y
        -- next position
        local nextX, nextY = self:nextPosition(character,2*dt)
        local deltaX = nextX - x
        local deltaY = nextY - y
        character.currentFrame = character.frameLookingUp
        character.orientation = math.atan2(deltaY, deltaX) + math.rad(90)
        -- check if plan completed
        if self:hasCompleted(character,dt,deltaY,deltaX) then
            self:markComplete()
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
    if self.active then
        love.graphics.line(self.bezierCurve:render())
        -- love.graphics.print(
        --    ' complete:'..(self.complete and 'true' or 'false')..
        --    ' active:'..(self.active and 'true' or 'false')
        --    ,10,400)
    end
end 

GoToCoordinateFlightPlan = FlightPlan:extend()
function GoToCoordinateFlightPlan:new( startX, startY, endX, endY )
    GoToCoordinateFlightPlan.super.new(self)
    self.startX = startX
    self.startY = startY
    self.endX = endX
    self.endY = endY
end
function GoToCoordinateFlightPlan:doUpdate(character, dt)
    local correction = math.rad(270)
    local nextX = character.x + math.cos(character.orientation + correction) * character.speed * dt
    local nextY = character.y + math.sin(character.orientation + correction) * character.speed * dt
    character.x = nextX
    character.y = nextY
    character.currentFrame = character.frameLookingUp
    character.orientation = math.atan2(self.endY-nextY, self.endX-nextX) - correction
    if self:hasCompleted(character,dt,self.endY-nextY, self.endX-nextX) then
        self:markComplete()
    end
end
function GoToCoordinateFlightPlan:hasCompleted(character, dt, deltaY, deltaX)
    local delta = math.abs(character.speed * 1.5 * dt)
    return  math.abs(deltaY) <= delta and math.abs(deltaX) <= delta 
end
function GoToCoordinateFlightPlan:drawDebugData(character)
    setDebugColor()
    if self.active then
        love.graphics.line( self.startX, self.startY, self.endX, self.endY )
        love.graphics.print(
            ' complete:'..(self.complete and 'true' or 'false')..
            ' active:'..(self.active and 'true' or 'false')
            ,10,400)
    end
end 
