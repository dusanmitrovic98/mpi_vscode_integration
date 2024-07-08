@echo off
setlocal enabledelayedexpansion

set "CONFIG_FILE=..\\config.json"
set "OUTPUT_FILE=..\\.debug\\output.txt"

if not exist "%CONFIG_FILE%" (
    echo { "NumberOfProcesses": 4 } > "%CONFIG_FILE%"
)

for /f "tokens=2 delims=:}" %%a in ('findstr /c:"NumberOfProcesses" "%CONFIG_FILE%"') do (
    set "NumberOfProcesses=%%a"
)

set "EXECUTABLE=..\\.debug\\main.exe"

if exist "%EXECUTABLE%" (
    echo Number Of Processes: !NumberOfProcesses!
    echo Running MPI program...
    echo =================================================================
    
    if exist "%OUTPUT_FILE%" (
        del "%OUTPUT_FILE%"
    )

    mpiexec -n !NumberOfProcesses! "%EXECUTABLE%" >> "%OUTPUT_FILE%"
    type "%OUTPUT_FILE%"
) else (
    echo Error: Executable "%EXECUTABLE%" not found. Please build the program first.
    exit /b 1
)

endlocal
