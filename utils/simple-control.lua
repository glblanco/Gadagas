SimpleControl = Control:extend()

function SimpleControl:new()
    self.actions = {}
end

function SimpleControl:update(dt)
    self.actions = {}
end 

function SimpleControl:moveLeft()
    return self:received("moveLeft") or 
            love.keyboard.isDown("left") --or 
            --love.mouse.isDown(reverseMapMouseButton("moveLeft"))
end

function SimpleControl:moveRight()
    return self:received("moveRight") or 
            love.keyboard.isDown("right") --or 
            --love.mouse.isDown(reverseMapMouseButton("moveRight"))
end

function SimpleControl:clickLeft()
    return self:received("moveLeft") --or 
            --love.mouse.isDown(reverseMapMouseButton("moveLeft"))
end

function SimpleControl:clickRight()
    return self:received("moveRight") --or 
            --love.mouse.isDown(reverseMapMouseButton("moveRight"))
end

function SimpleControl:clickDown()
    return self:received("moveDown") 
            -- love.keyboard.isDown("down") 
end

function SimpleControl:clickUp()
    return self:received("moveUp") 
            -- love.keyboard.isDown("up") 
end

function SimpleControl:shoot()
    return self:received("shoot")
end

function SimpleControl:toggleSound()
    return self:received("toggleSound")
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
    elseif key == "s" then
        ret = "toggleSound"
    elseif key == "right" then
        ret = "moveRight"        
    elseif key == "left" then
        ret = "moveLeft"       
    elseif key == "up" then
        ret = "moveUp"       
    elseif key == "down" then
        ret = "moveDown"        
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

function reactToMousePress(x,y)
    local action = nil
    local player = game:currentPlayer()
    if player then
        if ( ( player.x - 30 )  <= x ) and ( x <= (player.x + 30) ) then
            action = "shoot"
        elseif player.x < x then
            action = "moveRight"
        elseif player.x > x then
            action = "moveLeft"
        end 
        if action then
            table.insert(control.actions,action)
        end
    else
        table.insert(control.actions,"start")
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    
    --if istouch then
        --if presses > 0 then
            reactToMousePress(x,y)
        --end
    --else
        --if presses > 0 then
            --table.insert(control.actions,"shoot")
        -- else
        --    local action = mapMouseButton(button)
        --    if action then
        --        table.insert(control.actions,action)
        --    end
        --end
    --end
end

function love.mousemoved( x, y, dx, dy, istouch )
    --if istouch then
    --    action = nil
    --    if dx > 0 then
    --        action = "moveRight"
    --    elseif dx < 0 then
    --        action = "moveLeft"
    --    end
    --    if action then
    --        table.insert(control.actions,action)
    --    end
    --end
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    --table.insert(control.actions,"shoot")
    reactToMousePress(x,y)
end

function love.touchmoved( id, x, y, dx, dy, pressure )
    --action = nil
    --if dx > 0 then
    --    action = "moveRight"
    --elseif dx < 0 then
    --    action = "moveLeft"
    --end
    --if dy > 0 then
    --    action = "moveUp"
    --elseif dy < 0 then
    --    action = "moveDown"
    --end
    --if action then
    --    table.insert(control.actions,action)
    --end
end