
ResourcesSkin1 = Resources:extend()

function ResourcesSkin1:new()
    local image = "resources/sprites-skin1.png"
    ResourcesSkin1.super.new(self,image)
end

function ResourcesSkin1:getBulletFrames()
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

function ResourcesSkin1:getCharacterFrames( spriteInfo )
    local frame_width = self.characterFrameWidth
    local frame_height = self.characterFrameHeight
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

function ResourcesSkin1:getPlayerExplosionFrames()
    local frame_width = self.explosionFrameWidth
    local frame_height = self.explosionFrameHeight
    local aframes = {}
    for spriteColumn=1,4 do
        table.insert(aframes, 
                love.graphics.newQuad(
                        (1 * (self.characterFrameWidth+2) * 8) + 1 + (spriteColumn-1) * (frame_width+2), 
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
 
