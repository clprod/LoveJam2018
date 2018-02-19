Intro = Class{}

local o_ten_one = require "libs.o-ten-one"

function Intro:enter()
  self.splash = o_ten_one({background={0, 0, 0}})
  self.splash.onDone = function() GameState.switch(Game) end
end

function Intro:update(dt)
  self.splash:update(dt)
end

function Intro:draw()
  self.splash:draw()
end

function Intro:keypressed()
  self.splash:skip()
end
