local bump = require "libs.bump.bump"

require "crystal"
require "player"
require "enemy_base"

Game = {}

function Game:enter (previous)
   self.world = bump.newWorld()

   -- camera looking at (100,100) with zoom 1 and rotate by 0 deg
   self.camera = Camera(100,100, 1, 0)

   self.crystal = Crystal(self)
   self.player = Player(self)

   self.enemies = {}
   table.insert(self.enemies, EnemyBase(self, Vector(25, 25)))
   table.insert(self.enemies, EnemyBase(self, Vector(35, 25)))
   table.insert(self.enemies, EnemyBase(self, Vector(45, 25)))
   table.insert(self.enemies, EnemyBase(self, Vector(500, 100)))
   table.insert(self.enemies, EnemyBase(self, Vector(400, 550)))
end

function Game:update(dt)
   self.crystal:update(dt)
   self.player:update(dt)

   for k,enemy in pairs(self.enemies) do
      enemy:update(dt)
   end
end

function Game:draw()
   self.crystal:draw()
   self.player:draw()

   for k,enemy in pairs(self.enemies) do
      enemy:draw()
   end
end
