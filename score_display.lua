ScoreDisplay = Class{}

function ScoreDisplay:init(game)
  self.scaleX, self.scaleY = 1, 1
  self.score = 0
  self.multScale = 1
end

function ScoreDisplay:update(dt)
end

function ScoreDisplay:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Score: " .. self.score, 20, 565, 300, "left", 0, self.scaleX, self.scaleY)

  if self.multScale > 1 then
    love.graphics.printf("x" .. self.multScale, 20, 545, 300, "left", 0, self.scaleX, self.scaleY)
  end
end

function ScoreDisplay:increaseScore(amount)
  if amount == 0 then return end

  self.score = self.score + amount * self.multScale

  self.scaleX, self.scaleY = 1.3, 1.3
  Timer.tween(0.2, self, {scaleX = 1, scaleY = 1}, "out-cubic")
end

function ScoreDisplay:setMult(mult)
  self.multScale = mult
end
