
ResourcesSkin1 = Resources:extend()

function ResourcesSkin1:new()
    local image = "resources/sprites-skin1.png"
    ResourcesSkin1.super.new(self,image)
end

function ResourcesSkin1:getBulletFrames()
    local bulletDimensions = self:getBulletDimensions()
    local characterDimensions = self:getCharacterDimensions()
    local frame_width = bulletDimensions.frameWidth
    local frame_height = bulletDimensions.frameHeight
    local aframes = {}
    for spriteRow=1,3 do
        for spriteColumn=1,3 do
            table.insert(aframes, 
                love.graphics.newQuad(
                        (2 * (characterDimensions.frameWidth+2) * 8) + 1 + (spriteColumn-1) * (frame_width+2), 
                        (6.5*(frame_height+2)+1) + (spriteRow-1) * (frame_height+2),
                        frame_width, frame_height, 
                        self.width, self.height))
        end
    end
    return aframes
end

function ResourcesSkin1:getBulletFrameLookingUp()
    return 2
end

function ResourcesSkin1:getCharacterFrames( spriteInfo )
    local characterDimensions = self:getCharacterDimensions()
    local frame_width = characterDimensions.frameWidth
    local frame_height = characterDimensions.frameHeight
    local aframes = {}
    for spriteColumn=0,spriteInfo.maxFrames-1 do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (spriteInfo.column * (frame_width+2) * 8) + 1 + spriteColumn * (frame_width+2), 
                        1 + spriteInfo.row * (frame_height+2),
                        frame_width, frame_height, 
                        self.width, self.height))
    end
    return aframes
end

function ResourcesSkin1:getHoverFramesIds( character )
    local ret = {}
    table.insert(ret,7)
    if #character.frames == 8 then
        table.insert(ret,8)
    end
    return ret
end    

function ResourcesSkin1:getEnemyExplosionFrames()
    local explosionDimensions = self:getExplosionDimensions()
    local characterDimensions = self:getCharacterDimensions()
    local frame_width = explosionDimensions.frameWidth
    local frame_height = explosionDimensions.frameHeight
    local aframes = {}
    for spriteColumn=1,5 do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (2 * (characterDimensions.frameWidth+2) * 8) + 1 + (spriteColumn-1) * (frame_width+2), 
                        1 ,
                        frame_width, frame_height, 
                        self.width, self.height))
    end
    return aframes
end

function ResourcesSkin1:getPlayerExplosionFrames()
    local explosionDimensions = self:getExplosionDimensions()
    local characterDimensions = self:getCharacterDimensions()
    local frame_width = explosionDimensions.frameWidth
    local frame_height = explosionDimensions.frameHeight
    local aframes = {}
    for spriteColumn=1,4 do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (1 * (characterDimensions.frameWidth+2) * 8) + 1 + (spriteColumn-1) * (frame_width+2), 
                        1 ,
                        frame_width, frame_height, 
                        self.width, self.height))
    end
    return aframes
end

function ResourcesSkin1:greenEnemySpriteInfo()
    return SpriteInfo( 2, 0, 8, 7 )
end

function ResourcesSkin1:blueEnemySpriteInfo()
    return SpriteInfo( 3, 0, 8, 7 )
end

function ResourcesSkin1:redEnemySpriteInfo()
    return SpriteInfo( 4, 0, 8, 7 )
end

function ResourcesSkin1:yellowEnemySpriteInfo()
    return SpriteInfo( 2, 1, 8, 7 )
end

function ResourcesSkin1:playerSpriteInfo()
    return SpriteInfo( 0, 0, 7, 7 )
end
 
