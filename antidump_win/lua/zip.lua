
local safeguard = {}
local rname = GetCurrentResourceName()
	
	
safeguard.startTime =  (os and os.clock()) or GetGameTimer()
safeguard.b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

safeguard.color = function(color)
	local colors = {
		none = '\27[0m',
		black = '\27[0;30m',
		red = '\27[0;31m',
		green = '\27[0;32m',
		yellow = '\27[0;33m',
		blue = '\27[0;34m',
		magenta = '\27[0;35m',
		cyan = '\27[0;36m',
		white = '\27[0;37m',
		Black = '\27[1;30m',
		Red = '\27[1;31m',
		Green = '\27[1;32m',
		Yellow = '\27[1;33m',
		Blue = '\27[1;34m',
		Magenta = '\27[1;35m',
		Cyan = '\27[1;36m',
		White = '\27[1;37m',
		_black = '\27[40m',
		_red = '\27[41m',
		_green = '\27[42m',
		_yellow = '\27[43m',
		_blue = '\27[44m',
		_magenta = '\27[45m',
		_cyan = '\27[46m',
		_white = '\27[47m'
	}

	return colors[color]
end


safeguard.splitStringByNewline = function(str)
	local lines = {}
	for line in string.gmatch(str, "([^\n]+)") do
		table.insert(lines, line)
	end
	return lines
end


safeguard.decodeStr = function(input)
	local key = "XNp8w!#*2c,0VW=9"
	local keyLen = #key
    local counter = 0
    local keyBytes = {key:byte(1, keyLen)}
	
    local output = input:gsub('.', function(c)
        counter = counter + 1
        return string.char(string.byte(c) ~ keyBytes[(counter - 1) % keyLen + 1])
    end)
	

	local interpreted = output:gsub("\\(%d+)", function(code)
		return string.char(code)
	end)

    return interpreted
end



safeguard.loads = function(script, filename)
	
	if not script then
		if IsDuplicityVersion() then
			print(("%s[HGS][%s][SEXY] File not found : %s"):format(
				safeguard.color("red"),
				safeguard.color("none")..safeguard.color("_red")..string.upper(rname)..safeguard.color("red"),
				filename..safeguard.color("none")
			))
		else
			print(("^9[HGS][%s][SEXY] Error executing script : %s"):format(
				string.upper(rname),
				filename
			))
		end
		return
	end
	
	local chunkName = "@" .. filename
	
	
	local compiled_function, error_message = load(script, chunkName or "unknow")

	if compiled_function then
		local success, result = pcall(compiled_function)
		if not success then
			if IsDuplicityVersion() then
				print(("%s[HGS][%s][SEXY] Error executing script : %s"):format(
					safeguard.color("red"),
					safeguard.color("none")..safeguard.color("_red")..string.upper(rname)..safeguard.color("red"),
					result..safeguard.color("none")
				))
			else
				print(("^9[HGS][%s][SEXY] Error executing script : %s"):format(
					string.upper(rname),
					result
				))
			end
		end
	else
	
		if IsDuplicityVersion() then
			print(("%s[HGS][%s][SEXY] Error loading script : %s"):format(
				safeguard.color("red"),
				safeguard.color("none")..safeguard.color("_red")..string.upper(rname)..safeguard.color("red"),
				error_message..safeguard.color("none")
			))
		else
			print(("^9[HGS][%s][SEXY] Error loading script : %s"):format(
				string.upper(rname),
				error_message
			))
		end
	end

end

safeguard.splitPath = function(path)
    -- Attempt to match paths starting with "@"
    local project, filePath = path:match("@([^/]+)(/.+)")
    if not project or not filePath then
        -- Attempt to match paths not starting with "@"
        project, filePath = path:match("([^/]+)/(.+)")
    end
    if project and filePath then
        return project, filePath
    else
        return nil, nil
    end
end

safeguard.splitArray = function(array)
    local result = {}
    for i=1, #array, 2 do
        table.insert(result, {array[i], array[i+1]})
    end
    return result
end

