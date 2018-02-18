local bump = require "libs.bump.bump"

require "crystal"
require "player"

require "enemy_base"
require "enemy_small"

Game = {}

Game.waveNumber = 2

function Game:enter (previous)
  self.world = bump.newWorld()

  -- camera looking at (100,100) with zoom 1 and rotate by 0 deg
  self.camera = Camera(100,100, 1, 0)

  self.player = Player(self)
  self.crystal = Crystal(self)

  self.enemies = {}

  self.currentWaveId = -1
  self.currentWaveTime = 0
  self.gameEnded = false

  self:nextWave()
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
  Timer.update(dt)

  self.crystal:update(dt)
  self.player:update(dt)

  for k,enemy in pairs(self.enemies) do
    enemy:update(dt)
  end

  if not self.gameEnded then
    self.currentWaveTime = self.currentWaveTime + dt
    self:checkEnemySpawn()
  end
end

function Game:draw()
  self.crystal:draw()
  self.player:draw()

  for k,enemy in pairs(self.enemies) do
    enemy:draw()
  end
end

function Game:nextWave()
  self.currentWaveId = self.currentWaveId + 1
  self.currentWaveTime = 0

  if self.currentWaveId >= Game.waveNumber then
    self.gameEnded = true
    -- Game finished : player WON
    return
  end

  self:loadWave("waves/wave" .. self.currentWaveId .. ".lua")
end

function Game:loadWave(filename)
  local wave = love.filesystem.load(filename)()
  self.spawn = wave.spawn
end

function Game:checkEnemySpawn()
  if #self.spawn <= 0 then  -- no more enemies to spawn during the wave
    if #self.enemies == 0 then -- And no more enemies in the game -> Start next wave
      self:nextWave()
    end
    return
  end

  local spawn = self.spawn[1]
  if spawn.time <= self.currentWaveTime then
    for i=1,spawn.number do
      if spawn.type == 0 then
        table.insert(self.enemies, EnemySmall(self, spawn.pos))
      else
        -- Other enemy types
      end
    end

    table.remove(self.spawn, 1)
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

function Game:gameOver()
  love.event.quit( )
end
