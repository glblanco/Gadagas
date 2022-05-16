HighScoreManager = Object:extend()

function HighScoreManager:new()
    self.scores = {}
    self.max = 5
    self.file = 'highscores.json'
end

function HighScoreManager:add( owner, score )
    local aScore = tonumber(score)
    if self:isHighScore(aScore) then
        local highscore = HighScore(owner,aScore)
        table.insert(self.scores,highscore)
        table.sort(self.scores, function (hs1, hs2) return tonumber(hs1.score) > tonumber(hs2.score) end )
        if #self.scores > self.max then
            for i=self.max+1,#self.scores do
                table.remove(self.scores,i)
            end
        end
    end
end

function HighScoreManager:minScore()
    local min = 0
    if self.scores and #self.scores>=1 then
        min = self.scores[1].score
    end
    for i,score in ipairs(self.scores) do
        if tonumber(score.score) < min then
            min = tonumber(score.score)
        end
    end
    return min
end

function HighScoreManager:isHighScore( score )
    local min = self:minScore()
    return score > 0 and ( score > min or #self.scores < self.max )
end

function HighScoreManager:read()
    local jsonStr = love.filesystem.read(self.file)
    if jsonStr then
        self.scores = DKJson.decode(jsonStr)
    end
end

function HighScoreManager:reset()
    self.scores = {}
    self:write()
end

function HighScoreManager:scoresAsJson()
    return DKJson.encode (self.scores, { indent = true })
end

function HighScoreManager:write()
    love.filesystem.write(self.file,self:scoresAsJson())
end

---

HighScore = Object:extend()

function HighScore:new( owner, score )
    self.owner = owner
    self.score = score
end

---

HighScoreForm = Object:extend()

function HighScoreForm:new( stats )
    self.manager = HighScoreManager()
    self.manager:read()
    self.stats = stats
    if self.manager:isHighScore(self.stats.score) then
        self.manager:add("MAD",self.stats.score)
        self.manager:write()
    end
    self.count = 0
end

function HighScoreForm:update(dt)
    self.count = self.count + dt
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
        love.graphics.print(score.owner,col2X,startY+i*30+25, 0, scale, scale )
        love.graphics.print(score.score,col3X,startY+i*30+25, 0, scale, scale )
    end
end

function HighScoreForm:shouldStopDisplay()
    return self.count > 15
end