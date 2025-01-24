@echo off
echo Packaging watch.js for Linux and Windows...
pkg watch.js --targets node18-linux-x64 --output ./output/linux_watch

echo Packaging complete!
pause
