local BitcoinNetwork = {}

function BitcoinNetwork:new()
  local o = {}
  setmetatable(o,self)
  self.__index = self
  return o
end

return BitcoinNetwork