class = require 'lib.middleclass'
--global constants
fontsize = 16
mouseX = 0
mouseY = 0


   --sidemenu = Menu:new(0,0, {"blah", "gasp", "rasp", "clasp", "gasp", "rasp", "clasp"}) 

--[[
Class: Rect
A four sided area and parent class.
]]--
Rect = class('Rect')

function Rect:initialize(vertices)
    --a list of vertices 
    --{x1, y1, 
    --x1, y2, 
    --x2, y2, 
    --x2, y1}
    self.vertices = vertices 
    self.x1 = self.vertices[1]
    self.x2 = self.vertices[7]
    self.y1 = self.vertices[2]
    self.y2 = self.vertices[4]

    self.height = vertices[2] - vertices[4]
    self.width = vertices[1] - vertices[7]

end

--[[
function: draw
displays the rectangle
]]--
function Rect:draw()
    love.graphics.polygon('fill', vertices)
end

--[[
function: draw
Returns true if coordinates are inside rectangle
]]--
function Rect:isInside(x, y)
    return x > self.x1 and x < self.x2 and y > self.y1 and y < self.y2
end

--[[
class: Menu
Vertical text menu
]]--
Menu = class('Menu', Rect) 
function Menu:initialize(x1, y1, textList)
    self.textList = textList or {"Item1", "Item2"}

    self.x1 = x1 or 0
    self.y1 = y1 or 0
    self.y2 = self.y1 + fontsize
    self.x2 = self.x1 + (100)

    --a list of vertices 
    --{x1, y1, 
    --x1, y2, 
    --x2, y2, 
    --x2, y1}
    self.vertices = {
                    self.x1, self.y1, 
                    self.x1, self.y2, 
                    self.x2, self.y2, 
                    self.x2, self.y1}

    self.height = self.y2 - self.y1 
    self.width =  self.x2 - self.x1
    self.midX = self.width/2+self.x1
    self.midY = self.height/2+self.y1
    self.panelList = {}

    --define panel list, based on amount of strings and font size
    for index,value in ipairs(self.textList) do 
        local offset = index - 1
        local panel = Rect:new ({
            self.x1, fontsize*offset+self.y1,
            self.x1, fontsize*(offset)+self.y2,
            self.x2, fontsize*(offset)+self.y2,
            self.x2, fontsize*offset+self.y1,
        })
        table.insert(self.panelList, panel)
    
    end
end
    --self.draw, lets draw some panels
function Menu:draw() 
        love.graphics.setColor(000, 255, 300, 255)
        love.graphics.polygon('fill', self.vertices)
    for i, panel in ipairs(self.panelList) do 
        if (panel:isInside(love.mouse.getX(), love.mouse.getY())) then
            if love.mouse.isDown("l") then
                love.graphics.setColor(0, 0, 200, 255)
            else 
                love.graphics.setColor(200, 0, 0, 255)
            end
        else
            love.graphics.setColor(50, 0, 0, 255)
        end
        --panel:draw()
        love.graphics.polygon('fill', panel.vertices)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf(self.textList[i], panel.x1, panel.y1 , self.width, 'center')
    end
end

--called when a mouse has been released, or if enterkey was released (must have been selected in some way)
function Menu:activatePanel()
  
  for i, panel in ipairs(self.panelList) do 
    if (panel:isInside(love.mouse.getX(), love.mouse.getY())) then
         --preform active action here
         --depending on subtype, other functions will be called
         --default action is print text related to each panel
         mainConsole:print(self.textList[i])
         
        love.graphics.print("Text", 600, 300)
         --probably flush out new
    end
  end
end
    --a list of vertices 
    --{x1, y1, 
    --x1, y2, 
    --x2, y2, 
    --x2, y1}
Console = class('Menu', Console) 
function Console:initialize()
    self.vertices = { 0, 3/4*love.graphics.getHeight(),
                    0, love.graphics.getHeight()-20,
                    love.graphics.getWidth(), love.graphics.getHeight()-20,
                    love.graphics.getWidth(), 3/4*love.graphics.getHeight()}
    self.x1 = self.vertices[1]
    self.x2 = self.vertices[7]
    self.y1 = self.vertices[2]
    self.y2 = self.vertices[4]
    
    self.height = self.y2 - self.y1 
    self.width =  self.x2 - self.x1
    
    self.recentBuffer = ""
    self.buffer = ""
    self.stale = false
end

function Console:print(message)
  --place new content in recentBuffer
  self.recentBuffer =  self.recentBuffer .. message .. " "
end

function Console:flushRecentBuffer()
      if self.stale then 
      --move old content into the main buffer
      self.buffer = self.buffer .. self.recentBuffer 
   
      --empty recentbuffer
      self.recentBuffer =  ""
    end
 end

function Console:draw()
  
  --console background
  love.graphics.setColor(000, 000, 000, 255)
  love.graphics.polygon('fill', self.vertices)
  
  --old messages have a faded color
  love.graphics.setColor(0, 255, 255, 255)
  s = "\n" .. self.buffer  
  love.graphics.printf(s, self.x1, self.y1 , self.width, 'left')
  love.graphics.setColor(255, 255, 255, 255)
  
  --last turn's message has an accented color
  love.graphics.setColor(255, 255, 255, 255)
  --love.graphics.print(#self.recentBuffer, love.graphics.getWidth(), 0)
  local s =self.recentBuffer
  love.graphics.printf(s, self.x1, self.y1 , self.width, 'left')
  
end