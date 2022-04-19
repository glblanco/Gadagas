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
        self.move(self, dt)
    end
end

function Player:move(dt)

    if control:moveLeft() then   
        self.x = self.x - self.speed * dt     
    end 

    if control:moveRight() then   
        self.x = self.x + self.speed * dt     
    end
    
    --Get the width of the window
    local window_width = love.graphics.getWidth()

    --If the x is too far too the left then..
    if self.x < 0 then
        --Set x to 0
        self.x = 0

    --Else, if the x is too far to the right then..
    elseif self.x + self.width > window_width then
        --Set the x to the window's width.
        self.x = window_width - self.width
    end

    if control:shoot() then   
        self.shoot = true   
        bullet = Bullet(self.x,self.y,"up")
        table.insert(bullets, bullet)
    else 
        self.shoot = false     
    end

end

function Player:die()
    -- check lives left
    -- mark as dead
    -- remove from container    
end


