Control = Object:extend()

function Control:new()
    Lynput = require("../external/Lynput")
    Lynput.load_key_callbacks()
    Lynput.load_mouse_callbacks()
    Lynput.load_gamepad_callbacks()
    self.control = Lynput()
    self:bindControlsToActions()    
end

function Control:update(dt)
    Lynput.update_(dt)
end 

function Control:bindControlsToActions()
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

function Control:moveLeft()
    return self.control.moveLeft or love.keyboard.isDown("left")
end

function Control:moveRight()
    return self.control.moveRight or love.keyboard.isDown("right")
end

function Control:shoot()
    return self.control.shoot 
end

function Control:pause()
    return self.control.pause 
end

function Control:start()
    return self.control.start 
end