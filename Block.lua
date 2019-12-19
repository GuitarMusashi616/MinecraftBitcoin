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

function Block:__tostring()
  local str = ""
  for i,v in pairs(self.transactions) do
    str = str..tostring(v).." "
  end
  return str
end

return Block