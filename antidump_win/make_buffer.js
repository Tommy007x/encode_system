const {readFileAsBuffer, writeBufferToFile} = require('./lib/addon.js')

async function makebuffer(hex) {
    let data_buff = await readFileAsBuffer('./addon/sexy.lua')
    const hexEncoded = data_buff.toString('hex');
    writeBufferToFile('./buffer/sexy.lua.txt', hexEncoded)


    let data_buff2 = await readFileAsBuffer('./addon/zip')
    const hexEncoded2 = data_buff2.toString('hex');
    writeBufferToFile('./buffer/zip', hexEncoded2)
}
makebuffer()

