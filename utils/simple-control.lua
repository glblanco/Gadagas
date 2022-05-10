SimpleControl = Control:extend()

function SimpleControl:new()
    self.actions = {}
end

function SimpleControl:update(dt)
    self.actions = {}
end 

function SimpleControl:moveLeft()
    return self:received("moveLeft") or 
            love.keyboard.isDown("left") or 
            love.mouse.isDown(reverseMapMouseButton("moveLeft"))
end

function SimpleControl:moveRight()
    return self:received("moveRight") or 
            love.keyboard.isDown("right") or 
            love.mouse.isDown(reverseMapMouseButton("moveRight"))
end

function SimpleControl:shoot()
    return self:received("shoot")
end

function SimpleControl:received( action )
    ret = false
    for i,item in ipairs(self.actions) do
        if item == action then
            ret = true
            table.remove(self.actions,i)
            break
        end
    end
    return ret
end

function SimpleControl:pause()
    return self:received("pause")
end

function SimpleControl:start()
    return #self.actions > 0 --self:received("start") or self:received("shoot")
end

function mapKey( key )
    local ret = nil
    if key == "space" or key == "return" then
        ret = "shoot"
    elseif key == "p" then
        ret = "pause"
    else
        ret = "start"
    end
    return ret
end

function mapMouseButton( button )
    local ret = nil
    if button == 3 then
        ret = "shoot"
    end
    if button == 1 then
        ret = "moveLeft"
    end
    if button == 2 then
        ret = "moveRight"
    end
    return ret
end

function reverseMapMouseButton( action )
    local ret = nil
    if action == "shoot" then
        ret = 3
    end
    if action == "moveLeft" then
        ret = 1
    end
    if action == "moveRight" then
        ret = 2
    end
    return ret
end    

function love.keypressed(key)
    local action = mapKey(key)
    if action then
        table.insert(control.actions,action)
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    local action = mapMouseButton(button)
    if action then
        table.insert(control.actions,action)
    end
end