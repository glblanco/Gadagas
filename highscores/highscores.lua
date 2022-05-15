HighScoreManager = Object:extend()

function HighScoreManager:new()
    self.scores = {}
    self.max = 5
    self.file = 'highscores/highscores.json'
end

function HighScoreManager:add( owner, score )
    if self:isHighScore(score) then
        local highscore = HighScore(owner,score)
        table.insert(self.scores,highScore)
        table.sort(self.scores, function (hs1, hs2) return hs1.score < hs2.score end )
        if #self.scores > self.max then
            for i=max+1,#self.scores do
                table.remove(self.scores,i)
            end
        end
    end
end

function HighScoreManager:maxScore()
    local max = 0
    for i,score in ipairs(self.scores) do
        if score.score > max then
            max = score.score
        end
    end
    return max
end

function HighScoreManager:minScore()
    local min = 0
    if self.scores and #self.scores>=1 then
        min = self.scores[1].score
    end
    for i,score in ipairs(self.scores) do
        if score.score < min then
            min = score.score
        end
    end
    return min
end

function HighScoreManager:isHighScore( score )
    local min = self:minScore()
    return score > min
end

function HighScoreManager:read()
    --local https = require("https")
    --code, body, headers = http.request("https://gadagas.s3.sa-east-1.amazonaws.com/highscores.json")
    local jsonStr = love.filesystem.read(self.file)
    if jsonStr then
        self.scores = DKJson.decode(jsonStr)
    end
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



