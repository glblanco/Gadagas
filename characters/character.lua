
Character = Entity:extend()

function Character:new( spriteInfo, x, y )
    local characterDimensions = resources:getCharacterDimensions()
    Character.super.new( self, x, y, characterDimensions.width, characterDimensions.height, 
                characterDimensions.scale, resources:getCharacterFrames(spriteInfo) )
    self.speed = 0
    self.active = true
    self.visible = true
    self.orientation = 0
    self.frameLookingUp = spriteInfo.frameLookingUp
    self.currentFrame = self.frameLookingUp
end

function Character:lookUp()
    self.currentFrame = self.frameLookingUp
    self.orientation = 0 
end

function Character:lookDown()
    self.currentFrame = self.frameLookingUp
    self.orientation = math.atan2(0, -1)
end

function Character:lookRight()
    self.currentFrame = self.frameLookingUp
    self.orientation = math.atan2(1, 0)
end

function Character:lookLeft()
    self.currentFrame = self.frameLookingUp
    self.orientation = math.atan2(-1, 0)
end

function Character:update(dt)
    -- subclasses should implement  
end

function Character:die()
    -- to be implemented by subclasses
end