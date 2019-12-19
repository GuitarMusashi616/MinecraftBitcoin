
local BitcoinMiner = {}

function BitcoinMiner:new()
  o = {}
  
  setmetatable(o,self)
  self.__index = self
  return o
end

return BitcoinMiner