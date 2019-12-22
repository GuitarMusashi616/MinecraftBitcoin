local BitcoinWallet = {}
local component = require("component")
local DC = component.proxy(component.list("data")())
local Transaction = require("Transaction")

function BitcoinWallet:new()
  local o = {}
  o.publicKey,o.privateKey = DC.generateKeyPair()
  o.address = DC.sha256(o.publicKey.serialize())
  o.nonce = 1
  setmetatable(o,self)
  self.__index = self
  return o
end

function BitcoinWallet:createTransaction(inputs,outputs)
  local tx = Transaction:new(inputs,outputs)
  return tx
end

function BitcoinWallet:sign(tx)
  local sig = DC.ecdsa(tostring(tx),self.privateKey) or error("signature not valid")
  tx:addSignature(sig,self.publicKey)
end

function BitcoinWallet:verify(data,publicKey,signature)
  return DC.ecdsa(data,publicKey,signature)
end

function BitcoinWallet:incrementNonce()
  self.nonce = self.nonce + 1
end

function BitcoinWallet:getPublicKey()
  return self.publicKey
end

function BitcoinWallet:getAddress()
  return self.address
end

function BitcoinWallet:__tostring()
  --return table.toString(self,1)
  return self:getAddress()
end

return BitcoinWallet