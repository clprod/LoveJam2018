WaveDisplay = Class{}

function WaveDisplay:init(game)
  self.scaleX, self.scaleY = 1, 1
  self.wave = 0
end

function WaveDisplay:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Wave: " .. self.wave, 650, 565, 100, "left", 0, self.scaleX, self.scaleY)
end

function WaveDisplay:setWave(wave)
  self.wave = wave

  self.scaleX, self.scaleY = 1.3, 1.3
  Timer.tween(0.2, self, {scaleX = 1, scaleY = 1}, "out-cubic")
end
