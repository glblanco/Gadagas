SpriteInfo = Object:extend()
function SpriteInfo:new( row, column, maxFrames, frameLookingUp )
    self.column = column                        -- is the character in the first or second set?
    self.row = row                              -- which is the line the character occupies in the sprite - starting at 0
    self.maxFrames = maxFrames                  -- number of images available for the character
    self.frameLookingUp = frameLookingUp        -- which frame is looking up
end

Resources = Object:extend()

function Resources:new( image )
    self.image = love.graphics.newImage(image)
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
    -- to be implemented by subclasses
end

function Resources:getBulletFrameLookingUp()
    -- to be implemented by subclasses
end

function Resources:getCharacterFrames( spriteInfo )
    -- to be implemented by subclasses
end

function Resources:getHoverFramesIds( character )
    -- to be implemented by subclasses
end    

function Resources:getEnemyExplosionFrames()
    -- to be implemented by subclasses
end

function Resources:getPlayerExplosionFrames()
    -- to be implemented by subclasses
end

function Resources:greenEnemySpriteInfo()
    -- to be implemented by subclasses
end

function Resources:blueEnemySpriteInfo()
    -- to be implemented by subclasses
end

function Resources:redEnemySpriteInfo()
    -- to be implemented by subclasses
end

function Resources:yellowEnemySpriteInfo()
    -- to be implemented by subclasses
end

function Resources:playerSpriteInfo()
    -- to be implemented by subclasses
end

