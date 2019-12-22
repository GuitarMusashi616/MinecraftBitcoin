local component = require("component")
local DC = component.proxy(component.list("data")())
local Transaction = require("Transaction")
local BitcoinWallet = require("BitcoinWallet")
local BitcoinMiner = require("BitcoinMiner")
local Block = require("Block")

-- Converts binary data into hexadecimal string.
function toHex(data)
  return (data:gsub('.', function (c)
    return string.format('%02X', string.byte(c))
    end))
end
 
-- Converts hexadecimal string into binary data.
function fromHex(hex)
  return (hex:gsub('..', function (cc)
    return string.char(tonumber(cc, 16))
    end))
end

function testHex()
  local hex = "6abc6129df7129DE"
  local data = fromHex(hex)
  print(data)
  local hex2 = toHex(data)
  print(hex2)
end

function printTab(table)
  for i,v in pairs(table) do
    io.write(i)
    io.write(": ")
    print(v)
  end
end

function table:toString(recursive)
  local str = '{'
  for k,v in pairs(self) do
    local vStr = tostring(v)
    if type(v) == "table" and recursive then
      vStr = table.toString(v)
    end
    str = str..'['..tostring(k)..'] = '..vStr..', '
  end
  if #str > 3 then
    str = str:sub(1,#str-2)
  end
  str = str..'}'
  return str
end

function table:toSortedString(recursive)
  local str = '{'
  local alpha = {}
  local numerical = {}
  for index in pairs(self) do
    if type(index) == "number" then
      table.insert(numerical,index)
    elseif type(index) == "string" then
      table.insert(alpha,index)
    else
      error(type(index))
    end
  end
  table.sort(alpha)
  table.sort(numerical)
  local getStr = function(tab,index,recursive)
    local vStr = tostring(tab[index])
    if type(tab[index]) == "table" and recursive then
      vStr = table.toSortedString(tab[index],recursive)
    end
    return vStr
  end  
  for _,index in pairs(numerical) do
    str = str..'['..tostring(index)..'] = '..getStr(self,index,recursive)..', '
  end
  for _,index in pairs(alpha) do
    str = str..'['..tostring(index)..'] = '..getStr(self,index,recursive)..', '
  end
  if #str > 3 then
    str = str:sub(1,#str-2)
  end
  str = str..'}'
  return str
end

function table:sumValue()
  local sum = 0
  for k,v in pairs(self) do
    if type(v) == "number" then
      sum = sum + v
    end
  end
  return sum
end

function testTransactionCreateSign()
  local alice = BitcoinWallet:new()
  local bob = BitcoinWallet:new()
  local aparna = BitcoinWallet:new()
  local jing = BitcoinWallet:new()
  local miningTurtle = BitcoinMiner:new()

  local inputs = {[1]=1}
  local outputs = {[125]=500}
  local tx = bob:createTransaction(inputs,outputs)
  bob:sign(tx)
  print(tx)
  
end

function testState()
  local bob = BitcoinWallet:new()
  local miningTurtle = BitcoinMiner:new()
  miningTurtle:initialState(bob)
  print(miningTurtle.state[1][1])
end

function testBlock()
  local alice = BitcoinWallet:new()
  local bob = BitcoinWallet:new()
  local miningTurtle = BitcoinMiner:new()
  miningTurtle:initialState(bob)
  print("init state",miningTurtle.state[1][1])
  
  local inputs = {[1]=1}
  local outputs = {[alice.address] = 500}
  local tx = bob:createTransaction(inputs,outputs)
  bob:sign(tx)
  
  local block = Block:new()
  block:insertTransaction(tx)
  
  miningTurtle.blockchain[1] = block
  print("blockchain",miningTurtle.blockChain[1])
  local ithState = 1
  --miningTurtle.processTransaction(tx)
  --if miningTurtle:verify(input[1])
  --inputs[1] = 1 --check nonce
  
  --applying transaction to current state to get next state
  local nonce = miningTurtle.state[ithState][1]:getNonce()
  print(nonce)
  if nonce ~= miningTurtle.blockchain[1].transactions[1].inputs[1] then
    return --mismatched nonce
  end
  local address = miningTurtle.state[ithState][1]:getAddress()
  print(address)
  local signature = miningTurtle.blockchain[1].transactions[1].signatures[1]
  local pubKey = miningTurtle.blockchain[1].transactions[1].publicKeys[1]
  local data = tostring(miningTurtle.blockchain[1].transactions[1])
  
  print(miningTurtle:verifySignature(data,pubKey,signature))
  --ok the sigs are valid, time to check money
  local totalOutput = table.sumValue(miningTurtle.blockchain[1].transactions[1].outputs)
  print(totalOutput)
  local totalAvailable = miningTurtle.state[ithState][1].value
  print(totalAvailable)
  if totalAvailable > totalOutput then
    --remainder goes to miner's fees
  elseif totalAvailable < totalOutput then
    return --insufficient funds
  end
  --last step is process the transaction
  --miningTurtle.blockChain[1].transactions[1].outputs --hash,value
  --TransactionOutput:new(hash,value)
  
end


function testMerkleRoot()
  --make 11 txs in 3rd block of chain
  --put them in one block
  --merklfy the block (hash up)
  miner = BitcoinMiner:new()
  bob = BitcoinWallet:new()
  alice = BitcoinWallet:new()
  aparna = BitcoinWallet:new()
  jing = BitcoinWallet:new()
  miner:initialState(bob)
  print("miner: ",table.toString(miner))
  print("state: ",miner.state[1])
  local block = Block:new()
  --[txid]=nonce, [address]=amount2send
  local tx1 = Transaction:new( {{1,1}} , {{alice.address,100},{bob.address,400} })
  bob:sign(tx1)
  block:insertTransaction(tx1)
  
  local tx2 = Transaction:new({{3,2}},{{aparna.address,150},{bob.address,250}})
  bob:sign(tx2)
  block:insertTransaction(tx2)
  
  local tx3 = Transaction:new({{5,3}},{{jing.address,250}})
  bob:sign(tx3)
  block:insertTransaction(tx3)
  
  print("block: ",block.transactions[1])
  miner:addBlock(block)
  print("blockchain: ",miner.blockchain[1].transactions[1])
  print("state: ",miner.state[1])
  miner:updateState()
  print(table.toString(miner.balances))
  --miner:listUnspent()
  --local balances = miner:getBalances()
  
  
end

--verify all unique signers
--testTransactionCreateSign()
--testBlock()
testMerkleRoot()