safeguard.split = function(str, step, temp)
    local temp = temp or {}
    local start, stop = str:find(step)
    if not start or not stop then
		  if str and string.len(str) > 0 then
			   table.insert(temp, str)
		  end
		  return temp 
    end
    local cut = str:sub(1, start - 1)

    if string.len(cut) > 0 then
		
        table.insert(temp, cut)
    end
    local nextstr = str:sub(stop + 1, #str)
    
    return safeguard.split(nextstr, step, temp)
end

safeguard.loadChunk = function(resource, chunk, path)
	chunk = "build/chunk/"..chunk
	local code = LoadResourceFile(resource, chunk)
	if code then
		local content = safeguard.decodeStr(code)
		safeguard.loads(content, path)
	else
		if IsDuplicityVersion() then
			print(("%s[HGS][%s][SEXY] script not found : %s"):format(
				safeguard.color("red"),
				safeguard.color("none")..safeguard.color("_red")..string.upper(rname)..safeguard.color("red"),
				path..safeguard.color("none")
			))
		else
			print(("^9[HGS][%s][SEXY] script not found : %s"):format(
				string.upper(rname),
				path
			))
		end
	end
end


safeguard.Tick = function(content)
	local content = safeguard.decodeStr(content)
	
	
	local tabel = safeguard.split(content, "~~~")
	local maxlist = #tabel

	
	if maxlist % 2 > 0 then
		if IsDuplicityVersion() then
			print(("%s[HGS][%s][SEXY] Error Max List"):format(
				safeguard.color("red"),
				safeguard.color("none")..safeguard.color("_red")..string.upper(rname)..safeguard.color("red")
			))
		else
			print(("^9[HGS][%s][SEXY] Error Max List"):format(
				string.upper(rname)
			))
		end
		return
	end
	
	
	
	for k,v in pairs(safeguard.splitArray(tabel)) do 
		local filename = v[1]
		v[2] = string.gsub(v[2], " ", "")
		local chunk = "chunk-"..v[2] .. ".png"
	

		filename = string.gsub(filename, " ", "")
		
		local resource, path = safeguard.splitPath(filename)
	
		if string.find(filename, "@") then -- share
			if not (GetResourceMetadata(resource, 'zip') == 'yes') then
				local shpath = path:sub(2, #path)
				local code = LoadResourceFile(resource, shpath)
				if code then
					safeguard.loads(code, filename)
				end
			else
				safeguard.loadChunk(resource, chunk, filename)
			end
		else
			safeguard.loadChunk(resource, chunk, filename)
		end
	end
end

safeguard.timnow = (os and os.clock()) or GetGameTimer()
if (safeguard.timnow - safeguard.startTime) <= 10 then
	safeguard.timnow  = safeguard.timnow + math.random(10, 136)
end

	
if IsDuplicityVersion() then


	local content = LoadResourceFile(rname, 'build/proxy')
	safeguard.Tick(content)
	print(("%s[HGS] %s %s"):format(
		safeguard.color("yellow"),
		safeguard.color("none")..safeguard.color("_magenta")..string.upper(rname)..safeguard.color("none"),
		safeguard.color("yellow").."unziping.. "..safeguard.color("none")
	))
		
	
else
	
	local content = LoadResourceFile(rname, 'build/user')
	safeguard.Tick(content)
	print(("^3[HGS][%s]^0 %s"):format(
		string.upper(rname),
		"unziping.. "
	))
	
end


if IsDuplicityVersion() then
	print(("%s[HGS] %s %s %s"):format(
		safeguard.color("yellow"),
		safeguard.color("none")..safeguard.color("_magenta")..string.upper(rname)..safeguard.color("none"),
		safeguard.color("yellow").."unzip successfully.. "..safeguard.color("none"),
		safeguard.color("blue").. math.floor(safeguard.timnow - safeguard.startTime) .. " ms"
	)) 
else
	print(("^3[HGS][%s]^0 %s"):format(
		string.upper(rname),
		"unzip successfully.. ^5" .. (safeguard.timnow - safeguard.startTime) .. " ms"
	))
end

