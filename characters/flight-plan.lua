FlightPlan = Object:extend()

function FlightPlan:new()
    self.complete = false
    self.active = false
end

function FlightPlan:update(character, dt)
    if not self.complete then
        self.active = true
        self:doUpdate( character, dt )
    end
end

function FlightPlan:markComplete()
    self.complete = true
    self.active = false
end

function FlightPlan:drawDebugData(character)
    -- used by subclasses for debugging
end 

function FlightPlan:doUpdate(character, dt)
    -- subclasses should implement
end


CompositeFlightPlan = FlightPlan:extend()

function CompositeFlightPlan:new( flightPlans )
    CompositeFlightPlan.super.new(self)
    self.flightPlans = flightPlans
end

function CompositeFlightPlan:doUpdate(character, dt)
    for i,plan in ipairs(self.flightPlans) do
        if not plan.complete then
            plan:update(character, dt)
            break
        end
    end
end

function CompositeFlightPlan:drawDebugData(character)
    for i,plan in ipairs(self.flightPlans) do
        plan:drawDebugData(character)
        -- setDebugColor()
        -- love.graphics.print('plan '..i..
        --        ': complete:'..(plan.complete and 'true' or 'false')
        --        ..' active:'..(plan.active and 'true' or 'false'),
        --        10,400+i*15)
    end
end 
