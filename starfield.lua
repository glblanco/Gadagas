
function loadStarfield()
    sf = Starfield:new(1000)
    sf:load()
end

function updateStarfield(dt)
    local x, y = 0, 2 
    sf:update(dt, x ,y)
end

function drawStarfield()
    sf:draw()
end
