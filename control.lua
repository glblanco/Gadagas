Control = Object:extend()

function Control:new()
    Lynput = require("external/Lynput")
    Lynput.load_key_callbacks()
    Lynput.load_mouse_callbacks()
    Lynput.load_gamepad_callbacks()
    self.control = Lynput()
    self.bindControlsToActions(self)    
end

function Control:update(dt)
    Lynput.update_(dt)
end 

function Control:bindControlsToActions()
    self.control:bind("moveLeft", { 
        "hold left",
        "press LMB",
        "-100:0 G_LEFTSTICK_X"
    })
    self.control:bind("moveRight", { 
        "hold right",
        "press RMB",
        "0:100 G_LEFTSTICK_X"        
    })
    self.control:bind("shoot", { 
        "press space",
        "press tab",
        "press return",
        "press MMB"
    })
    -- self.control:bind("start", "press any")
end
