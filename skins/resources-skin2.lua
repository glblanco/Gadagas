ResourcesSkin2 = Resources:extend()

function ResourcesSkin2:new()
    local image = "resources/sprites-skin2.png"
    ResourcesSkin2.super.new(self,image)
end

function ResourcesSkin2:getBulletFrames()
    local frame_width = self.bulletFrameWidth
    local frame_height = self.bulletFrameHeight
    local aframes = {}
    for spriteRow=1,3 do
        for spriteColumn=1,3 do
            table.insert(aframes, 
                love.graphics.newQuad(
                        (2 * (self.characterFrameWidth+2) * 8) + 2  + (spriteColumn-1) * (frame_width+2), 
                        (6.5*(frame_height+2)+1) + (spriteRow-1) * (frame_height+2),
                        frame_width, frame_height, 
                        self.width, self.height))
        end
    end
    return aframes
end

function ResourcesSkin2:getCharacterFrames( spriteInfo )
    local frame_width = self.characterFrameWidth
    local frame_height = self.characterFrameHeight
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

function ResourcesSkin2:getPlayerExplosionFrames()
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


GreenEnemySpriteInfo = SpriteInfo:extend()
function GreenEnemySpriteInfo:new()
    GreenEnemySpriteInfo.super.new( self, 6, 0, 7 )
end    

BlueEnemySpriteInfo = SpriteInfo:extend()
function BlueEnemySpriteInfo:new()
    BlueEnemySpriteInfo.super.new( self, 3, 0, 8 )
end    

RedEnemySpriteInfo = SpriteInfo:extend()
function RedEnemySpriteInfo:new()
    RedEnemySpriteInfo.super.new( self, 4, 0, 8 )
end    

YellowEnemySpriteInfo = SpriteInfo:extend()
function YellowEnemySpriteInfo:new()
    YellowEnemySpriteInfo.super.new( self, 5, 0, 8 )
end    

PlayerSpriteInfo = SpriteInfo:extend()
function PlayerSpriteInfo:new()
    PlayerSpriteInfo.super.new( self, 0, 0, 8 )
end    