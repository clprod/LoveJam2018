Player = Class{}

Player.width, Player.height = 16, 16
Player.defaultMaxSpeed = 125
Player.acceleration = 400
Player.defaultAttackTime = 0.2

function Player:init(game)
  self.game = game
  self.type = 'player'

  self.width = Player.width
  self.height = Player.height
  self.maxSpeed = Player.defaultMaxSpeed
  self.acceleration = Player.acceleration

  self.position = Vector(love.graphics.getWidth()/2 + 50, love.graphics.getHeight()/2)

  self.currentSpeed = 0

  -- Attack properties
  self.attacking = false
  self.attackType = 0
  self.attackTime = Player.defaultAttackTime -- Time to complete the attack (in seconds)
  self.currentAttackTime = 0 -- Time since the beginning of the current attack

  self.attackRange = 50
  self.attackPrecision = 5
  self.attackAngle = math.rad(110)
  self.knockback = 20

  -- Dash properties
  self.dashRange = 100
  self.dashKnockback = 40
  self.dashCharge = 0
  self.dashChargeDecreaseSpeed = 10
  self.dashChargeIncreaseSpeed = 5

  self.game.world:add(self, self.position.x, self.position.y, self.width, self.height)
end

function Player:update(dt)
  self:move(dt)

  -- Attack update
  if self.attacking then
    self.currentAttackTime = self.currentAttackTime + dt
    if self.currentAttackTime >= self.attackTime then
      self.attacking = false
    end
  end

  -- Dash update
  self.dashCharge = self.dashCharge - self.dashChargeDecreaseSpeed * dt
  if self.dashCharge < 0 then self.dashCharge = 0 end
end

function Player:draw()
  love.graphics.setColor(0, 0, 0)

  if self.attacking then
    if self.attackType == 0 then
    love.graphics.setColor(255, 0, 0)
    else
    love.graphics.setColor(0, 255, 0)
    end
  end

  love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height)
end

function Player:move(dt)
  local direction = Vector()
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") or love.keyboard.isDown("q") then direction.x = direction.x - 1 end
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then direction.x = direction.x + 1 end
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") or love.keyboard.isDown("z") then direction.y = direction.y - 1 end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then direction.y = direction.y + 1 end
  direction:normalizeInplace()

  if direction.x ~= 0 or direction.y ~= 0 then
    if self.currentSpeed == 0 then
      -- Player just started moving
    end

    self.currentSpeed = self.currentSpeed + self.acceleration * dt
    if self.currentSpeed > self.maxSpeed then self.currentSpeed = self.maxSpeed end

    local playerMoveFilter = function(item, other)
      if other.type == 'crystal' then return 'slide'
      elseif other.type == 'enemy' then return 'cross'
      else return nil
      end
    end

    local goalPos = self.position + direction * self.currentSpeed * dt -- update position
    local actualX, actualY, cols, len = self.game.world:move(self, goalPos.x, goalPos.y, playerMoveFilter)

    for k,collision in pairs(cols) do
      if collision.other.type ~= 'enemy' then break end

      local normal = (collision.other.position - self.position):normalized()

      collision.other.position = collision.other.position + (goalPos:dist(self.position)) * normal
      self.game.world:update(collision.other, collision.other.position.x, collision.other.position.y)
    end

    self.position = Vector(actualX, actualY)

    if direction.x > 0 then
      -- Player is going right
    elseif direction.x < 0 then
      -- Player is going left
    end
  else
    if self.currentSpeed ~= 0 then
      -- Player just stopped moving
    end

    self.currentSpeed = 0
  end
end

function Player:attack(mouseX, mouseY)
  if self.attackType == 0 then
    self.attackType = 1
  else
    self.attackType = 0
  end

  self.attacking = true
  self.currentAttackTime = 0

  -- Attack collision

  local filter = function(item)
    if item.type ~= 'enemy' then return false end
    return true
  end

  local centerPos = self.position + Vector(self.width/2, self.height/2)
  local v = (Vector(mouseX, mouseY) - centerPos):normalized():rotated(-self.attackAngle/2)

  for i=1,self.attackPrecision do
    -- Raycast
    local endRay = centerPos + v * self.attackRange
    local items, len = self.game.world:querySegment(centerPos.x, centerPos.y, endRay.x, endRay.y, filter)
    for k,enemy in pairs(items) do
      if enemy:loseHp(1) then
        -- if enemy is not killed
        enemy.position = enemy.position + (enemy.position - centerPos):normalized() * self.knockback
        self.game.world:update(enemy, enemy.position.x, enemy.position.y)
      end

      self.dashCharge = self.dashCharge + self.dashChargeIncreaseSpeed
      if self.dashCharge > 100 then self.dashCharge = 100 end
    end

    -- Rotate vector
    v = v:rotated(self.attackAngle / self.attackPrecision)
  end
end

function Player:dash(mouseX, mouseY)
  -- Can't dash if less than 90% charge
  if self.dashCharge < 90 then
    return
  end

  local centerPos = self.position + Vector(self.width/2, self.height/2)
  local dashDirection = (Vector(mouseX, mouseY) - centerPos):normalized()
  local goalPos = centerPos + dashDirection * self.dashRange

  local playerDashFilter = function(item, other)
    if other.type == 'crystal' then return 'touch'
    elseif other.type == 'enemy' then return 'cross'
    else return nil
    end
  end

  local actualX, actualY, cols, len = self.game.world:move(self, goalPos.x, goalPos.y, playerDashFilter)

  for k,collision in pairs(cols) do
    if collision.other.type ~= 'enemy' then break end

    -- Push enemies 90° or -90° from the dash
    local mult = 1
    if math.random(0, 1) == 1 then
      mult = -1
    end
    local normal = dashDirection:rotated(math.rad(mult * 90))

    collision.other.position = collision.other.position + self.dashKnockback * normal
    self.game.world:update(collision.other, collision.other.position.x, collision.other.position.y)
  end

  self.position = Vector(actualX, actualY)
end
