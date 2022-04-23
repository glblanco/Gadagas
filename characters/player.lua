Player = Character:extend()

function Player:new( x, y )
    local info = SpriteInfo( 0, 7, 0 )
    Player.super.new( self, info, x, y )
    self.speed = 500
    self.active = false
    self.currentFrame = 7
    self:lookUp()
end

function Player:moveToStartingPosition()
    self.x = (love.graphics.getWidth())/2 
    self.y = love.graphics.getHeight() - (self.height*2.2)
end

function Player:activate()
    self.active = true
    self.moveToStartingPosition(self)
end

function Player:update(dt)
    Player.super.update(self, dt)
    if self.active then
        self.action(self, dt)
        self:checkForImpacts()
    end
end

function Player:checkForImpacts()
    for i,bullet in ipairs(game.enemyBullets) do
        if bullet:collides(self) then
            bullet:hit(self)
            break
        end
    end    
end

function Player:action(dt)

    if control:moveLeft() then   
        self.x = self.x - self.speed * dt    
        --If the x is too far too the left then..
        if self.x < 0 then
            --Set x to 0
            self.x = 0 
        end
    end 

    if control:moveRight() then   
        self.x = self.x + self.speed * dt  
         --Get the width of the window
        local window_width = love.graphics.getWidth()
        -- if the x is too far to the right then..
        if self.x + self.width > window_width then
            --Set the x to the window's width.
            self.x = window_width - self.width
        end   
    end
      
    if control:shoot() then   
        local bullet = Bullet(self.x,self.y,"up")
        table.insert(game.playerBullets, bullet)
    end

end

function Player:die()
    self.active = false
    self.visible = false 
    self:explode()
end

function Player:explode()
    table.insert(game.explosions,PlayerExplosion(self.x,self.y))
end


