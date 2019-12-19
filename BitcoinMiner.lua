local BitcoinMiner = {}
local component = require("component")
local DC = component.proxy(component.list("data")())
local TransactionOutput = require("TransactionOutput")
local Block = require("Block")


function BitcoinMiner:new()
  local o = {}
  o.state = {}
  o.blockChain = {}
  o.ithState = 1
  setmetatable(o,self)
  self.__index = self
  
  return o
end

function BitcoinMiner:verifySignature(publicKey,signature)
  DC.ecdsa(publicKey,signature)
end

function BitcoinMiner:verify(tx)
  
  --find owners of addresses in inputs
  --for each owner check their signature
  --check the nonce
  --for signer,signature in tx:getSigners() do
    --print(signer)
    --print(signature)
    --self:verifySignature(tostring(tx),signer.getPublicKey(),signature)
  --end
  
  --check signatures
  for i,v in pairs(tx:getInput()) do
    io.write(i)
    io.write(" ")
    print(v)
    print(self.state[self.ithState][i].owner)
    
    --local strAddress = ""
    --local publicKey = {isPublic = function() return true end,serialize = function() return strAddress end}  
    --state[i].owner
  end
  
  
  --make sure each input address has the specified amount of cash
  
end

function BitcoinMiner:initialState(owner)
  local txOutputs = {}
  table.insert(txOutputs,TransactionOutput:new(owner,500))
  table.insert(self.state,txOutputs)
end

function BitcoinMiner:initialBlock(tx)
  local newBlock = Block:new()
  newBlock:insertTransaction(tx)
  table.insert(self.blockChain,newBlock)
end

function BitcoinMiner:updateState()
  for _,block in ipairs(self.blockChain) do
    for _,tx in ipairs(block.transactions) do
      self.state[self.ithState] = {}
      table.insert(self.state[self.ithState],tx)
    end
  end
end

function BitcoinMiner:getState()
  return self.state
end


function BitcoinMiner:add2TransactionPool(tx)
  --self:verifyTransaction(tx)
  --table.insert(self.transactionPool,tx)
end

return BitcoinMiner