EnemyBase = Class{}

EnemyBase.width, EnemyBase.height = 16, 16
EnemyBase.defaultMaxSpeed = 40
EnemyBase.acceleration = 800

function EnemyBase:init(game, position)
  self.game = game

  self.width = EnemyBase.width
  self.height = EnemyBase.height
  self.maxSpeed = EnemyBase.defaultMaxSpeed
  self.acceleration = EnemyBase.acceleration

  self.position = position or Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

  self.currentSpeed = 0

  self.game.world:add(self, self.position.x, self.position.y, self.width, self.height)
end

function EnemyBase:update(dt)
  self:move(dt)
end

function EnemyBase:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height)
end

function EnemyBase:move(dt)
  local direction = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2) - self.position
  direction:normalizeInplace()

  if direction.x ~= 0 or direction.y ~= 0 then
    if self.currentSpeed == 0 then
      -- EnemyBase just started moving
    end

    self.currentSpeed = self.currentSpeed + self.acceleration * dt
    if self.currentSpeed > self.maxSpeed then self.currentSpeed = self.maxSpeed end

    self.position = self.position + direction * self.currentSpeed * dt -- update position
    local actualX, actualY, cols, len = self.game.world:move(self, self.position.x, self.position.y)
    self.position = Vector(actualX, actualY)

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
