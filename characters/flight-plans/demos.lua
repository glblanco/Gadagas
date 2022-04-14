
StraightDownFlightPlan = FlightPlan:extend()
function StraightDownFlightPlan:doUpdate(character, dt)
    character.lookDown(character)
    character.y = character.y + character.speed * dt 
    local screenHeight = love.graphics.getHeight()
    if character.y > screenHeight + character.height then
        self.markComplete(self)
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
        self.markComplete(self)
    end
end

StraightLeftFlightPlan = FlightPlan:extend()
function StraightLeftFlightPlan:doUpdate(character, dt)
    character.lookLeft(character)
    character.x = character.x - character.speed * dt 
    local screenWidth = love.graphics.getWidth()
    if character.x + character.width < 0 then
        self.markComplete(self)
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
function CircularFlightPlan:drawDebugData(character)
    setDebugColor()
    love.graphics.circle( "line", self.centerX, self.centerY, self.radius )
end 
