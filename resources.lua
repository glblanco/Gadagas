SpriteInfo = Object:extend()
function SpriteInfo:new( row, column, maxFrames, frameLookingUp )
    self.column = column                        -- is the character in the first or second set?
    self.row = row                              -- which is the line the character occupies in the sprite - starting at 0
    self.maxFrames = maxFrames                  -- number of images available for the character
    self.frameLookingUp = frameLookingUp        -- which frame is looking up
end

EntityDimensions = Object:extend()
function EntityDimensions:new(frameWidth,frameHeight,scale,width,height)
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.scale = scale
    self.width = width 
    self.height = height
end

Resources = Object:extend()
function Resources:new( image )
    self.image = love.graphics.newImage(image)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight() 
end

function Resources:getImage()
    return self.image
end

function Resources:getBulletDimensions()
    return EntityDimensions(16,16,2,2*16,2*16)
end

function Resources:getCharacterDimensions()
    return EntityDimensions(16,16,2,2*16,2*16)
end

function Resources:getExplosionDimensions()
    return EntityDimensions(32,32,2,2*32,2*32)
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

