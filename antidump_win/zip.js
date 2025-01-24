
const {encodeStrOld, decodeStr} = require('./lib/xor.js');

const fs = require('fs');
const key = "XN,NzZwi2pMK(w7qp8w!#*2c,0VW=9";

// fs.readFile('source/hgs_emotes/soruce_zip.lua', 'utf8', async (err, data) => {
fs.readFile('source/soruce_zip.lua', 'utf8', async (err, data) => {
    if (err) {
        console.error(err);
        return;
    }
	
	const encoded = await encodeStrOld(key, data, true);

	fs.writeFile('zip', encoded, (err) => {
		if (err) {
			console.error(err);
			return;
		}
		console.log('File written successfully');
	});
		
});
