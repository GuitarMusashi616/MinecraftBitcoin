local State = {}

function State:new()
  local o = {}
  o.history = {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function State:update(tx)
  State[#State+1] = tx
  TransactionOutput:new()
end

return State