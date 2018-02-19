EnemyBase = Class{}

function EnemyBase:init(game, position, width, height, defaultMaxSpeed, acceleration, health)
  self.game = game
  self.type = 'enemy'

  self.width = width
  self.height = height
  self.maxSpeed = defaultMaxSpeed
  self.acceleration = acceleration

  self.position = position or Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

  self.currentSpeed = 0

  self.game.world:add(self, self.position.x, self.position.y, self.width, self.height)

  self.isAttacking = false
  self.attackTimerHandle = nil
  self.health = health
end

function EnemyBase:update(dt)
  self:move(dt)
end

function EnemyBase:draw()
end

function EnemyBase:attackCristal(attackRate, attackDammage)
  self.isAttacking = true
  self.attackTimerHandle = Timer.after(attackRate,function()
		self.game.crystal:loseHp(attackDammage)
		self.isAttacking = false
    self.game:startScreenshake(0.1, 2)
  end)

end

-- return false is enemy is killed
function EnemyBase:loseHp(hpNb)
  self.health = self.health - hpNb
  if self.health <= 0 then
    if self.attackTimerHandle ~= nil then
      Timer.cancel(self.attackTimerHandle)
    end
    self.game:removeEnemy(self)
    return false
  end
  return true
end

function EnemyBase:move(dt)
end
