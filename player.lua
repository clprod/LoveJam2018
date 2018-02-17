Player = Class{}

Player.width, Player.height = 16, 16
Player.defaultMaxSpeed = 125
Player.acceleration = 400

function Player:init(game)
  self.game = game

  self.width = Player.width
  self.height = Player.height
  self.maxSpeed = Player.defaultMaxSpeed
  self.acceleration = Player.acceleration

  self.position = Vector(love.graphics.getWidth()/2 + 50, love.graphics.getHeight()/2)

  self.currentSpeed = 0

  self.game.world:add(self, self.position.x, self.position.y, self.width, self.height)
end

function Player:update(dt)
  self:move(dt)
end

function Player:draw()
  love.graphics.setColor(0, 0, 0)
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

    self.position = self.position + direction * self.currentSpeed * dt -- update position
    local actualX, actualY, cols, len = self.game.world:move(self, self.position.x, self.position.y)
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
