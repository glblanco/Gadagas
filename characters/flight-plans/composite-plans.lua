
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
function Demo2CompositeFlightPlan:new( mirrored, hoverX, hoverY )
    local trajectory = {100,0, 200,80, 350,100, 500,250, 1000,400, 500,500, 350,400, 350,100}
    local count = table.getn( trajectory )
    local gotoPlan, hoverPlan
    local bezierEndX = trajectory[count-1]
    local bezierEndY = trajectory[count]
    if mirrored then
        local screenWidth = love.graphics.getWidth()
        trajectory = mirrorVertically(trajectory)
        gotoPlan = GoToCoordinateFlightPlan(screenWidth-bezierEndX,bezierEndY,screenWidth-hoverX,hoverY)
        hoverPlan = HorizontalHoverFlightPlan(screenWidth-hoverX,hoverY)
    else
        gotoPlan = GoToCoordinateFlightPlan(bezierEndX,bezierEndY,hoverX,hoverY)
        hoverPlan = HorizontalHoverFlightPlan(hoverX,hoverY)
    end
    local bezierPlan = BezierFlightPlan(love.math.newBezierCurve(trajectory),0)
        
    local plans = {}
    table.insert(plans,bezierPlan)
    table.insert(plans,gotoPlan)    
    table.insert(plans,hoverPlan)

    Demo1CompositeFlightPlan.super.new(self,plans)
end

function mirrorVertically( points )
    local len = table.getn( points )
    local mirroredPoints = { n = len }
    local screenWidth = love.graphics.getWidth()
    for i=1,len do
        if i%2 == 1 then
            mirroredPoints[i] = screenWidth - points[i]
        else
            mirroredPoints[i] = points[i]
        end 
    end
    return mirroredPoints
end