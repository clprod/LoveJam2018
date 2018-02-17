Crystal = Class{}

Crystal.width, Crystal.height = 50, 50

function Crystal:init(game)
  self.type = 'crystal'
  self.hp = 5
  self.game = game
  game.world:add(self, love.graphics.getWidth()/2 - Crystal.width/2, love.graphics.getHeight()/2 - Crystal.height/2, Crystal.width, Crystal.height)
end

function Crystal:update(dt)
end

function Crystal:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", love.graphics.getWidth()/2 - Crystal.width/2, love.graphics.getHeight()/2 - Crystal.height/2, Crystal.width, Crystal.height)
end


function Crystal:loseHp(hpNb)
  self.hp = self.hp - hpNb
  if self.hp == 0 then
    self.game:gameOver()
  end
end
