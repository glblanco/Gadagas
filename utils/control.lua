Control = Object:extend()

function Control:new() 
    -- to be implemented by subclasses
end

function Control:update(dt)
    -- to be implemented by subclasses
end 

function Control:moveLeft()
    return false
end

function Control:moveRight()
    return false
end

function Control:shoot()
    return false
end

function Control:pause()
    return false
end

function Control:start()
    return true
end

function Control:toggleSound()
    return false
end