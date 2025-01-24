const fs = require('fs');
const path = require('path');
const {main, watch} = require('./index.js')

function isCategoryFivem(file) {
    return file.startsWith('[') && file.endsWith(']');
}

function GetAllFolderListInFivemResource(directoryPath, callback) {
    let list = [];
    fs.readdir(directoryPath, (err, files) => {
        if (err) {
            return callback(err);
        }

        let pending = files.length;
        if (!pending) return callback(null, list); // no files found

        files.forEach(file => {
            let filePath = path.join(directoryPath, file);
            fs.stat(filePath, (err, stats) => {
                if (err) {
                    return callback(err);
                }

                if (stats.isDirectory()) {
                    if (isCategoryFivem(file)) {
                        // console.log(filePath + ' - Category FiveM');
                        GetAllFolderListInFivemResource(filePath, (err, res) => {
                            list = list.concat(res);
                            if (!--pending) callback(null, list);
                        });
                    } else {
                        // console.log(filePath + ' - Regular Directory');
                        list.push(filePath);
                        if (!--pending) callback(null, list);
                    }
                } else {
                    if (!--pending) callback(null, list);
                }
            });
        });
    });
}

async function isFileExist(src) {
    return new Promise((resolve) => {
        fs.stat(src, (err, stats) => {
            if (err) {
                // Resolve to false if there's an error (e.g., file doesn't exist)
                resolve(false);
            } else {
                // Resolve to true if the file exists
                resolve(true);
            }
        });
    });
}

try {
    const path = require('path');
  
    // Check if running inside a packaged app
    const resourcePath = process.pkg
      ? path.join(process.cwd(), '..', 'resources')  // In a packaged app, go up one level and access 'resource'
      : path.join(__dirname, '..', 'resources');  // In development, use the relative path
  
    GetAllFolderListInFivemResource(resourcePath, async (err, list) => {
        if (err) {
            console.error('Error: ', err);
        } else {
            for (const src of list) {
               
                const exists = await isFileExist(src + `/src/fxmanifest.lua`);
                if (exists){
                    main(src + "/")
                    watch(src + "/")
                }
            }
        }
    });
    
} catch (error) {
    console.error('An unexpected error occurred:', error);
}

  
process.stdin.setRawMode(true);
process.stdin.resume();
process.stdin.on('data', () => process.exit());
