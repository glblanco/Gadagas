Board = Object:extend()
function Board:new()
end
function Board:draw( message, x, y, textWidth, textHeight, scale )
    setTextColor()
    love.graphics.print( message, x, y, 0, scale, scale )
    if debug then
        setDebugColor()
        love.graphics.rectangle( "line", x, y, textWidth, textHeight )
    end
end

FlickeringBoard = Board:extend()
function FlickeringBoard:new()
end
function FlickeringBoard:draw( message, x, y, textWidth, textHeight, scale )
    if math.floor(love.timer.getTime()) % 2 == 0 then
        FlickeringBoard.super.draw(self, message, x, y, textWidth, textHeight, scale)
    end
end



ScoreBoard = Board:extend()
function ScoreBoard:new()
    self.score = 0
end
function ScoreBoard:setScore( points )
    self.score = points
end 
function ScoreBoard:draw()
    local textWidth = 50 + (string.len(self.score)-1)*8
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.95
    local scale = 1
    ScoreBoard.super.draw(self, "Score: "..self.score, x, y, textWidth, textHeight, scale )
end

GameOverBoard = FlickeringBoard:extend()
function GameOverBoard:new()
end
function GameOverBoard:draw()
    local scale = 2
    local textWidth = 130
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.7/2
    GameOverBoard.super.draw(self, "Game Over", x, y, textWidth, textHeight, scale )
end

WinnerBoard = FlickeringBoard:extend()
function WinnerBoard:new()
end
function WinnerBoard:draw()
    local scale = 2
    local textWidth = 130
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.7/2
    GameOverBoard.super.draw(self, "You win", x, y, textWidth, textHeight, scale )
end

PauseBoard = FlickeringBoard:extend()
function PauseBoard:new( message, textWidth, textHeight )
    self.message = message
    self.textWidth = textWidth
    self.textHeight = textHeight
end
function PauseBoard:setMessage( message )
    self.message = message 
end    
function PauseBoard:draw()
    local scale = 2
    local x = love.graphics.getWidth()/2 - self.textWidth/2
    local y = love.graphics.getHeight()*0.7/2
    GameOverBoard.super.draw(self, self.message , x, y, self.textWidth, self.textHeight, scale )
end