const fs = require('fs');
const path = require('path');
const { promisify } = require('util');
const readFileAsync = promisify(fs.readFile);

function removeLuaComments(str) {
    // Remove multi-line comments
    str = str.replace(/--\[\[(.*?)\]\]/gs, '');
    // Remove single-line comments
    str = str.replace(/--.*/g, '');
    return str;
}

async function readFile(filePath) {
    try {
        let data = await readFileAsync(filePath, { encoding: 'utf8' });

        data = removeLuaComments(data)
        // console.log(data)
        return data
    } catch (error) {
        console.error(`[HGS] file not found: ${filePath}`);
        return false
    }
}


function listFilesInDirectory(basePath, subPath = '', fileType = '') {
    const fullPath = path.join(basePath, subPath);
    let filesList = [];

    if (fs.existsSync(fullPath)) {
        fs.readdirSync(fullPath).forEach(file => {
            const filePath = path.join(fullPath, file);
            const stat = fs.statSync(filePath);

            if (stat.isDirectory()) {
                filesList = filesList.concat(listFilesInDirectory(basePath, path.join(subPath, file), fileType));
            } else {
                if (fileType === '' || path.extname(file) === `.${fileType}`) {
                    filesList.push(filePath);
                }
            }
        });
    }

    return filesList;
}

function getFileTypes(filePaths) {
    return filePaths.map(filePath => {
        return path.extname(filePath).slice(1); // Remove the leading dot from the extension
    });
}

function IsSomeTypeNotLua(list){
    let type = getFileTypes(list)

    for (const [key, value] of Object.entries(type)) {
        if (value != 'lua'){
            return false
        }
    }
    return true
}

function convertToFullPathsAndListFiles(paths, rootPath) {
    let filesList = [];

    paths.forEach(relativePath => {
        // Include paths starting with '@' as is
        if (relativePath.startsWith('@')) {
            filesList.push(relativePath);
            return;
        }

        // Handling wildcards
        if (relativePath.includes('**')) {
            const directoryPath = relativePath.replace('**', '');
            filesList = filesList.concat(listFilesInDirectory(rootPath, directoryPath));
        } else if (relativePath.includes('*.lua')) {
            const directoryPath = relativePath.replace('*.lua', '');
            filesList = filesList.concat(listFilesInDirectory(rootPath, directoryPath, 'lua'));
        } else {
            filesList.push(path.join(rootPath, relativePath));
        }
    });

    return filesList;
}

function writefile(folderPath, filename, content) {
    if (!fs.existsSync(folderPath)){
        fs.mkdirSync(folderPath, { recursive: true });
    }

    fs.writeFile(folderPath + '/'+  filename, content, (err) => {
        if (err) {
            console.error('[HGS] Error writing file:' + folderPath);
        } else {
            console.log(`[HGS] File written successfully ${folderPath}`);
        }
    });
}

function writeFileConent(folderPath, filename, copyfrom) {
    // Check if the folder exists; if not, create it
    if (!fs.existsSync(folderPath)){
        fs.mkdirSync(folderPath, { recursive: true });
    }

    // Read the content from the source file first
    fs.readFile(copyfrom, (readErr, content) => {
        if (readErr) {
            console.error(`[HGS] Error reading source file: ${copyfrom}`);
            return; // Stop execution if there's an error reading the file
        }

        // If read is successful, write content to the new file
        fs.writeFile(folderPath + '/' + filename, content, (writeErr) => {
            if (writeErr) {
                console.error(`[HGS] Error writing file: ${folderPath}/${filename}`);
            } else {
                console.log(`[HGS] File written successfully to ${folderPath}/${filename}`);
                // After successful write, remove the original file
                fs.unlink(copyfrom, (unlinkErr) => {
                    if (unlinkErr) {
                        console.error(`[HGS] Error removing file: ${copyfrom}`);
                    } else {
                        console.log(`[HGS] Original file removed successfully: ${copyfrom}`);
                    }
                });
            }
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


async function copyFile(file, sourceDir, destDir ) {
    const sourceFilePath = path.join(sourceDir, file);
    const destFilePath = path.join(destDir, file);


    const exists = await isFileExist(sourceFilePath);
    if (!exists){
        console.log(`File not found : ${sourceFilePath}`);
        return
    }

    if (!fs.existsSync(destDir)){
        fs.mkdirSync(destDir, { recursive: true });
    }




    fs.copyFileSync(sourceFilePath, destFilePath);
    console.log(`Copied ${file} to ${destDir}`);
}


function copyAllFileInFolder(sourceDir, destDir ){

    fs.readdir(sourceDir, (err, files) => {
        if (err) {
            console.error('Error reading source directory:', err);
            return;
        }
    
        files.forEach(file => {
            copyFile(file, sourceDir, destDir );
        });
    });
}

function splitPathAndFileName(filePaths) {
    return filePaths.map(filePath => {
        return {
            directory: path.dirname(filePath),
            fileName: path.basename(filePath)
        };
    });
}

function removeBasePath(basePath, fullPath) {
    // Normalize paths by replacing backslashes with forward slashes and fixing double slashes
    const normalizePath = path => path.replace(/\\/g, '/').replace(/\/\/+/g, '/');

    // Normalize both paths
    const normalizedBasePath = normalizePath(basePath);
    const normalizedFullPath = normalizePath(fullPath);
    if (normalizedBasePath == normalizedFullPath){
        return false
    }


    // Append a forward slash to normalizedBasePath if not present
    const basePathFinal = normalizedBasePath.endsWith('/') ? normalizedBasePath : normalizedBasePath + '/';

    // Check if the fullPath contains the basePath
    if (normalizedFullPath.startsWith(basePathFinal)) {
        // Remove basePath and return the rest of the fullPath
        return normalizedFullPath.substring(basePathFinal.length);
    } else {
        // If basePath is not part of fullPath, return fullPath as is
        return fullPath;
    }
}


module.exports = {
    readFile,
    convertToFullPathsAndListFiles,
    getFileTypes,
    writefile,
    copyAllFileInFolder,
    copyFile,
    writeFileConent,
    splitPathAndFileName,
    removeBasePath,
    IsSomeTypeNotLua
}