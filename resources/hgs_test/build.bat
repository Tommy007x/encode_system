@echo off
REM Step 1: Check if the folder named 'resource' exists in the current directory path

REM Extract the current directory path
setlocal enabledelayedexpansion
set currentPath=%cd%

REM Split the current path using backslashes and reconstruct the path up to 'resource'
set "resourcePath="
set "foundResource=0"
for %%I in (%currentPath:\= %) do (
    if "%%I"=="resources" (
        set "foundResource=1"
        goto foundResource
    )
    set "resourcePath=!resourcePath!%%I\"
)

:foundResource
if %foundResource%==1 (
    REM Remove the trailing backslash
    set "resourcePath=%resourcePath:~0,-1%"
    REM echo %resourcePath%antidump\build.exe %~dp0 addwatch build
	
	REM Run build.exe located in the resource path with additional arguments
    "%resourcePath%\antidump\win_build.exe" %~dp0 addwatch build
) else (
    echo Error: The folder 'resources' does not exist in the current directory path.
)
endlocal

pause