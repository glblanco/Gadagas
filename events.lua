Event = Object:extend()
function Event:new( payload )
    self.payload = payload
end
function Event:action( game )
    -- to be implemented by subclasses
end

----

LevelCompletedEvent = Event:extend()
function LevelCompletedEvent:action( game )
    game:handleLevelCompletedEvent()
end

PlayerKilledEvent = Event:extend()
function PlayerKilledEvent:action( game )
    game:handlePlayerKilledEvent()
end

EnemyKilledEvent = Event:extend()
function EnemyKilledEvent:action( game )
    game:handleEnemyKilledEvent(self.payload)
end

PlayerShotBulletEvent = Event:extend()
function PlayerShotBulletEvent:action( game )
    game:addPlayerBullet(self.payload)
end

EnemyShotBulletEvent = Event:extend()
function EnemyShotBulletEvent:action( game )
    game:addEnemyBullet(self.payload)
end

ExplosionEvent = Event:extend()
function ExplosionEvent:action( game )
    game:addExplosion(self.payload)
end


