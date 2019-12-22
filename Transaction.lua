local Transaction = {}

function Transaction:new(inputs,outputs)
  --Transaction:new{ inputs={ [txid]=nonce } , outputs={ [address]=amount } }
  local o = {}
  o.inputs = inputs
  o.outputs = outputs
  --o.type = "mint" or "send"
  o.signatures = {}
  o.publicKeys = {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function Transaction:addSignature(sig,publicKey)
  table.insert(self.signatures,sig)
  table.insert(self.publicKeys,publicKey)
end

function Transaction:__tostring()
  return table.toSortedString(self,1)
end

function Transaction:getSignatures()
  
  local i = 0
  return function()
    i = i + 1
    return self.signatures[i],self.publicKeys[i]
  end
  
  --local tab = {[signer]=signature}
  
  --return [func() nextIter end, table, startingI]
  --for i,v in next, t

  --for i,_ in next,self.inputs
  --end
  
end

function Transaction:getTransactionOutputs()
  
end

function Transaction:getTXIDs()
  local n = 0
  return function()
    n = n + 1
    --{ {1,1} {2,1} }
    if self.inputs[n] then
      return self.inputs[n][1],self.inputs[n][2]
    end
  end
end

function Transaction:getOutputAddresses()
  local i = 0
  return function()
    i = i + 1
    if self.outputs[i] then
      return self.outputs[i][1],self.outputs[i][2]
    end
  end
end

function Transaction:getOutputValue()
  local outputValue = 0
  for address,amount in self:getOutputAddresses() do
    outputValue = outputValue + amount
  end
  return outputValue
end

function Transaction:getInput()
  return self.inputs
end

return Transaction