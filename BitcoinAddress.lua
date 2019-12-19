local BitcoinAddress = {}
local component = require("component")
local DC = component.proxy(component.list("data")())
local Transaction = require("Transaction")

function BitcoinAddress:new()
  o = {}
  o.publicKey,o.privKey = DC.generateKeyPair()
  o.nonce = 0
  setmetatable(o,self)
  self.__index = self
  return o
end

function BitcoinAddress:createTransaction(inputs,outputs)
  local tx = Transaction:new(inputs,outputs)
  return tx
end

function BitcoinAddress:sign(data)
  return DC.ecdsa(data,self.privKey)
end

function BitcoinAddress:verify(data,publicKey,signature)
  return DC.ecdsa(data,publicKey,signature)
end

function BitcoinAddress:__tostring()
  return table.toString(self,1)
end

return BitcoinAddress