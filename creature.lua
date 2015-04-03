class = require 'lib.middleclass'

Creature = class('Creature')

function Creature:initialize()
  
    self.level = 1
    self.x = 0
    self.y = 0
  
    --a list of vertices 
    self.strength = 0
    self.grace = 0
    self.mind = 0
    
    self.life = 0
    self.mana = 0
    self.traits = {}
    
    --what skills, atrributes, traits, should all creatures 
    --most likely just skills
    self.skills = {
        ["weapons"] = 0,
        ["unarmed"] = 1,
        ["tactics"] = 0,
    }
    --
    self.inv = {}
    
    self.char = '+'
    self.color = {255, 255, 255, 255}
end

function Creature:addTraits(newTraits) 
  for k,v in pairs(newTraits) do 
      table.insert(self.traits, v) 
  end
end


function Creature:move(dx, dy, map) 
  --and not newMap:isSolid(self.x+dx, self.y+dy)
      if dx ~= 0 and dy ~= 0 then
        map:setForeground(self.x, self.y, ' ')
        self.x = self.x+dx
        self.y = self.y+dy
        map:setForeground(self.x, self.y, self.char)
      end
end

function Creature:getHP()
  return self.level * self.life
end

function Creature:getMP() 
  return self.level * self.mana
end

--Standard "player" subtype, elea, dwarves, Juere, Yerles
--average stats, balanced, average traits, standard slots, most skills, civil, diverse
Sapien = class('Sapien', Creature)
function Sapien:initialize()
  Creature:initialize(self, 1)
  self.addTraits({"living"})
  self.slots({
      ["head"] = nil, 
      ["neck"] = nil, 
      ["arms"] = nil,
      ["left hand"] = nil,
      ["right hand"] = nil,
      ["left ring"] = nil,
      ["right ring"] = nil,
      ["chest"] = nil,
      ["waist"] = nil,
      ["legs"] = nil,
  })
  --set skills
  self.skills.weapons = 1
end

Eulderna = class('Eulderna', Sapien)
function Eulderna:initialize()
    Creature.initialize(self, 1)
    
    self.char = '@'
    
  --add stats, trained skills, etc
    self.strength = self.strength + 10
    self.grace = self.grace + 10
    self.mind = self.mind + 10
    
    self.life = 8
    self.mana = 8
    
end

--undead subtype, zombies, skeletons, ghouls, vampires
--
Undead = class('Undead', Creature)
function Undead:initialize()
  --Stats will become zero, not good
  --Creature.initialize(self, 1)
  self.addTraits({"unholy", "undead", "evil"})
end

Skeleton = class('Skeleton', Creature)
function Skeleton:initialize()
  Undead.initialize(self, 1)
  self.addTraits({"mindless", "servant"})
end
