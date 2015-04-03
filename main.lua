local class = require 'lib.middleclass'
require 'gui'
require 'creature'
require 'map'
require 'engine'
state = require "lib.hump.gamestate"
local poll = {} 
local exec = {}

function love.load()
  --if arg[#arg] == "-debug" then require("mobdebug").start() end
  e = Engine:new(loadMap('maps/base.lua'), Eulderna:new())
  love.graphics.setBackgroundColor(0,0,0)
  state.registerEvents()
  state.switch(poll)
end


function love.draw()
  
    love.graphics.clear()
    love.graphics.setColor(255, 255, 255, 255)
    e:draw()
    e.console:draw()
end

--run the engine, then wait for next player input
function exec:update()

  e:update()
  
  e.console.stale = true
  state.switch(poll)
end

function poll:update()
  
end


--default state/screen keypress
function poll:keypressed(key)
  --This is the begging of a new "turn", so get ride of all the old messages


  
    local dx, dy = 0,0
      if key=='kp1' then dx, dy =-1, 1 endTurn()
      elseif key=='kp2' then dx, dy = 0, 1 endTurn()
      elseif key=='kp3' then dx, dy = 1, 1 endTurn()
      elseif key=='kp4' then dx, dy =-1, 0 endTurn()
      elseif key=='kp5' then dx, dy = 0, 0 endTurn()
      elseif key=='kp6' then dx, dy = 1, 0 endTurn()
      elseif key=='kp7' then dx, dy =-1,-1 endTurn()
      elseif key=='kp8' then dx, dy = 0,-1 endTurn()
      elseif key=='kp9' then  dx, dy = 1,-1 endTurn()
    end
    e:displace(e.player, dx, dy)
    if key == 'a' then
      e:spawn(Eulderna:new(), e.map.tileWidth/2, 4)
      endTurn()
      --first message of the next turn
      e.console:print("You clone yourself.")
      
    end
    if key == 'w' then
      endTurn()
      --first message of the next turn
      e.console:print("You cast word of genocide.")
      e.npcs = {}
    end
    if key == 'c' then
      e.console:print("Chat.")
    end
 
end

function endTurn () 
  
  e.console:flushRecentBuffer()
  state.switch(exec)
  
end