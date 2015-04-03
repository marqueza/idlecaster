Item = class('Item')

function Item:initialize(name, char)
  self.name = name
  self.char = char
  self.x = 0
  self.y = 0
  self.color = {255, 255, 255, 255}
end