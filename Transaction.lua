local Transaction = {}

function Transaction:new(inputs,outputs)
  o = {}
  o.inputs = inputs
  o.outputs = outputs
  --o.type = "mint" or "send"
  o.signatures = {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function Transaction:addSignature(sig)
  table.insert(self.signatures,sig)
end

function Transaction:__tostring()
  return table.toSortedString(self,1)
end

return Transaction