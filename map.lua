class = require 'lib.middleclass'

--local tileW, tileH, tileset, quads, background --local global variables
Map =  class('Map')
function Map:initialize(tileWidth, tileHeight, tilesetPath, tileString, quadInfo)
  
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight
  self.tileset = love.graphics.newImage(tilesetPath)
  
  local tilesetW, tilesetH = self.tileset:getWidth(), self.tileset:getHeight()
  
  self.quads = {}
  self.background = {}
  self.foreground = {}

  --decode the input quadInfo
  for _,info in ipairs(quadInfo) do
    -- info[1] = the character, used as the key
    -- info[2] = x, 
    -- info[3] = y
    self.quads[info[1]] = love.graphics.newQuad(info[2], info[3], self.tileWidth,  self.tileHeight, tilesetW, tilesetH)
  end
  
 
 local width = #(tileString:match("[^\n]+"))

  for x = 1,width,1 do 
    self.background[x] = {} 
    self.foreground[x] = {}
  end

  --write contents of string onto the tileTabl
  local x,y = 1,1
  --newline is a delimiter
  for row in tileString:gmatch("[^\n]+") do
    --error message
    assert(#row == width, 'Map is not aligned: width of row ' .. tostring(y) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
    
    --row is good, now go through column
    x = 1
    for tile in row:gmatch(".") do
      --write char from string to tileTale
      self.background[x][y] = tile
      self.foreground[x][y] = Creature:new()
      x = x + 1
    end
    y=y+1
  end

end

function loadMap(path)
  return love.filesystem.load(path)() --runs a chunk of code
end

function Map:setForeground(x, y, creature)
    self.foreground[x][y] = creature
end

function Map:isSolid(x, y)
  return (self.background[x][y] == '#') or 
        (self.background[x][y] == '+')
end

function Map:draw()
  
  --draw the floors and walls
  for columnIndex, column in ipairs(self.background) do
    for rowIndex, char in ipairs(column) do
      local x,y = (columnIndex-1)*self.tileWidth, (rowIndex-1)*self.tileHeight
      love.graphics.draw(self.tileset, self.quads[char], x, y)
    end
  end
end