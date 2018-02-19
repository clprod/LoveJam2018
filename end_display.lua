EndDisplay = Class{}

function EndDisplay:init(game)
	self.alpha = 0
	self.text = ""
end

function EndDisplay:draw()
  love.graphics.setColor(0, 0, 0, self.alpha)
  love.graphics.printf(self.text, 0, 360, 800, "center")
end

function EndDisplay:show(won)
	if won then
		self.text = "You won !\nThanks for playing :)"
	else
		self.text = "You lost :(\nPress [R] to restart"
	end

	Timer.tween(2, self, {alpha = 255}, "out-cubic")
end
