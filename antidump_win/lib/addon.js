const fs = require('fs');


// Function to read a file and return its content as a buffer
function readFileAsBuffer(filePath) {
    return new Promise((resolve, reject) => {
        fs.readFile(filePath, (err, data) => {
            if (err) {
                reject(err);
            } else {
                resolve(data);
            }
        });
    });
}

function writeBufferToFile(filePath, buffer) {
    return new Promise((resolve, reject) => {
        fs.writeFile(filePath, buffer, (err) => {
            if (err) {
                reject(err);
            } else {
                resolve();
            }
        });
    });
}

module.exports = {
    readFileAsBuffer,
    writeBufferToFile
}