@echo off
echo Packaging watch.js for Linux and Windows...
pkg index.js --targets node18-linux-x64 --output ./output/linux_build

echo Packaging complete!
pause
