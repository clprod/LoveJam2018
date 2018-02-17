GameState = require "libs.hump.gamestate"
Class = require "libs.hump.class"
Vector = require "libs.hump.vector"
require "states.game"
Camera = require "libs.hump.camera"
Timer = require "libs.hump.timer"

function love.load(args)
   love.window.setTitle("LoveJam-2018")
   love.graphics.setBackgroundColor(255, 255, 255)
   
   GameState.registerEvents()
   
   GameState.switch(Game)
end
