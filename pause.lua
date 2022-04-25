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
    return self.delay > 2
end    

LevelCompletedPause = Pause:extend()
function LevelCompletedPause:new(message)
    LevelCompletedPause.super.new(self,message,130,30)
end    
function LevelCompletedPause:elapsed()
    return self.delay > 2
end    

UserRequestedPause = Pause:extend()
function UserRequestedPause:new(message)
    PlayerKilledPause.super.new(self,message)
end    
  

