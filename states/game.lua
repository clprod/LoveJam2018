local bump = require "libs.bump.bump"

require "crystal"
require "player"

require "enemy_base"
require "enemy_small"
require "enemy_tutorial"

require "score_display"
require "wave_display"
require "tutorial_gui"
require "end_display"

Game = {}

Game.waveNumber = 9

local enemyDeathSound = love.audio.newSource("assets/audio/enemy_death.wav", "static")

function Game:enter (previous)
  love.mouse.setGrabbed(true)
  love.audio.setVolume(0.5)
  -- love.mouse.setCursor(love.mouse.newCursor("assets/cursor/cursor2.png", 0, 0))

  love.graphics.setFont(love.graphics.newFont(18))

  self.world = bump.newWorld()

  -- Game borders
  local screenWidth, screenHeight, borderSize = love.graphics.getWidth(), love.graphics.getHeight(), 50
  self.world:add({type = "border"}, 0, -borderSize, screenWidth, borderSize)
  self.world:add({type = "border"}, -borderSize, 0, borderSize, screenHeight)
  self.world:add({type = "border"}, screenWidth, 0, borderSize, screenHeight)
  self.world:add({type = "border"}, 0, screenHeight, screenWidth, borderSize)

  self.camera = Camera(love.graphics.getWidth()/2, love.graphics.getHeight()/2, 1, 0)

  self.player = Player(self)
  self.crystal = Crystal(self)

  self.enemies = {}

  self.currentWaveId = -1
  self.currentWaveTime = 0
  self.gameEnded = false

  self.scoreDisplay = ScoreDisplay(self)
  self.waveDisplay = WaveDisplay(self)
  self.TutorialGUI = TutorialGUI(self)

  self.endDisplay = EndDisplay(self)

  self.screenshakeActive = true

  self:nextWave()
end

function Game:keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit( )
  elseif key == "p" then
    self.screenshakeActive = not self.screenshakeActive
  elseif key == "r" then
    GameState.switch(Game)
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

  self.TutorialGUI:update(dt)
end

function Game:draw()
  self.camera:attach()

  self.TutorialGUI:draw()

  self.crystal:draw()
  self.player:draw()

  for k,enemy in pairs(self.enemies) do
    enemy:draw()
  end

  self.camera:detach()

  self.scoreDisplay:draw()
  self.waveDisplay:draw()

  if self.gameEnded then
    self.endDisplay:draw()
  end
end

function Game:nextWave()
  self.currentWaveId = self.currentWaveId + 1
  self.currentWaveTime = 0

  self.waveDisplay:setWave(self.currentWaveId)

  if self.currentWaveId >= Game.waveNumber then
    -- Game finished : player WON
    self.gameEnded = true
    self.endDisplay:show(true)

    self.player.dashChargeDecreaseSpeed = 0
    self.player.dashCharge = 100
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
    if #self.enemies <= 0 then -- And no more enemies in the game -> Start next wave
      self:nextWave()
    end
    return
  end

  local spawn = self.spawn[1]
  if spawn.time <= self.currentWaveTime then
    for i=1,spawn.number do
      if spawn.type == 0 then
        table.insert(self.enemies, EnemySmall(self, spawn.pos))
      elseif spawn.type == 1 then
        table.insert(self.enemies, EnemyTutorial(self, spawn.pos))
      end
    end

    table.remove(self.spawn, 1)
  end
end

function Game:removeEnemy(enemy)
  enemyDeathSound:stop()
  enemyDeathSound:play()

  self.world:remove(enemy)
  for i,v in ipairs(self.enemies) do
    if v == enemy then
      table.remove(self.enemies, i)
      return
    end
  end
end

function Game:startScreenshake(duration, intensity, direction)
  if not self.screenshakeActive then return end

  duration = duration or 0.1
  intensity = intensity or 2

  local orig_x, orig_y = self.camera:position()
  if direction == nil then
    Timer.during(duration, function()
      self.camera:lookAt(orig_x + math.random(-intensity, intensity), orig_y + math.random(-intensity, intensity))
    end, function()
      -- reset camera position
      self.camera:lookAt(orig_x, orig_y)
    end)
  else
    direction = direction:normalized()
    self.camera:move(direction.x * intensity, direction.y * intensity)
    Timer.tween(duration, self.camera, {x = orig_x, y = orig_y}, "out-cubic")
  end
end

function Game:startCameraZoom(duration, zoomLevel)
  if not self.screenshakeActive then return end

  duration = duration or 0.1
  zoomLevel = zoomLevel or 1.1

  self.camera.scale = zoomLevel
  Timer.tween(duration, self.camera, {scale = 1}, "out-cubic")
end

function Game:gameOver()
  for i=1,#self.enemies do
    table.remove(self.enemies, 1)
  end

  self.gameEnded = true
  self.endDisplay:show(false)
end
