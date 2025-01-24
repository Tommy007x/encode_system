-- Read data from standard input
local data = io.read("*a")  -- Reads the entire input until EOF

split = function(str, step, temp)
    local temp = temp or {}
    local start, stop = str:find(step)
    if not start or not stop then
          if str then
               table.insert(temp, str)
          end
          return temp 
    end
    local cut = str:sub(1, start - 1)

    if string.len(cut) > 0 then
        table.insert(temp, cut)
    end
    local nextstr = str:sub(stop + 1, #str)
    
    return split(nextstr, step, temp)
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

local data = split(data, "&&&")
local filepath = data[1]
local key = data[2]
local code = data[3]



local encryptedText = xorEncryptDecrypt(code, key)
filepath = filepath:gsub("\n", "")

function formatFilePath(inputPath)
    if inputPath == nil then
        error("Input path is nil.")
    end
    local formattedPath = inputPath:gsub("\\", "\\\\"):gsub("/", "\\\\")
    return formattedPath
end

filePath = formatFilePath(filepath)


local folderPath = filePath:match("^(.+\\)[^\\]+\\?$")
local command = string.format("if not exist \"%s\" mkdir \"%s\"", folderPath, folderPath)
os.execute(command)



local file, err = io.open(filePath, "wb") -- wb สำคัญ
if not file then
    error("Could not open file for writing: " .. err)
else
    file:write(encryptedText)
    file:close()
    print("File written successfully")
end

