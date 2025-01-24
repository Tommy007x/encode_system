const exe = require('@angablue/exe');

const watch = exe({
    entry: './watch.js',
    out: './output/win_watch.exe',
    pkg: [ '--public'], // Specify extra pkg arguments
    version: '1.0.0',
    target: 'node18-win-x64',
    icon: './main.ico', // Application icons must be in .ico format
    properties: {
        FileDescription: '',
        ProductName: 'Script Protection',
        LegalCopyright: '2021 - 2030 © Tomranger STUDIO',
        OriginalFilename: 'win_watch.exe'
    }
});

watch.then(() => console.log('watch completed!'));


const build = exe({
    entry: './index.js',
    out: './output/win_build.exe',
    pkg: [ '--public'], // Specify extra pkg arguments
    version: '1.0.0',
    target: 'node18-win-x64',
    icon: './main.ico', // Application icons must be in .ico format
    properties: {
        FileDescription: '',
        ProductName: 'Script Protection',
        LegalCopyright: '2021 - 2030 © Tomranger STUDIO',
        OriginalFilename: 'win_build.exe'
    }
});

build.then(() => console.log('Build completed!'));




