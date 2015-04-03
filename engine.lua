class = require 'lib.middleclass'
Engine = class('Engine')

function Engine:initialize(map, player)
  self.map = map
  self.player = player
  self.player.x, self.player.y = map.tileWidth/2, 4
  self.npcs = {}
  self.items = {}
  self.invMenu = nil
  self.console = Console:new()
end

function Engine:displace(enitity, dx, dy)
  --move across map if space is not solid
  if not self.map:isSolid(enitity.x+dx, enitity.y+dy) then
    enitity.x = enitity.x+dx
    enitity.y = enitity.y+dy
  else 
    self.console:print("*bump*")
  end
end

function Engine:spawnCreature(enitity, x, y)
  table.insert(self.npcs, enitity)
  local spawned = self.npcs[#self.npcs]
  spawned.x, spawned.y = x, y
  --spawned.color = {0, 255, 255, 255}
end

function Engine:spawnItem(enitity, x, y)
  table.insert(self.items, enitity)
  local spawned = self.items[#self.items]
  spawned.x, spawned.y = x, y
  spawned.color = {155, 255, 255, 255}
end

--Removes item from item table, and returns the value
function Engine:getItem(x, y)
    local index = 0
    local retrieved
    for i, item in ipairs(self.items) do 
      if (item.x == x and item.y == y) then
        index = i
        retrieved = item
      end
    end
  table.remove(e.items, index)
  return retrieved
end

function Engine:spawnInventoryMenu()
  --if not self.invMenu then return end
  local menuList = {}
    for i, item in ipairs(self.player.inv) do
      local offset = i-1
      local char = string.char(97+offset)
      menuList[i] = char.." "..item.name
    end
    self.invMenu = Menu:new(0,0,menuList)
end

function Engine:update()
    for i, npc in ipairs(self.npcs) do
      --every creature just wanders for know
      if math.random(0,5) == 0 then
        self:displace(npc, math.random(-1,1), math.random(-1,1))
      end
    end
  end
  
function Engine:draw()
    self.map:draw()
    --draw creatures over the map

    --draw all the items on the floor
    for i, c in ipairs(self.items) do
      local x,y = (c.x-1)*self.map.tileWidth, (c.y-1)*self.map.tileHeight-1
      love.graphics.setColor(c.color)
      love.graphics.draw(self.map.tileset, self.map.quads[c.char], x, y)
    end

    --draw all the creatures
    for i, c in ipairs(self.npcs) do
      local x,y = (c.x-1)*self.map.tileWidth, (c.y-1)*self.map.tileHeight-1
      
      love.graphics.setColor(c.color)
      love.graphics.draw(self.map.tileset, self.map.quads[c.char], x, y)
    end
    
    --now player
    love.graphics.setColor(255, 255, 255, 255)
    local x,y = (self.player.x-1)*self.map.tileWidth-1, (self.player.y-1)*self.map.tileHeight-1
    love.graphics.draw(self.map.tileset, self.map.quads[self.player.char], x, y)
    
    --active menus
    if self.invMenu then
      self.invMenu:draw()
    end
end