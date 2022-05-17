HighScoreForm = Object:extend()

function HighScoreForm:new( stats )
    self.manager = highscoreManager
    self.manager:read()
    self.stats = stats
    self.chars = {}
    self.confirm = false
    self.count = 0
    self.currentLetter = 1

    self.chars[1] = "A"
    self.chars[2] = "A"
    self.chars[3] = "A"

    self.temp = HighScore("AAA",stats.score)
    self.manager:add(self.temp)
end

function HighScoreForm:name()
    return self.chars[1] .. self.chars[2] .. self.chars[3]
end

function HighScoreForm:update(dt)
    self.count = self.count + dt

    if self.manager:isHighScore(self.stats.score) and not self.confirm then
        if control:clickLeft() then
            self.currentLetter = ( self.currentLetter - 1 ) 
            if self.currentLetter < 1 then self.currentLetter = 1 end
        end
        if control:clickRight() then
            self.currentLetter = ( self.currentLetter + 1  ) 
            if self.currentLetter > 3 then self.currentLetter = 3 end
        end
        if control:clickUp() then
            local letter = string.byte(self.chars[self.currentLetter])
            letter = letter + 1
            local zed = string.byte("Z")
            if letter > zed then letter = zed end
            self.chars[self.currentLetter] = string.char(letter)
        end
        if control:clickDown() then
            local letter = string.byte(self.chars[self.currentLetter])
            letter = letter - 1
            local a = string.byte("A")
            if letter < a then letter = a end
            self.chars[self.currentLetter] = string.char(letter)          
        end
        if control:shoot() then
            self.confirm = true
        end
    end

    if self.manager:isHighScore(self.stats.score) and self.confirm then
        local hs = HighScore(self:name(),self.stats.score)
        self.manager:replace(self.temp,hs)
        self.manager:write()
    end

end

function HighScoreForm:draw()
    setTextColor()
    local col1X = 290
    local col2X = 340
    local col3X = 430
    local startY = 120
    local scale = 2
    love.graphics.print("High Scores", col1X, startY, 0, 2.6, 2.6)
    for i,score in ipairs(self.manager.scores) do
        love.graphics.print(i,col1X,startY+i*30+25, 0, scale, scale)
        if score == self.temp then
            local y = startY+i*30+25
            local charWidth = 20
            local charHeight = 30
            love.graphics.print(self.chars[1],col2X, y, 0, scale, scale )
            love.graphics.print(self.chars[2],col2X+charWidth, y, 0, scale, scale )
            love.graphics.print(self.chars[3],col2X+2*charWidth, y, 0, scale, scale )
            love.graphics.line(col2X + (self.currentLetter-1) * charWidth, y+charHeight, col2X + (self.currentLetter) * charWidth, y+charHeight)
        else 
            love.graphics.print(score.owner,col2X,startY+i*30+25, 0, scale, scale )
        end
        love.graphics.print(score.score,col3X,startY+i*30+25, 0, scale, scale )        
    end
    if debugMode then
        setDebugColor()
        love.graphics.print(self.currentLetter, 10, 10 )
        love.graphics.print(string.sub(self:name(),2,2), 10, 30)
        love.graphics.print(string.byte("Z"), 10, 50)
        love.graphics.print(string.byte(string.sub(self:name(),self.currentLetter,self.currentLetter)), 10, 70)
        love.graphics.print(self.manager:scoresAsJson(), 10, 90)
    end
end

function HighScoreForm:shouldStopDisplay()
    return self.count > 15
end