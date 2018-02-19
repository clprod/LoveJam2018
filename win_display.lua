WinDisplay = Class{}

function WinDisplay:init(game)
	self.alpha = 0
end

function WinDisplay:draw()
  love.graphics.setColor(0, 0, 0, self.alpha)
  love.graphics.printf("You won !\nThanks for playing :)", 0, 360, 800, "center")
end

function WinDisplay:show()
	Timer.tween(2, self, {alpha = 255}, "out-cubic")
end
