local BitcoinMiner = {}
local component = require("component")
local DC = component.proxy(component.list("data")())
local TransactionOutput = require("TransactionOutput")
local Block = require("Block")


function BitcoinMiner:new()
  local o = {}
  o.state = {}                                                     
  o.nonces = {}
  o.blockchain = {}
  o.ithState = 1
  setmetatable(o,self)
  self.__index = self
  
  return o
end

function BitcoinMiner:verifySignature(data,publicKey,signature)
  return DC.ecdsa(data,publicKey,signature)
end

function BitcoinMiner:getUniqueAddresses(tx)

  
  --return {[address]=1,[address2]=3}
end

function BitcoinMiner:verify(tx)
  
  --find owners of addresses in inputs
  --for each owner check their signature
  --check the nonce
  local verifiedAddresses = {}
  local spendable = true
  local nonceMatches = true
  local hasValidSignatures = true
  local hasEnoughCoins = true
  
  --process signatures
  for signature,publicKey in tx:getSignatures() do
    print("sig: ",signature,"pubKey: ",publicKey.serialize())
    if self:verifySignature(tostring(tx),publicKey,signature) then
      local address = DC.sha256(publicKey.serialize())
      verifiedAddresses[address] = true
    end
  end
  
  local sumIn = 0
  for txid,nonce in tx:getTXIDs() do
    local utxo = self.state[txid]
    
    if utxo.isSpent then
      error("transaction output is already spent")
      spendable = false
    end
    
    --start address at nonce 1 if not in nonce table
    if not miner.nonces[utxo:getAddress()] then
      miner.nonces[utxo:getAddress()] = 1
    end
    
    if nonce ~= miner.nonces[utxo:getAddress()] then
      error("nonce does not match")
      nonceMatches = false
      --could be wrong order (shouldn't though because transactions are numbered in blockchain)
    end
    
    if not verifiedAddresses[utxo:getAddress()] then
      error("address is missing valid signature")
      hasValidSignatures = false
    end
    
    --get output sum

    sumIn = sumIn + utxo:getValue()
    --if verifiedAddresses[utxo:getAddress()] then signature is check
    --check has cash
    --check nonce
  end
  local sumOut = tx:getOutputValue()
  if sumOut > sumIn then
    error("txOutputValue > txInputValue")
    hasEnoughCoins = false
  elseif sumOut < sumIn then
    print(tostring(sumIn-sumOut).." BTC is going towards miners fees")
  end
  --make sure each input address has the specified amount of cash
  if spendable and nonceMatches and hasValidSignatures and hasEnoughCoins then
    return true
  else
    return false
  end
end

function BitcoinMiner:initialState(owner)
  table.insert(self.state,TransactionOutput:new(owner:getAddress(),500))
end

function BitcoinMiner:initialBlock(tx)
  local newBlock = Block:new()
  newBlock:insertTransaction(tx)
  table.insert(self.blockchain,newBlock)
end

function BitcoinMiner:updateState()
  for _,block in ipairs(self.blockchain) do
    for _,tx in ipairs(block.transactions) do
      --self.state[self.ithState] = {}
      if self:verify(tx) then
        print("verified: ",tx)
        for txid,nonce in tx:getTXIDs() do
          local txo = self.state[txid]
          txo:setSpent(true)
          self.nonces[txo:getAddress()] = self.nonces[txo:getAddress()]+1
          --self.state[txid]
        end
        for address,value in tx:getOutputAddresses() do
          table.insert(self.state,TransactionOutput:new(address,value))
        end
        --self.ithState = self.ithState + 1
        --self.state[1] = 1
        --self.utxos[1] = false
        
        --for utxo in tx:getOutputTransactions() do
         -- 
        --end
      end
      --if self:verify(tx) then
      --end
      
      --get inputIter from tx
      --self.state[self.ithState][inputIter].publicKey
      --self.state[self.ithState][inputIter].amount
      
      --get outputIter from tx
      
      
      --for i,v in pairs(tx:getInput()) do
        --get owner from tx
        --get amount from tx
        
      --end
      
      
      
      --table.insert(self.state[self.ithState],TransactionOutput:new(tx,500))
    end
  end
end

function BitcoinMiner:addBlock(block)
  self.blockchain[#self.blockchain+1] = block
end

function BitcoinMiner:getState()
  return self.state
end

function BitcoinMiner:add2TransactionPool(tx)
  --self:verifyTransaction(tx)
  --table.insert(self.transactionPool,tx)
end

return BitcoinMiner