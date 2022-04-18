SpriteInfo = Object:extend()
function SpriteInfo:new( row, maxFrames, column )
    self.column = column        -- is the character in the first or second set?
    self.row = row              -- which is the line the character occupies in the sprite - starting at 0
    self.maxFrames = maxFrames  -- number of images available for the character
end

Character = Entity:extend()

function Character:new( spriteInfo, x, y )
    Character.super.new( self, x, y, resources.characterWidth, resources.characterHeight )
    self.frames = resources:getCharacterFrames(spriteInfo)
    self.scale = 2
    self.speed = 0
    self.currentFrame = 1
    self.active = true
    self.orientation = 0
end

function Character:lookUp()
    self.currentFrame = 1
    self.orientation = math.atan2(-1, 0)
end

function Character:lookDown()
    self.currentFrame = 1
    self.orientation = math.atan2(1, 0)
end

function Character:lookRight()
    self.currentFrame = 1
    self.orientation = math.atan2(0, 1)
end

function Character:lookLeft()
    self.currentFrame = 1
    self.orientation = math.atan2(0, -1)
end

function Character:update(dt)
    -- subclasses should implement  
end

function Character:drawableOrientation()
    -- images are looking right, not left
    return self.orientation + math.rad(180)
end

function Character:die()
    -- to be implemented by subclasses
end