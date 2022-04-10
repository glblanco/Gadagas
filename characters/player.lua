Player = Character:extend()

function Player:new( x, y )
    Player.super.new( self, 0, 7, x, y, 0 )
    self.speed = 500
    self.isActive = false
    self.currentFrame = 7
end

function Player:moveToStartingPosition()
    self.x = (love.graphics.getWidth())/2
    self.y = love.graphics.getHeight() - (self.height*2.2)
end

function Player:activate()
    self.isActive = true
    self.moveToStartingPosition(self)
end

function Player:update(dt)
    Player.super.update(self, dt)
    if self.isActive then
        self.move(self, dt)
    end
end

function Player:move(dt)

    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") then
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

end

