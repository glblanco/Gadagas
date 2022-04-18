Resources = Object:extend()

function Resources:new()
    self.image = love.graphics.newImage("resources/sprites.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight() 

    self.bulletFrameWidth = 16
    self.bulletFrameHeight = 16
    self.bulletScale = 2
    self.bulletWidth = self.bulletScale * self.bulletFrameWidth
    self.bulletHeight = self.bulletScale * self.bulletFrameHeight

    self.characterFrameWidth = 16
    self.characterFrameHeight = 16
    self.characterScale = 2    
    self.characterWidth = self.characterScale * self.characterFrameWidth
    self.characterHeight = self.characterScale * self.characterFrameHeight

    self.explosionFrameWidth = 32
    self.explosionFrameHeight = 32
    self.explosionScale = 2    
    self.explosionWidth = self.explosionScale * self.explosionFrameWidth
    self.explosionHeight = self.explosionScale* self.explosionFrameHeight
end

function Resources:getBulletFrames()
    local frame_width = self.bulletFrameWidth
    local frame_height = self.bulletFrameHeight
    local aframes = {}
    for spriteRow=1,3 do
        for spriteColumn=1,3 do
            table.insert(aframes, 
                love.graphics.newQuad(
                        (2 * (self.characterFrameWidth+2) * 8) + 1 + (spriteColumn-1) * (frame_width+2), 
                        (6.5*(frame_height+2)+1) + (spriteRow-1) * (frame_height+2),
                        frame_width, frame_height, 
                        self.width, self.height))
        end
    end
    return aframes
end

function Resources:getCharacterFrames( spriteInfo )
    local frame_width = self.characterFrameWidth
    local frame_height = self.characterFrameHeight
    local aframes = {}
    for spriteColumn=0,spriteInfo.maxFrames do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (spriteInfo.column * (frame_width+2) * 8) + 1 + spriteColumn * (frame_width+2), 
                        1 + spriteInfo.row * (frame_height+2),
                        frame_width, frame_height, 
                        self.width, self.height))
    end
    return aframes
end

function Resources:getExplosionFrames()
    local frame_width = self.explosionFrameWidth
    local frame_height = self.explosionFrameHeight
    local aframes = {}
    for spriteColumn=1,5 do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (2 * (self.characterFrameWidth+2) * 8) + 1 + (spriteColumn-1) * (frame_width+2), 
                        1 ,
                        frame_width, frame_height, 
                        self.width, self.height))
    end
    return aframes
end

