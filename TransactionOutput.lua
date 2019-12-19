local TransactionOutput = {}

function TransactionOutput:new(publicKey,value,isSpent)
  local o = {}
  o.publicKey = publicKey
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

function TransactionOutput:__tostring()
  return self.publicKey.serialize()
end

return TransactionOutput