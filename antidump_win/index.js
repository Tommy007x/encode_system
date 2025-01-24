// const var = process.argv[3];
// const iswatch = (process.argv[4] == 'addwatch');
// const isbuild = (process.argv[5] == 'build');

// @ on depoly
var frompath = process.argv[2];

// Function to ensure the path ends with a backslash
function ensureTrailingBackslash(path) {
	console.log(path)
    // Check if the path ends with a backslash
    if (!path.endsWith('\\')) {
        // Add a backslash if it doesn't end with one
        return path + '\\';
    }
    // Return the path as is if it already ends with a backslash
    return path;
}

if (frompath){
	// Use the function to get the updated path
	frompath = ensureTrailingBackslash(frompath);
}


const iswatch = (process.argv[3] == 'addwatch');
const isbuild = (process.argv[4] == 'build');


const {makefxmaindest, luaToJsObject} = require('./lib/fxmainfest.js')
const {encodeStrAndWrite} = require('./lib/xor.js')
const {encodeContentFromArrayPath} = require('./lib/unit.js')
const {readFile,writeFileConent, convertToFullPathsAndListFiles, IsSomeTypeNotLua, writefile, copyAllFileInFolder, splitPathAndFileName, copyFile, removeBasePath} = require('./lib/file.js')
const fs = require('fs');
const hound = require('hound')

const {writeAddonOnPath} = require('./lib/addon_write.js')
;


async function watch(path){
  
  
    setTimeout(() => {


        let src_path = path + 'src'
        src_path =  src_path.replace(/\\/g, '/')
       
        console.log('\x1b[34m[HGS] start watch file : ' + src_path);
        const watcher = hound.watch(src_path);
        let timeoutId;

        var rebuild = function (file) { 
            if (timeoutId) clearTimeout(timeoutId);
            timeoutId = setTimeout(() => {
                const now = new Date();
                const time = now.toTimeString().split(' ')[0];
        
                if (file) {
                   
                    main(path, file).catch(err => console.error(err));
                    console.log(`\x1b[33m\x1b[33m[${time}] File ${file} has been modified\x1b[0m`);
                } else {
                    console.log(`[${time}] The filename is not provided`);
                }
            }, 250); // Adjust debounce time as needed
        };

    
        watcher.on('create',rebuild)
        watcher.on('change', rebuild)
        watcher.on('delete', rebuild)

        
        
        
        
   
    
    }, 1500);
}



async function main(path, modified) {
    path = path.replace(/\\/g, '/')

    let src_path = path + 'src'
    let build_path  = path + 'build'

    if (fs.existsSync(build_path)) {
        fs.rmSync(build_path, { recursive: true });
    }

    let srcdata_fxmainfest = await readFile(src_path + '/fxmanifest.lua')
    const object_fxmainfest = luaToJsObject(srcdata_fxmainfest)
    let fxfilemanfist = []

    if (object_fxmainfest.client_scripts){
        const fullPath_client = convertToFullPathsAndListFiles(object_fxmainfest.client_scripts, src_path)
        if (!IsSomeTypeNotLua(fullPath_client)){
            return console.log("[HGS][CLIENT] Not support type not lua.")
        }
        let cbdata = await encodeContentFromArrayPath(fullPath_client, path)
        cl_enocde = cbdata[0]
        fxfilemanfist = cbdata[1];
        await encodeStrAndWrite(cl_enocde, path + 'build/user')

    }

    if (object_fxmainfest.server_scripts){
        const fullPath_server = convertToFullPathsAndListFiles(object_fxmainfest.server_scripts, src_path)
        if (!IsSomeTypeNotLua(fullPath_server)){
            return console.log("[HGS][SERVER] Not support type not lua.")
        }

        let cbdata  = await encodeContentFromArrayPath(fullPath_server, path)
        sv_enocde = cbdata[0]
        await encodeStrAndWrite(sv_enocde, build_path + '/proxy')
    }

    if (object_fxmainfest.files){
        const list_list = convertToFullPathsAndListFiles(object_fxmainfest.files, src_path)
        const spnt = splitPathAndFileName(list_list)

        spnt.forEach((str)=>{
            let nextpath = removeBasePath(src_path, str.directory)

            if (!nextpath){
                copyFile(str.fileName, str.directory,  path + '/build/') 
            }else{
                copyFile(str.fileName, str.directory,  path + '/build/' + nextpath)
            }
            
        });

    }
  
    
    if(object_fxmainfest.stream_zip == 'yes'){
        console.log("[HGS] loading stream")
        console.log(path + '/src/stream')
        copyAllFileInFolder(path + '/src/stream', path + '/stream')
    }

    await writeAddonOnPath(path + '/build')
  
    // make mainfrist
    makefxmaindest(object_fxmainfest, path , fxfilemanfist)

    if (modified){
        const now = new Date();
        const time = now.toTimeString().split(' ')[0];
        console.log(`\x1b[33m\x1b[33m[${time}] File ${modified} has been modified\x1b[0m`);
    }

}

if (isbuild){
    main(frompath).catch(err => console.error(err));
}
if (iswatch){
    watch(frompath)
}



module.exports = {
    main,
    watch,
}
