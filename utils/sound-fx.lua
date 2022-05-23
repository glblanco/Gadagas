SoundFX = Object:extend()

function SoundFX:new()
    self.shot  = love.audio.newSource("resources/Firing_Sound_Effect.mp3", "static")
    self.level = love.audio.newSource("resources/Level_Start_Sound_Effect.mp3", "static")  
    self.kill  = love.audio.newSource("resources/Coin_Sound_Effect.mp3", "static")    
    self.song  = love.audio.newSource("resources/Theme_Song.mp3", "static")      
    self.soundOn = true  
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
    self.soundOn = true    
end

function SoundFX:stopThemeSong()
    self.song:stop()
    self.soundOn = false
end

function SoundFX:killPlayer()
    self.kill:play()
end

function SoundFX:toggleSound()
    if self.soundOn then
        self:stopThemeSong()
    else
        self:startThemeSong()
    end
end

