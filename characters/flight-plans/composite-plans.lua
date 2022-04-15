
Demo1CompositeFlightPlan = CompositeFlightPlan:extend()
function Demo1CompositeFlightPlan:new()
    local plans = {}
    table.insert(plans,StraightRightFlightPlan())
    table.insert(plans,StraightLeftFlightPlan())
    table.insert(plans,StraightRightFlightPlan())
    table.insert(plans,StraightLeftFlightPlan())
    Demo2CompositeFlightPlan.super.new(self,plans)
end

Demo2CompositeFlightPlan = CompositeFlightPlan:extend()
function Demo2CompositeFlightPlan:new( mirrored )
    local trajectory = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    if mirrored then
        trajectory = mirrorVertically(trajectory)
    end
    local bezierPlan = BezierFlightPlan(love.math.newBezierCurve(trajectory),0)
    local gotoPlan = GoToCoordinateFlightPlan(350,100,100,500)
    local hoverPlan = HorizontalHoverFlightPlan(100,500)
    local plans = {}
    table.insert(plans,bezierPlan)
    table.insert(plans,gotoPlan)    
    table.insert(plans,hoverPlan)
    Demo1CompositeFlightPlan.super.new(self,plans)
end

function mirrorVertically( points )
    return points
end