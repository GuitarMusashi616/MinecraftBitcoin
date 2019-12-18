local Transaction = {}

function Transaction:new(inputs,outputs)
  o = {}
  o.inputs = inputs
  o.outputs = outputs
  if #o.inputs == 0 then
    o.type = "mint"
  else
    o.type = "send"
  end
  o.signatures = {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function Transaction:addSignature(sig)
  table.insert(self.signatures,sig)
end

return Transaction