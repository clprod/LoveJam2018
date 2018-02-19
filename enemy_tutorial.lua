EnemyTutorial = Class{__includes = EnemyBase}

EnemyTutorial.width, EnemyTutorial.height = 16, 16
EnemyTutorial.defaultMaxSpeed = 40
EnemyTutorial.acceleration = 200
EnemyTutorial.defaultHealth = 2

function EnemyTutorial:init(game, position)
  EnemyBase.init(self, game, position, EnemyTutorial.width, EnemyTutorial.height, EnemyTutorial.defaultMaxSpeed, EnemyTutorial.acceleration, EnemyTutorial.defaultHealth)

  self.knockback = Vector()
  self.drag = 800
end

function EnemyTutorial:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height)
end

function EnemyTutorial:move(dt)
  local direction = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2) - self.position
  direction:normalizeInplace()

  if direction.x ~= 0 or direction.y ~= 0 then
    self.knockback = self.knockback - self.knockback:normalized() * self.drag * dt

    self.position = self.position + self.knockback * dt -- update position
    local actualX, actualY, cols, len = self.game.world:move(self, self.position.x, self.position.y)
    self.position = Vector(actualX, actualY)
  end
end
