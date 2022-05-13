SoundFX = Object:extend()

function SoundFX:new()
    self.shot  = love.audio.newSource("resources/Firing_Sound_Effect.mp3", "static")
    self.level = love.audio.newSource("resources/Level_Start_Sound_Effect.mp3", "static")  
    self.kill  = love.audio.newSource("resources/Coin_Sound_Effect.mp3", "static")    
    self.song  = love.audio.newSource("resources/Theme_Song.mp3", "stream")        
end

function SoundFX:shoot()
    self.shot:play()
end

function SoundFX:startLevel()
    self.level:play()
end

function SoundFX:startThemeSong()
    self.song:setLooping(true)
    self.song:play()
end

function SoundFX:stopThemeSong()
    self.song:stop()
end

function SoundFX:killPlayer()
    self.kill:play()
end