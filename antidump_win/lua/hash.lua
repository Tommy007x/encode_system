local data = io.read("*a")  -- Reads the entire input until EOF


function hash(str)
    local h = 5381
    local strlen = #str -- Cache the string length
    for i = 1, strlen do
        local c = str:byte(i) -- Directly get byte value
        -- Using a large prime number as the modulo base to extend the range
        h = ((h << 5) + h + c) % 9223372036854775807 -- Close to the maximum positive value for 64-bit integer
    end
    -- Convert the hash number to a hexadecimal string
    return string.format("%x", h)
end



local hashKey = hash(data)
print(hashKey)
