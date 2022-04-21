HoverGrid = Object:extend()
function HoverGrid:new(rows,cols)
    self.grid = {}
    for i=1,rows do
        self.grid[i] = {}
        for j=1,cols do
            self.grid[i][j]= nil
        end
    end
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    self.rows = rows
    self.cols = cols
    self.cellWidth = ( screenWidth * 0.85 ) / cols 
    self.cellHeight = ( screenHeight * 0.6 ) / rows 
    self.startX = ( screenWidth * 0.1 ) 
    self.startY = ( screenHeight * 0.1 )
    self.x = self.startX
    self.y = self.startY
    self.direction = "right"
    self.speed = 30
    self.active = true
end
function HoverGrid:getCharacterAt(row,col)
    return self.grid[row][col]
end
function HoverGrid:setCharacterAt(row,col,character)
    self.grid[row][col] = character
end

function HoverGrid:update(dt)
    -- move grid
    local extent = 48
    if self.direction == "right" then
        if self.x < self.startX + extent then
            self.x = self.x + self.speed * dt
        else
            self.direction = "left"
        end
    elseif self.direction == "left" then
        if self.x > self.startX - extent then
            self.x = self.x - self.speed * dt
        else
            self.direction = "right"
        end
    end    
    -- update characters on grid
    for i=1,self.rows do
        for j=1,self.cols do
            if self.grid[i][j] then
                local character = self.grid[i][j]
                local x,y = self:getCoordinates(i,j)
                character.x = x 
                character.y = y
                character:updateHoverMode(dt)
                character:update(dt)
            end 
        end
    end
end
function HoverGrid:getCellOccupiedBy( character )
    local row = 0
    local col = 0
    for i=1, self.rows do
        for j=1, self.cols do 
            if character:equals(self.grid[i][j]) then
                row = i
                col = j
                break
            end 
        end
    end 
    return row,col
end 
function HoverGrid:getEmptyCellFarFrom( row, col ) 
    local aRow = 0
    local aCol = 0
    for distance=1,self.rows do
        local invDistance = self.rows - distance
        for i=-invDistance,invDistance do
            for j=-invDistance,invDistance do
                if i>0 or j>0 then
                    if (0 < row + i) and (row + i) < self.rows then 
                        if (0 < col + j) and (col + j) < self.cols then 
                            if not self.grid[row+i][col+j] then  
                                aCol = col + j
                                aRow = row + i 
                                break
                            end 
                        end
                    end
                end
            end
        end
    end 
    return aRow, aCol    
end
function HoverGrid:getEmptyCellNear( row, col ) 
    local aRow = 0
    local aCol = 0
    for distance=1,self.rows do
        for i=-distance,distance do
            for j=-distance,distance do
                if i>0 or j>0 then
                    if (0 < row + i) and (row + i) < self.rows then 
                        if (0 < col + j) and (col + j) < self.cols then 
                            if not self.grid[row+i][col+j] then  
                                aCol = col + j
                                aRow = row + i 
                                break
                            end 
                        end
                    end
                end
            end
        end
    end 
    return aRow, aCol
end 
function HoverGrid:draw()
    setMainColor()
    -- the drawing of enemies is currently handled by the squadron
    if debug then
        self:drawDebugData()
    end
end 
function HoverGrid:drawDebugData()
    setDebugColor()
    for i=1,self.rows do
        for j=1,self.cols do
            local x,y = self:getCoordinates(i,j)
            love.graphics.circle( "fill", x, y, 2 )
            --love.graphics.print("[" .. i .. "," .. j .. "]", x, y )
        end
    end 
end
function HoverGrid:getCoordinates(row,col)
    local x = (col - 1) * self.cellWidth + self.x
    local y = (row - 1) * self.cellHeight + self.y
    return x,y
end
function HoverGrid:attach(character,row,col)
    local aRow = row
    local aCol = col
    if self.grid[row][col] then
        aRow, aCol = self:getEmptyCellNear(row,col)
    end 
    self.grid[aRow][aCol] = character
end


SnapToGridFlightPlan = FlightPlan:extend()
function SnapToGridFlightPlan:new(grid,row,col)
    self.grid = grid
    self.row = row
    self.col = col
end
function SnapToGridFlightPlan:doUpdate(character, dt)
    local x,y = self.grid:getCoordinates(self.row,self.col)
    character.orientation = math.atan2(y-character.y, x-character.x)
    character.x = character.x + math.cos(character.orientation) * character.speed * dt
    character.y = character.y + math.sin(character.orientation) * character.speed * dt
    if self:hasCompleted(character,dt,y-character.y, x-character.x) then
        self:markComplete()
        self.grid:attach(character,self.row,self.col)
    end
end
function SnapToGridFlightPlan:hasCompleted(character, dt, deltaY, deltaX)
    local delta = math.abs(character.speed * 1.5 * dt)
    return  math.abs(deltaY) <= delta and math.abs(deltaX) <= delta 
end