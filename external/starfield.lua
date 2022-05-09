-- This will be a table returned at the end of the file, holds all the code necessary to create starfields
local Starfield = {}
-- This is here so that the starfields you create will have everything inside them.
Starfield.__index = Starfield

-- degrees to radians constant
local d2r = math.pi/180

function Starfield:new(density)
  local starfield = {}
  -- This gives the above created starfield every function (and variable) the Starfield table in this file has.
  setmetatable(starfield, Starfield)
  
  -- Saves the given density value
  starfield.density = density
  
  -- Creates an empty table that will hold the stars' data.
  self.stars = {}

  return starfield
end

function Starfield:load()

  local w, h = love.graphics.getDimensions()
  
  -- This loop will set up all the stars with their position, size and visibility generated randomly.
  for i = 1, self.density do --number of stars
    self.stars[i] = {
      x = love.math.random()*w,
      y = love.math.random()*h,
      size = love.math.random()*1.4+.1,
      z = love.math.random()*8+.5,       -- depth
      radiance = love.math.random(1,255) -- alpha (transparency)
    }
  end

end

function Starfield:update(dt, x, y)

  -- If we don't pass in an x or y value, take it as 0 by default
  x, y = x or 0, y or 0

  local w, h = love.graphics.getDimensions()
  
  for i = 1, #self.stars do
    -- Modify each star's position, but wrap them around the screen (with the % modulo/modulus, or remainder operator)
    self.stars[i].x, self.stars[i].y = (self.stars[i].x + x*dt)%w, (self.stars[i].y + y*dt)%h
  end
  
end

function Starfield:draw()

  local w, h = love.graphics.getDimensions()
  
  for i = 1, #self.stars do
    -- this helps translate each star with differing amounts, creating a parallax effect
    local parallax = self.stars[i].z * math.tan(90 / 2 * d2r)
    love.graphics.push()
    love.graphics.setPointSize(self.stars[i].size)
    love.graphics.setColor(255, 255, 255, self.stars[i].radiance)
    -- We modify the drawn positions with the parallax.
    --love.graphics.points(self.stars[i].x*parallax, self.stars[i].y*parallax, self.stars[i].size)
    love.graphics.ellipse('fill', self.stars[i].x*parallax, self.stars[i].y*parallax, self.stars[i].size, self.stars[i].size)
    love.graphics.pop()
  end
  
end

return Starfield