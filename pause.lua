Pause = Object:extend()
function Pause:new(message,textWidth,textHeight)
    self.delay = 0
    self.board = PauseBoard(message,textWidth,textHeight)
end    
function Pause:update( dt )
    self.delay = self.delay + dt
end    
function Pause:elapsed()
    return false
end    
function Pause:draw()
    self.board:draw()
end


PlayerKilledPause = Pause:extend()
function PlayerKilledPause:new(message)
    PlayerKilledPause.super.new(self,message,60,30)
end    
function PlayerKilledPause:elapsed()
    return self.delay > 3
end    

LevelCompletedPause = Pause:extend()
function LevelCompletedPause:new(message)
    LevelCompletedPause.super.new(self,message,90,30)
end    
function LevelCompletedPause:elapsed()
    return self.delay > 3
end    

UserRequestedPause = Pause:extend()
function UserRequestedPause:new(message)
    UserRequestedPause.super.new(self,"Game paused",130,30)
end    
function UserRequestedPause:elapsed()
    return control:pause()
end    
  
GameOverPause = Pause:extend()
function GameOverPause:new()
    GameOverPause.super.new(self,"",1,1)
end    
function GameOverPause:elapsed()
    return self.delay > 3
end    

