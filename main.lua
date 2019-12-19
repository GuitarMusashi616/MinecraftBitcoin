local component = require("component")
local DC = component.proxy(component.list("data")())
local Transaction = require("Transaction")
local BitcoinAddress = require("BitcoinAddress")

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
    if not vStr then
      print(vStr)
      return
    end
    str = str..'['..tostring(k)..'] = '..vStr..', '
  end
  if #str > 3 then
    str = str:sub(1,#str-2)
  end
  str = str..'}'
  return str
end

alice = BitcoinAddress:new()
bob = BitcoinAddress:new()
inputs = {[512]=250,[214]=250}
outputs = {}
tab = {}

print(table.toString(bob))

--local tx = bob:createTransaction({bob,500},{alice,250})
--printTab(tx.signatures)
--print(alice:verify(tx,bob.publicKey,tx.signatures[1]))