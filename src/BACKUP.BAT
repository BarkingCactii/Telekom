echo off
echo Archiving MDL source 
del src.zip
pkzip -P -x*.zip src *.* >nul
pkzip -aP src rsc\*.* >nul
pkzip -aP src docs\*.* >nul
del runtime.zip
echo Archiving RUNTIME files
pkzip -P runtime c:\win32app\ustation\mdlapps\place.* >nul
pkzip -aP runtime c:\win32app\ustation\wsmod\default\cell\place.* >nul

echo Archiving Data files
del data.zip
pkzip data data\*.lst >nul
xcopy *.zip a:\ /V
echo done!
