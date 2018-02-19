TutorialGUI = Class{}

local keysImage = love.graphics.newImage("assets/textures/keys.png")
local mouseImage = love.graphics.newImage("assets/textures/mouse.png")
local arrow1Image = love.graphics.newImage("assets/textures/arrow1.png")

function TutorialGUI:init(game)
  self.game = game

  self.active = true
  self.alpha = 255
  self.transitionning = false
end

function TutorialGUI:update(dt)
  if self.active and self.game.currentWaveId >= 1 and not self.transitionning then
    self.transitionning = true
    Timer.tween(1, self, {alpha = 0}, "out-cubic", function () self.active = false end)
  end
end

function TutorialGUI:draw()
  if not self.active then return end

  love.graphics.setColor(0, 0, 0, self.alpha)

  love.graphics.printf("PROTECT !", 100, 180, 700, 'center', math.rad(5))
  love.graphics.printf("KILL TO START !", 20, 170, 200, 'center', math.rad(-5))

  love.graphics.draw(keysImage, 225, 425, 0, 1, 1)
  love.graphics.printf("MOVE", 225, 515, 126, 'center')

  love.graphics.draw(mouseImage, 515, 445, 0, 1, 1)
  love.graphics.printf("ATTACK", 440, 425, 100, 'center')
  love.graphics.printf("DASH", 540, 425, 100, 'center')

  love.graphics.draw(arrow1Image, 390, 290, math.rad(-100), 1, 1, 0, 0)

  love.graphics.draw(arrow1Image, 130, 100, math.rad(0), -1, 1, 0, 0)
end
