local bump = require "libs.bump.bump"

require "crystal"
require "player"
require "enemy_base"

Game = {}

function Game:enter (previous)
  self.world = bump.newWorld()

  -- camera looking at (100,100) with zoom 1 and rotate by 0 deg
  self.camera = Camera(100,100, 1, 0)

  self.player = Player(self)
  self.crystal = Crystal(self)

  self.enemies = {}
  for i=1,10 do
    table.insert(self.enemies, EnemyBase(self, Vector(50 + math.random(40)-20, 50 + math.random(40)-20)))
    table.insert(self.enemies, EnemyBase(self, Vector(500 + math.random(40)-20, 100 + math.random(40)-20)))
    table.insert(self.enemies, EnemyBase(self, Vector(400 + math.random(40)-20, 550 + math.random(40)-20)))
  end
end

function Game:mousepressed(x, y, button)
  if button == 1 then
    -- Left mouse button pressed
    self.player:attack(x, y)
  elseif button == 2 then
    -- Right mouse button pressed
    self.player:dash(x, y)
  end
end

function Game:update(dt)
  self.crystal:update(dt)
  self.player:update(dt)

  for k,enemy in pairs(self.enemies) do
    enemy:update(dt)
  end
end

function Game:draw()
  self.crystal:draw()
  self.player:draw()

  for k,enemy in pairs(self.enemies) do
    enemy:draw()
  end
end

function Game:removeEnemy(enemy)
  self.world:remove(enemy)
  for i,v in ipairs(self.enemies) do
    if v == enemy then
      table.remove(self.enemies, i)
      return
    end
  end
end
