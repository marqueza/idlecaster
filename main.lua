
require 'gui'
require 'creature'
require 'map'
require 'engine'
require 'item'
local class = require 'lib.middleclass'
local state = require "lib.gamestate"
local poll = {} 
local exec = {}
local inventoryExamine = {}
local inventoryDrop = {} 

function love.load()
  --if arg[#arg] == "-debug" then require("mobdebug").start() end
  e = Engine:new(loadMap('maps/base.lua'), Eulderna:new('@'))
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
      e:spawnCreature(Eulderna:new('@'), e.map.tileWidth/2, 4)
      endTurn()
      --first message of the next turn
      e.console:print("You clone yourself.")  
    end
    
    
     if key == 'r' then
      e:spawnCreature(Eulderna:new('p'), e.map.tileWidth/2, 4)
      endTurn()
      --first message of the next turn
      e.console:printFlush("You recuit a servant.")
    end
    
    
    if key == 'w' then
      endTurn()
      --first message of the next turn
      e.console:printFlush("You cast word of genocide.")
      --removes all npcs
      e.npcs = {}
    end
    
    
    if key == 'q' then
      endTurn()
      --first message of the next turn
      e.console:printFlush("You create a corpse.")
      e:spawnItem(Item:new("corpse", '%'), e.player.x, e.player.y)
    end
    
    --pick up a item
    if key == 'g' then
      
      --search if there are items in this location
      local item = e:getItem(e.player.x, e.player.y)
      
      if (item ~= nil) then
        e.console:printFlush("You pick up a " ..item.name)
        --transfer the item from floor to inventory
        table.insert(e.player.inv, item) 
        
      end
      
    end
    
    --make a skelton
    if key == 's' then
      endTurn()
      
      --search if there are items in this location
      local item = e:getItem(e.player.x, e.player.y)
      
      if (item ~= nil and item.name == "corpse") then
        e.console:printFlush("You pick animate a skelton")
        e:spawnCreature(Eulderna:new('s'), item.x, item.y)
      end
    end
    
    if key == 'c' then
      e.console:print("Chat.")
    end
    
    if key == 'i' then
      if (e.player.inv[1]) then
      e:spawnInventoryMenu()
      state.switch(inventoryExamine)
      end
    end
    
    if key == 'd' then
      if (e.player.inv[1]) then
        e.console:print("Drop which item?")
        e:spawnInventoryMenu()
        state.switch(inventoryDrop)
      end
    end
 
end

--pressing a letter should print the description of the item
function inventoryExamine:keypressed()
  e.invMenu = nil
  --do not end turn
  state.switch(poll)
end

---use the first char to help remove item using ascii trickery and indexing
function inventoryDrop:keypressed(key)
  
  for i, selection in ipairs(e.invMenu.textList) do
    --the first letter of the menu time will be used
    local letter = string.sub(selection, 1, 1)
    --in this case, "i" is the index of the inventory that is of interest
    if key == letter then
       e.console:printFlush("Dropping!")
      --place on floor
      local object = e.player.inv[i]
      object.x, object.y = e.player.x, e.player.y
      table.insert(e.items, object)
      --remove from inventory
      table.remove(e.player.inv, i)
      --now close the inv and end turn 
      e.invMenu = nil
      state.switch(exec)
      return
    end
  end
  ---other keys should exit and return back to poll state
  e.invMenu = nil
  state.switch(poll)
end

function endTurn () 

  state.switch(exec)
  
end
