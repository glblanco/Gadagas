
Character = Entity:extend()

function Character:new( spriteInfo, x, y )
    Character.super.new( self, x, y, resources.characterWidth, resources.characterHeight, 
                        resources.characterScale, resources:getCharacterFrames(spriteInfo) )
    self.speed = 0
    self.active = true
    self.visible = true
    self.orientation = 0
    self.frameLookingUp = spriteInfo.frameLookingUp
    self.orientationCorrection = spriteInfo.orientationCorrection
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
    return self.orientation + math.rad(180) -- + self.orientationCorrection
end

function Character:die()
    -- to be implemented by subclasses
end