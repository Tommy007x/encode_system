
const {readFile, removeBasePath} = require('../lib/file.js')
const {encodeStrAndWrite} = require('../lib/xor.js')
const path = require('path');


function extractLastFolderName(path) {
    // Remove trailing slash if it exists
    if (path.endsWith('\\') || path.endsWith('/')) {
        path = path.slice(0, -1);
    }

    // Split the path and filter out empty parts
    const parts = path.split(/[/\\]/).filter(Boolean);
    
    // Return the last part if available, otherwise return an empty string
    return parts.length > 0 ? parts[parts.length - 1] : '';
}

function deleteLastLine(text) {
    let lines = text.split('\n'); // Split the string by newline characters
    lines.pop(); // Remove the last element of the array
    return lines.join('\n'); // Join the array back into a string
}


function hash(input) {
    let hash1 = 0xdeadbeef ^ input.length;
    let hash2 = 0x41c6ce57 ^ input.length;
    
    for (let i = 0; i < input.length; i++) {
        const char = input.charCodeAt(i);
        hash1 = Math.imul(hash1 ^ char, 2654435761);
        hash2 = Math.imul(hash2 ^ char, 1597334677);
    }
    
    hash1 = (hash1 ^ (hash1 >>> 16)) >>> 0;
    hash2 = (hash2 ^ (hash2 >>> 13)) >>> 0;
    
    // Use BigInt constructor for compatibility with older versions
    const bigIntHash = (BigInt(hash1) << BigInt(32)) + BigInt(hash2); // Use BigInt constructor
    
    return bigIntHash.toString(16); // Convert the BigInt to a hexadecimal string
}


async function encodeContentFromArrayPath(list, frompath, isproxy) {
   
    let array = []
    
    if (!isproxy){
        isproxy = "user"
    }else{
        isproxy = "proxy"
    }

    let fxfile = []
    for (const [key, value] of Object.entries(list)) {


        if (value.includes('@')){

            console.log('[HGS][PUSH][SHARE] : '+ value);
            let hashname = await hash(value.substring(1, value.length) + "_" + isproxy)
            hashname = hashname.replace(/[\n\s]+/g, '');
            hashname = String(hashname)
            array.push(`${value}~~~${hashname}~~~`)
        }else{
            let content = await readFile(value)
            if (content){
                let scriptname = extractLastFolderName(frompath)
                scriptname = `${scriptname}/` + removeBasePath(frompath +'src/', value)
                let hashname = await hash(scriptname + "_" + isproxy)
                hashname = String(hashname)
                let filepath = frompath + "build\\chunk\\chunk-" + hashname + ".png"
         
    
                await encodeStrAndWrite(content, filepath)
           
                hashname = hashname.replace(/[\n\s]+/g, '');
                console.log('[HGS][PUSH] : '+ value);
                array.push(`${scriptname}~~~${hashname}~~~`)
                fxfile.push(`chunk-${hashname}.png`)
            }
        }
       
    }


    let proxy = ""
	array.forEach((str)=>{
		proxy = proxy + str
	});


    return [proxy, fxfile]

}

module.exports = {
    encodeContentFromArrayPath,

}