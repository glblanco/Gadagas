Pause = Object:extend()
function Pause:new(message)
    self.message = message
    self.delay = 0
end    
function Pause:update( dt )
    self.delay = self.delay + dt
end    
function Pause:elapsed()
    return false
end    

PlayerKilledPause = Pause:extend()
function PlayerKilledPause:new(message)
    PlayerKilledPause.super.new(self,message)
end    
function PlayerKilledPause:elapsed()
    return self.delay > 2
end    
function PlayerKilledPause:draw()
    setTextColor()
    local scale = 2
    local textWidth = 80
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.7/2
    if math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.print(self.message, x, y, 0, scale, scale)
    end
    if debug then
        setDebugColor()
        love.graphics.rectangle( "line", x, y, textWidth, textHeight )
    end
end

UserRequestedPause = Pause:extend()
function UserRequestedPause:new(message)
    PlayerKilledPause.super.new(self,message)
end    
  

