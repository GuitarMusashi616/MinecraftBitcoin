local Transaction = {}

function Transaction:new(inputs,outputs)
  local o = {}
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

function Transaction:getSigners()
  --local tab = {[signer]=signature}
  
  --return [func() nextIter end, table, startingI]
  --for i,v in next, t

  --for i,_ in next,self.inputs
  --end
  
  
  
end

function Transaction:getInput()
  return self.inputs
end

return Transaction