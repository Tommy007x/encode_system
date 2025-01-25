const b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
const path = require('path');
const fs = require('fs');
const fengari = require('fengari');

const lua = fengari.lua;
const lauxlib = fengari.lauxlib;
const lualib = fengari.lualib;
const L = lauxlib.luaL_newstate();

lualib.luaL_openlibs(L);

function xorEncrypt(key, data) {
    let result = '';
    for (let i = 0; i < data.length; i++) {
        result += String.fromCharCode(data.charCodeAt(i) ^ key.charCodeAt(i % key.length));
    }
    return result;
}

// XOR decryption is symmetric
function xorDecrypt(key, data) {
    return xorEncrypt(key, data);
}

function base64Encode(data) {
    return btoa(data);
}

function base64Decode(data) {
    return atob(data);
}


function utf8ToHex(str) {
    return Buffer.from(str, 'utf8').toString('hex');
}

function hexToUtf8(hexStr) {
    return Buffer.from(hexStr, 'hex').toString('utf8');
}



function encodeStrOld(key, str, notutf8) {
    // console.log("hello")
	if (!notutf8){
		str = utf8ToHex(str)
	}
    return new Promise((resolve) => {
        const encrypted = xorEncrypt(key, str);
        const encoded = base64Encode(encrypted);
        resolve(encoded);
    });
}

function getByteInLuaStyle(str) {
    let luaCode = `
        local script = [[${str}]]
        local byte_str = {}
        for i = 1, #script do
            byte_str[#byte_str + 1] = [[\\]] .. string.byte(script, i)
        end
        return table.concat(byte_str)
    `;

    // Load the Lua code
    if (lauxlib.luaL_loadstring(L, fengari.to_luastring(luaCode)) !== lua.LUA_OK) {
        console.log("Error loading Lua script");
        console.log(lua.lua_tostring(L, -1));
    } else {
        lua.lua_call(L, 0, 1);  // 0 arguments, expect 1 return value
        const luaResult = fengari.to_jsstring(lua.lua_tostring(L, -1));  // Get the result from the Lua stack
        lua.lua_settop(L, 0);
        return luaResult;
    }
}

function xorEncryptDecrypt(input, key) {
    input = getByteInLuaStyle(input)
    const keyLen = key.length;
    let counter = 0;
    const output = [];

    for (let i = 0; i < input.length; i++) {
        const charCode = input.charCodeAt(i);
        const keyCharCode = key.charCodeAt(counter % keyLen);
        output.push(String.fromCharCode(charCode ^ keyCharCode));
        counter++;
    }

    return output.join('');
}



async function encodeStrAndWrite(str, target_path) {
    target_path = target_path.replace(/\\/g, '/')
    target_path = target_path.replace(/[\r\n]/g, '')

    var forlder = path.dirname(target_path);
    fs.mkdirSync(forlder, { recursive: true });
    
    // The binary data you want to write
    const raw = xorEncryptDecrypt(str, "XNp8w!#*2c,0VW=9")
    const encryptedText = Buffer.from(raw, 'utf-8'); // Replace with your actual data

    // Writing to the file
    await fs.writeFileSync(target_path, encryptedText, 'binary');
}

async function decodeStr(key, str, notutf8) {
    return new Promise((resolve) => {
        const decoded = base64Decode(str);
        let decrypted = xorDecrypt(key, decoded);
		if (!notutf8){
			decrypted = hexToUtf8(decrypted)
		}
        resolve(decrypted);
    });
}


module.exports = {
    encodeStrAndWrite,
    decodeStr,
    encodeStrOld
}