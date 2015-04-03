   local tileString = [[
###########+++###########
#                       #
#                       #
#  >                >   #
#                       #
#                       #
#                       #
#                       #
#                       #
#                       #
#                       #
#                       #
#                       #
#########################
]]
--char, x, y
  local quadInfo = {
  { '+', 0,  0  }, --door
  { '#', 32,  0 }, --wall
  { ' ', 0, 32  }, --floor
  { '>', 32, 32 }, --downstairs
  { '@', 64, 0}, --player
  { 'p', 98, 0}, --worker
  { '%', 0, 98}, --corpse
  { 's', 98, 32} --skeleman
}
local imagePath = '/images/5b5.png'

return Map:new(32,32, imagePath, tileString, quadInfo)
