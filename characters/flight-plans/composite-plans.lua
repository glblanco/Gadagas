
Demo1CompositeFlightPlan = CompositeFlightPlan:extend()
function Demo1CompositeFlightPlan:new()
    local plans = {}
    table.insert(plans,StraightRightFlightPlan())
    table.insert(plans,StraightLeftFlightPlan())
    table.insert(plans,StraightRightFlightPlan())
    table.insert(plans,StraightLeftFlightPlan())
    Demo2CompositeFlightPlan.super.new(self,plans)
end

BezierAndHoverCompositeFlightPlan = CompositeFlightPlan:extend()
function BezierAndHoverCompositeFlightPlan:new( trajectory, mirrored, hoverX, hoverY, delay )
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
    local bezierPlan = BezierFlightPlan(love.math.newBezierCurve(trajectory),delay)
        
    local plans = {}
    table.insert(plans,bezierPlan)
    table.insert(plans,gotoPlan)    
    table.insert(plans,hoverPlan)

    BezierAndHoverCompositeFlightPlan.super.new(self,plans)
end

BezierAndSnapToGridFlightPlan = CompositeFlightPlan:extend()
function BezierAndSnapToGridFlightPlan:new( trajectory, mirrored, grid, hoverRow, hoverCol, delay )
    local count = table.getn( trajectory )
    local col = hoverCol
    if mirrored then
        local screenWidth = love.graphics.getWidth()
        trajectory = mirrorVertically(trajectory)
        col = grid.cols - (hoverCol-1)
    end
    local bezierPlan = BezierFlightPlan(love.math.newBezierCurve(trajectory),delay)
        
    local plans = {}
    table.insert(plans,bezierPlan)
    table.insert(plans,SnapToGridFlightPlan(grid,hoverRow,col))

    BezierAndSnapToGridFlightPlan.super.new(self,plans)
end

KamikazeFlightPlan = BezierAndSnapToGridFlightPlan:extend()
function KamikazeFlightPlan:new( character, grid )
    
    local row, col = grid:getCellOccupiedBy(character)
    local destRow, destCol = grid:getEmptyCellFarFrom(row,col)

    local x,y = grid:getCoordinates(row,col)
    local x2,y2 = grid:getCoordinates(destRow,destCol)

    local delay = 0
    local mirrored = ( math.random(0,1) >= 0.5 )
    local screenWidth = love.graphics.getWidth()
    local trajectory = { x, y, 0, 0, 100, 200, 100, 500, 600, love.graphics.getHeight(), 650, 600, screenWidth, 500, x2, y2 }
    if mirrored then
        trajectory = { x, y, 0, 0, screenWidth - 100, 200, screenWidth - 100, 500, screenWidth - 600, love.graphics.getHeight(), screenWidth - 650, 600, 0, 500, x2, y2 }
    end 
    KamikazeFlightPlan.super.new(self,trajectory,false,grid,destRow,destCol,delay)
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