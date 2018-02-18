EnemySmall = Class{__includes = EnemyBase}

EnemySmall.width, EnemySmall.height = 16, 16
EnemySmall.defaultMaxSpeed = 40
EnemySmall.acceleration = 200
EnemySmall.defaultHealth = 2

function EnemySmall:init(game, position)
  EnemyBase.init(self, game, position, EnemySmall.width, EnemySmall.height, EnemySmall.defaultMaxSpeed, EnemySmall.acceleration, EnemySmall.defaultHealth)

  self.velocity = Vector()
  self.knockback = Vector()
  self.drag = 800
end

function EnemySmall:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height)
end

function EnemySmall:move(dt)
  local direction = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2) - self.position
  direction:normalizeInplace()

  if direction.x ~= 0 or direction.y ~= 0 then
    if self.currentSpeed == 0 then
      -- EnemyBase just started moving
    end

    self.velocity = self.velocity + direction * self.acceleration * dt
    if self.velocity:len() > self.maxSpeed then self.velocity = self.velocity:normalized() * self.maxSpeed end

    self.knockback = self.knockback - self.knockback:normalized() * self.drag * dt

    self.position = self.position + (self.velocity + self.knockback) * dt -- update position
    local actualX, actualY, cols, len = self.game.world:move(self, self.position.x, self.position.y)
    self.position = Vector(actualX, actualY)

    for i=1,len do -- If more than one simultaneous collision, they are sorted out by proximity
      local col = cols[i]
      if col.other.type == 'crystal' then
        if not self.isAttacking then
          self:attackCristal(1,1)
        end
      end
    end

    if direction.x > 0 then
      -- EnemyBase is going right
    elseif direction.x < 0 then
      -- EnemyBase is going left
    end
  else
    if self.currentSpeed ~= 0 then
      -- EnemyBase just stopped moving
    end

    self.currentSpeed = 0
  end
end
