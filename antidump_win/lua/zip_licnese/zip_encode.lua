-- Function definitions as provided above


local key = "XNp8w!#*2c,0VW=9"

function stringToHex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

function hexToString(hex)
    return (hex:gsub('..', function (hh)
        return string.char(tonumber(hh, 16))
    end))
end

function xorEncryptDecrypt(input, key)
    local keyLen = #key
    local counter = 0
    local keyBytes = {key:byte(1, keyLen)}
    local output = input:gsub('.', function(c)
        counter = counter + 1
        return string.char(string.byte(c) ~ keyBytes[(counter - 1) % keyLen + 1])
    end)
    return output
end

local file = io.open("zip.lua", "rb")
local originalText = file:read("*a")
file:close()


local encryptedText = xorEncryptDecrypt(originalText, key)

local outputFile = io.open("zip", "wb")
outputFile:write(encryptedText)
outputFile:close()

