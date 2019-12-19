local component = require("component")
local DC = component.proxy(component.list("data")())
local Transaction = require("Transaction")
local BitcoinWallet = require("BitcoinWallet")
local BitcoinMiner = require("BitcoinMiner")

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

alice = BitcoinWallet:new()
bob = BitcoinWallet:new()
aparna = BitcoinWallet:new()
jing = BitcoinWallet:new()
miningTurtle = BitcoinMiner:new()

inputs = {[1]=1}
outputs = {[125]=500}
tab = {[1]=5,[2]=3,[4]=inputs,[12]="stuff",["Apple"]=12,[132]="morestruff",["Banana"]=5,["angry"]=17,["zebra"]=18}
local tx = bob:createTransaction(inputs,outputs)

--print(table.toSortedString(bob,1))
--print(tx)
bob:sign(tx)
miningTurtle:initialBlock(tx)
--print(tx)
miningTurtle:updateState()
table.toString(miningTurtle:getState(),1)
--miningTurtle:initialState(bob)
--miningTurtle:verify(tx)



--alice:sign(tx)