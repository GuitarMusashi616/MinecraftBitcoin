local TransactionOutput = {}

function TransactionOutput:new(publicKey,value,nonce,isSpent)
  local o = {}
  o.publicKey = publicKey
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
  return self.publicKey.serialize()..", "..tostring(self.value)
end

function TransactionOutput:getPublicKey()
  return self.publicKey
end

function TransactionOutput:getNonce()
  return self.nonce
end

return TransactionOutput