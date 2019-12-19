local Block = {}

function Block:new()
  local o = {}
  o.header = ""
  o.prevHeader = ""
  o.nonce = 1
  o.merkleRoot = ""
  o.merkleTree = {}
  o.transactions = {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function Block:insertTransaction(tx)
  table.insert(self.transactions,tx)
end

return Block