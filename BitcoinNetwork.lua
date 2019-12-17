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

hex = "6abc6129df7129DE"
data = fromHex(hex)
print(data)
hex2 = toHex(data)
print(hex2)
