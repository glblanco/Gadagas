AttackPlan = Object:extend()

function AttackPlan:new()
    self.complete = false
    self.active = false
    self.time = 0
end

function AttackPlan:update(character, dt)
    if not self.complete then
        self.active = true
        self:doUpdate( character, dt )
    end
end

function AttackPlan:markComplete()
    self.complete = true
    self.active = false
end

function AttackPlan:doUpdate(character, dt)
    if self:shouldInitiateAttackFrom( character, dt ) then
        character:attack()
        self:markComplete()
    end
end

function AttackPlan:shouldInitiateAttackFrom(character, dt)
    -- TODO implement probabilistic attack
    self.time = self.time + dt 
    return self.time > 1
end

