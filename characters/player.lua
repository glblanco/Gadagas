Player = Character:extend()

function Player:new( x, y )
    local info = SpriteInfo( 0, 7, 0 )
    Player.super.new( self, info, x, y )
    self.speed = 500
    self.isActive = false
    self.currentFrame = 7
    self.shoot = false
    self.lookUp(self)
end

function Player:moveToStartingPosition()
    self.x = (love.graphics.getWidth())/2 
    self.y = love.graphics.getHeight() - (self.height*2.2)
end

function Player:activate()
    self.isActive = true
    self.moveToStartingPosition(self)
    self.control = Lynput()
end

function Player:update(dt)
    Player.super.update(self, dt)
    if self.isActive then
        self.move(self, dt)
    end
end

function Player:move(dt)

    if input.control.moveLeft then   
        self.x = self.x - self.speed * dt     
    end 

    if input.control.moveRight then   
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

    if input.control.shoot then   
        self.shoot = true   
    else 
        self.shoot = false     
    end

end



