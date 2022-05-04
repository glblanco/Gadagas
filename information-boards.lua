Board = Object:extend()
function Board:new( message )
    self.message = message
end
function Board:draw( x, y, textWidth, textHeight, scale )
    setTextColor()
    love.graphics.print( self:getMessage(), x, y, 0, scale, scale )
    if debugMode then
        setDebugColor()
        love.graphics.rectangle( "line", x, y, textWidth, textHeight )
    end
end
function Board:getMessage()
    return self.message
end    
function Board:setMessage( message )
    self.message = message 
end    

FlickeringBoard = Board:extend()
function FlickeringBoard:new( message )
    FlickeringBoard.super.new( self, message )
end
function FlickeringBoard:draw( x, y, textWidth, textHeight, scale )
    if math.floor(love.timer.getTime()) % 2 == 0 then
        FlickeringBoard.super.draw( self, x, y, textWidth, textHeight, scale)
    end
end



ScoreBoard = Board:extend()
function ScoreBoard:new()
    ScoreBoard.super.new(self, "")
    self.score = 0
end
function ScoreBoard:setScore( points )
    self.score = points
end 
function ScoreBoard:getMessage()
    return "Score: "..self.score
end    
function ScoreBoard:draw()
    local textWidth = 50 + (string.len(self.score)-1)*8
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.95
    local scale = 1
    ScoreBoard.super.draw( self, x, y, textWidth, textHeight, scale )
end

GameOverBoard = FlickeringBoard:extend()
function GameOverBoard:new()
    GameOverBoard.super.new(self, "Game Over")
end
function GameOverBoard:draw()
    local scale = 2
    local textWidth = 135
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.7/2
    GameOverBoard.super.draw( self, x, y, textWidth, textHeight, scale )
end

WinnerBoard = FlickeringBoard:extend()
function WinnerBoard:new()
    WinnerBoard.super.new(self,"You win")
end
function WinnerBoard:draw()
    local scale = 2
    local textWidth = 90
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.7/2
    GameOverBoard.super.draw( self, x, y, textWidth, textHeight, scale )
end

PauseBoard = FlickeringBoard:extend()
function PauseBoard:new( message, textWidth, textHeight )
    PauseBoard.super.new(self,message)
    self.textWidth = textWidth
    self.textHeight = textHeight
end
function PauseBoard:draw()
    local scale = 2
    local x = love.graphics.getWidth()/2 - self.textWidth/2
    local y = love.graphics.getHeight()*0.7/2
    GameOverBoard.super.draw( self, x, y, self.textWidth, self.textHeight, scale )
end