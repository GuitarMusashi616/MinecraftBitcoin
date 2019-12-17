local BitcoinAddress = {}
local component = require("component")
local DC = component.proxy(component.list("data")())

function BitcoinAddress:new()
  o = {}
  o.publicKey,o.privKey = DC.generateKeyPair()
  setmetatable(o,self)
  self.__index = self
  return o
end

a,b = DC.generateKeyPair()
print(a.serialize())
print(b.serialize())