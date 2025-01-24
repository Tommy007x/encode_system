const {writefile} = require('../lib/file.js')

function luaToJsObject(luaString) {
    const lines = luaString.split('\n').filter(line => !line.trim().startsWith('--'));
    const result = {};
    let currentKey = '';
    let tempClientScripts = [];
    let tempServerScripts = [];

    lines.forEach(line => {
        // Check for key-value pairs
        if (line.includes("'") && !line.trim().endsWith('{') && !currentKey) {
            const parts = line.split("'");
            const key = parts[0].trim();
            const value = parts[1];
            // Handle multiple client_script and server_script entries
            if (key === 'client_script') {
                tempClientScripts.push(value);
            } else if (key === 'server_script') {
                tempServerScripts.push(value);
            } else {
                result[key] = value;
            }
        }
        // Check for array start
        else if (line.trim().endsWith('{')) {
            currentKey = line.split(' ')[0].trim();
            result[currentKey] = []; // Initialize if not already present
        } 
        // Check for array end
        else if (line.trim() === '}') {
            if (currentKey === 'client_scripts') {
                result[currentKey] = tempClientScripts.concat(result[currentKey].map(v => v.replace(/['"]+/g, '')));
            } else if (currentKey === 'server_scripts') {
                result[currentKey] = tempServerScripts.concat(result[currentKey].map(v => v.replace(/['"]+/g, '')));
            }
            currentKey = '';
        } 
        // Process array elements
        else if (currentKey && line.trim()) {
            result[currentKey].push(line.trim().replace(/,$/, '').replace(/['"]+/g, ''));
        }
    });

    return result;
}


function makefxmaindest(object, frompath, client_chunk){
    let str = '--LAST KIDS TRIED TO CRACK THIS GOT 2 CHOPSTICKS RIGHT INTO THEY HOLE ASS 🥢👶🤸'

    if (!object.files){
        object.files = []
    }

    if (object.client_scripts){
        for (const [key, value] of Object.entries(client_chunk)) {
            object.files.push('chunk' + '/' + value)
        }
        object.files.push('user')
    }
  
    object.files.push('zip')
    

    for (const [key, value] of Object.entries(object)) {
        let type = typeof value
        let temp = '' 
        if (type == "object"){
            if (key == 'client_scripts'){
                str  = str + `\nclient_script 'build/sexy.lua'`
            }else if (key == 'server_scripts'){
                str  = str + `\nserver_script 'build/sexy.lua'`
            }else if (key == 'server_export'){
                str  = str + `\nserver_export '${value}'`
            }else if (key == 'export'){
                str  = str + `\nexport '${value}'`
            }else{
                let add = 'build/'
                if (key == 'exports' 
                || key == 'export' 
                || key == 'server_exports' 
                || key == 'dependencies' 
                || key == 'server_export'){
                    add = ''
                }
                for (const [k, v] of Object.entries(value)) {
                    temp = temp + ` '${add}${v}',\n`
                }

                str  = str + `\n${key} {\n${temp}}`
            }
        }else if(key == 'ui_page' && !value.includes('http')){
            str = str + `\n${key} 'build/${value}'` 
		}else if(key == 'loadscreen' && !value.includes('http')){
            str = str + `\n${key} 'build/${value}'`
        }else{
            str = str + `\n${key} '${value}'`
        }
    }

    
    str = str + `\nzip 'yes'`
    writefile(frompath, 'fxmanifest.lua', str)

}

module.exports = {
    luaToJsObject,
    makefxmaindest
}