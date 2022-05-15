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
    return score > min
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


HighScore = Object:extend()
function HighScore:new( owner, score )
    self.owner = owner
    self.score = score
end



