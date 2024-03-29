local component = {}

local dataCard = {}

function dataCard.generateKeyPair()
  return {isPublic = function() return true end,serialize = function() return "171jRrUNvXetKCJRNK49z8Cyr5iq2ABFQF" end}, {isPublic = function() return false end,serialize = function() return "Ky1gnW3imxU8tUpvWAU9ZgZZbJGL8BvGADEWkjPyg4xwiCjYsA5e" end}
end

--sign or verify data
function dataCard.ecdsa(data,key,sig)
  io.write("dataCard.ecdsa(")
  io.write(data)
  io.write(", ")
  io.write(tostring(key.serialize()))
  io.write(", ")
  io.write(tostring(sig))
  print(")")
  if not key or not data then
    error("key and data required")
  end
  if key.isPublic() then
    if not sig then
      error("key is public, signature required")
    end
    return true
  else
    return "02D20BBD7E394AD5999A4CEBABAC9619732C343A4CAC99470C03E23BA2BDC2BC"
  end
end

function dataCard.sha256(data)
  io.write("dataCard.sha256(")
  io.write(data)
  print(")")
  return "A871C47A7F48A12B38A994E48A9659FAB5D6376F3DBCE37559BCB617EFE8662D"
end

function component.proxy()
  return dataCard
end

function component.list()
  return function()
    return
  end
end

return component