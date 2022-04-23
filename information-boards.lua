ScoreBoard = Object:extend()
function ScoreBoard:new()
    self.score = 0
end
function ScoreBoard:add( points )
    self.score = self.score + points
end 
function ScoreBoard:draw()
    setTextColor()
    local textWidth = 50 + (string.len(self.score)-1)*8
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.95
    love.graphics.print("Score: "..self.score,x,y)
    if debug then
        setDebugColor()
        love.graphics.rectangle( "line", x, y, textWidth, textHeight )
    end
end

GameOverBoard = Object:extend()
function GameOverBoard:new()
end
function GameOverBoard:draw()
    setTextColor()
    local scale = 2
    local textWidth = 130
    local textHeight = 30
    local x = love.graphics.getWidth()/2 - textWidth/2
    local y = love.graphics.getHeight()*0.7/2
    if math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.print("Game over", x, y, 0, scale, scale)
    end
    if debug then
        setDebugColor()
        love.graphics.rectangle( "line", x, y, textWidth, textHeight )
    end
end