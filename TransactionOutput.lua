local TransactionOutput = {}

function TransactionOutput:new(address,value,nonce,isSpent)
  local o = {}
  o.address = address
  o.value = value
  o.isSpent = isSpent or false
  o.nonce = nonce or 1
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
  return self.address..", "..tostring(self.value)..", "..tostring(self.nonce)..", "..tostring(self.isSpent)
end

function TransactionOutput:getAddress()
  return self.address
end

function TransactionOutput:getNonce()
  return self.nonce
end

function TransactionOutput:getValue()
  return self.value
end

return TransactionOutput