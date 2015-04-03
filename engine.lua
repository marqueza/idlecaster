class = require 'lib.middleclass'
Engine = class('Engine')

function Engine:initialize(map, player)
  self.map = map
  self.player = player
  self.player.x, self.player.y = map.tileWidth/2, 4
  self.npcs = {}
  self.items = {}
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

function Engine:update()
    for i, npc in ipairs(self.npcs) do
      --every creature just wanders for know
      self:displace(npc, math.random(-1,1), math.random(-1,1))
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
end