Crystal = Class{}

Crystal.width, Crystal.height = 50, 50

function Crystal:init(game)
  game.world:add(self, love.graphics.getWidth()/2 - Crystal.width/2, love.graphics.getHeight()/2 - Crystal.height/2, Crystal.width, Crystal.height)
end

function Crystal:update(dt)
end

function Crystal:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", love.graphics.getWidth()/2 - Crystal.width/2, love.graphics.getHeight()/2 - Crystal.height/2, Crystal.width, Crystal.height)
end
