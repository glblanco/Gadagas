
function loadStarfield()
    starfield = require 'external/starfield'
    sf = starfield:new(1000)
    sf:load()
end

function updateStarfield(dt)
    local x, y = 0, 1 
    sf:update(dt, x ,y)
end

function drawStarfield()
    sf:draw()
end
