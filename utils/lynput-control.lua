LynputControl = Control:extend()

function LynputControl:new()
    Lynput.load_key_callbacks()
    Lynput.load_mouse_callbacks()
    Lynput.load_gamepad_callbacks()
    self.control = Lynput()
    self:bindControlsToActions()    
end

function LynputControl:update(dt)
    Lynput.update_(dt)
end 

function LynputControl:bindControlsToActions()
    self.control:bind("moveLeft", { 
        "hold left",
        "press left",
        "press LMB",
        "-100:0 G_LEFTSTICK_X"
    })
    self.control:bind("moveRight", { 
        "hold right",
        "press right",
        "press RMB",
        "0:100 G_LEFTSTICK_X"        
    })
    self.control:bind("shoot", { 
        "press space",
        "press tab",
        "press MMB",
        "press return"
    })
    self.control:bind("start", { 
        "press any"
    })
    self.control:bind("pause", {
        "press p"
    })
end

function LynputControl:moveLeft()
    return self.control.moveLeft or love.keyboard.isDown("left")
end

function LynputControl:moveRight()
    return self.control.moveRight or love.keyboard.isDown("right")
end

function LynputControl:shoot()
    return self.control.shoot 
end

function LynputControl:pause()
    return self.control.pause 
end

function LynputControl:start()
    return self.control.start 
end