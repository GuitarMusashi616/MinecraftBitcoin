local BitcoinAddress = {}
local component = require("component")
local DC = component.proxy(component.list("data")())
local Transaction = require("Transaction")

function BitcoinAddress:new()
  o = {}
  o.publicKey,o.privateKey = DC.generateKeyPair()
  o.nonce = 0
  setmetatable(o,self)
  self.__index = self
  return o
end

function BitcoinAddress:createTransaction(inputs,outputs)
  local tx = Transaction:new(inputs,outputs)
  return tx
end

function BitcoinAddress:sign(tx)
  local sig = DC.ecdsa(tostring(tx),self.privateKey) or error("signature not valid")
  tx:addSignature(sig)
end

function BitcoinAddress:verify(data,publicKey,signature)
  return DC.ecdsa(data,publicKey,signature)
end

function BitcoinAddress:incrementNonce()
  self.nonce = self.nonce + 1
end

function BitcoinAddress:getPublicKey()
  return self.publicKey
end

function BitcoinAddress:__tostring()
  --return table.toString(self,1)
  return self.publicKey.serialize()
end

return BitcoinAddress