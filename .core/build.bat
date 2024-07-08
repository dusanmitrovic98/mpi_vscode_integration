@echo off

pushd "%~dp0\.."
set "PARENTDIR=%CD%"
popd

set "CONFIG_FILE=config.json"
set LOGFILE="%PARENTDIR%\.debug\build.log"
set OUTDIR="%PARENTDIR%\.debug"

set VCVARS64="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
set SDK_INCLUDE="C:\Program Files (x86)\Microsoft SDKs\MPI\Include"
set MSVC_INCLUDE="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.40.33807\include"
set UCRT="C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\ucrt"
set MPI_LIB_64="C:\Program Files (x86)\Microsoft SDKs\MPI\Lib\x64"
set MSVC_LIB_64="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.40.33807\lib\x64"
set UCRT_64="C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\ucrt\x64"

if not exist "%CONFIG_FILE%" (
    echo { "NumberOfProcesses": 4 } > "%CONFIG_FILE%"
)

if not exist %OUTDIR% (
    mkdir %OUTDIR%
)

echo Building %2 > %LOGFILE%
echo Running vcvars64.bat >> %LOGFILE%
call %VCVARS64% >> %LOGFILE% 2>&1
echo Environment initialized. >> %LOGFILE%

timeout /t 2 /nobreak >nul

echo Running cl.exe >> %LOGFILE%
cl.exe /Zi /EHsc /Fo%OUTDIR%\ /Fd%OUTDIR%\vc140.pdb /Fe%OUTDIR%\main.exe %2 /I %SDK_INCLUDE% /I %MSVC_INCLUDE% /I %UCRT% /link /LIBPATH:%MPI_LIB_64% /LIBPATH:%MSVC_LIB_64% /LIBPATH:%UCRT_64% msmpi.lib >> %LOGFILE% 2>&1
echo Compilation finished. >> %LOGFILE%

if exist %OUTDIR%\main.exe (
    echo Build successful: %OUTDIR%\main.exe >> %LOGFILE%
) else (
    echo Build failed. >> %LOGFILE%
)

type %LOGFILE%

exit
