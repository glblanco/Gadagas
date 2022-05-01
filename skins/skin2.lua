ResourcesSkin2 = Resources:extend()

function ResourcesSkin2:new()
    local image = "resources/sprites-skin2.png"
    ResourcesSkin2.super.new(self,image)
end

function Resources:getBulletDimensions()
    return EntityDimensions(3,8,2)
end

function ResourcesSkin2:getBulletFrames()
    local bulletDimensions = self:getBulletDimensions()
    local frame_width = bulletDimensions.frameWidth
    local frame_height = bulletDimensions.frameHeight
    local aframes = {}
    table.insert(aframes, 
        love.graphics.newQuad(
            355, 
            58,
            frame_width, frame_height, 
            self.width, self.height))
    return aframes
end

function ResourcesSkin2:getBulletFrameLookingUp()
    return 1
end

function ResourcesSkin2:getCharacterFrames( spriteInfo )
    local characterDimensions = self:getCharacterDimensions()
    local frame_width = characterDimensions.frameWidth
    local frame_height = characterDimensions.frameHeight
    local aframes = {}
    local start = 0
    
    for spriteColumn=0,spriteInfo.maxFrames-1 do
        local col = spriteColumn
        if spriteInfo.maxFrames == 7 and spriteColumn == 0 then
           col = 1
        end
        table.insert(aframes, 
            love.graphics.newQuad(
                    (spriteInfo.column * (frame_width+4) * 8) + col * (frame_width + 8), 
                    (spriteInfo.row) * (frame_height+8) + 54  ,
                    frame_width, frame_height, 
                    self.width, self.height))
    end
    return aframes
end

function ResourcesSkin2:getHoverFramesIds( character )
    local ret = {}
    table.insert(ret,2)
    if #character.frames == 8 then
        table.insert(ret,1)
    end
    return ret
end    

function ResourcesSkin2:getEnemyExplosionFrames()
    local explosionDimensions = self:getExplosionDimensions()
    local frame_width = explosionDimensions.frameWidth
    local frame_height = explosionDimensions.frameHeight
    local aframes = {}
    local startX = {}
    table.insert(startX,185)
    table.insert(startX,209)
    table.insert(startX,241)
    table.insert(startX,281)
    for spriteColumn=1,4 do
        local sx = startX[spriteColumn]
        table.insert(aframes, 
            love.graphics.newQuad(
                sx, 
                214,
                frame_width, frame_height, 
                self.width, self.height))
    end
    return aframes
end

function ResourcesSkin2:getPlayerExplosionFrames()
    local explosionDimensions = self:getExplosionDimensions()
    local frame_width = explosionDimensions.frameWidth
    local frame_height = explosionDimensions.frameHeight
    local aframes = {}
    for spriteColumn=0,3 do
        table.insert(aframes, 
            love.graphics.newQuad(
                193 + (spriteColumn * (explosionDimensions.frameWidth + 8)), 
                54  ,
                frame_width, frame_height, 
                self.width, self.height))
    end
    return aframes
end


function ResourcesSkin2:greenEnemySpriteInfo()
    return SpriteInfo( 2, 0, 8, 2 )
end

function ResourcesSkin2:blueEnemySpriteInfo()
    return SpriteInfo( 3, 0, 8, 2 )
end

function ResourcesSkin2:redEnemySpriteInfo()
    return SpriteInfo( 4, 0, 8, 2 )
end

function ResourcesSkin2:yellowEnemySpriteInfo()
    return SpriteInfo( 5, 0, 8, 2 )
end

function ResourcesSkin2:playerSpriteInfo()
    return SpriteInfo( 0, 0, 7, 2 )
end
 