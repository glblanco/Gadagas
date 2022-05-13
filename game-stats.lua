GameStats = Control:extend()

function GameStats:new()
    self.shots = 0
    self.hits  = 0
    self.score = 0
end

function GameStats:bulletShot()
    self.shots = self.shots + 1
end

function GameStats:enemyKilled( enemy )
    self.hits  = self.hits + 1
    self.score = self.score + 100  -- TODO maybe different enemies have different values
end
