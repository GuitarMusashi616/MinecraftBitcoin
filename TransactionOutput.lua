local TransactionOutput = {}

function TransactionOutput:new(owner,value,isSpent)
  local o = {}
  o.owner = owner
  o.value = value
  o.isSpent = isSpent or 0
  setmetatable(o,self)
  self.__index = self
  return o
end

function TransactionOutput:isSpent()
  return self.isSpent
end

function TransactionOutput:setSpent(isSpent)
  o.isSpent = isSpent
end

return TransactionOutput