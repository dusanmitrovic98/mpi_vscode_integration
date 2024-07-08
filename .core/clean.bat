@echo off

if exist "..\.debug" (
    rmdir /s /q "..\.debug"
)

if exist "..\config.json" (
    del "..\config.json"
)

echo Cleanup completed.

exit