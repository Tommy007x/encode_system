const b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
const path = require('path');
// const fs = require('fs');
const fs = require('fs');


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

function xorEncryptDecrypt(input, key) {
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