@echo on
SET CURRENT_DIR=%~dp0
SET ORACLE_DIR=C:\Oracle
SET ORACLE_CLIENT_VERSION=12.2.0.1.0
SET ORACLE_CLIENT_DIR=instantclient_12_2

SET ORACLE_HOME=%ORACLE_DIR%\%ORACLE_CLIENT_DIR%
SET CLIENT_TMP_DIR=%ORACLE_DIR%\client
SET SDK_TMP_DIR=%ORACLE_DIR%\sdk

if not exist "%ORACLE_DIR%" (
    md "%ORACLE_DIR%"
)
call "%CURRENT_DIR%utils\zipjs.bat" unzip -source "%CURRENT_DIR%instantclient-sdk-windows.x64-%ORACLE_CLIENT_VERSION%.zip" -destination "%SDK_TMP_DIR%"
call "%CURRENT_DIR%utils\zipjs.bat" unzip -source "%CURRENT_DIR%instantclient-basiclite-windows.x64-%ORACLE_CLIENT_VERSION%.zip" -destination "%CLIENT_TMP_DIR%"
MOVE "%CLIENT_TMP_DIR%\%ORACLE_CLIENT_DIR%" "%ORACLE_DIR%"
MOVE "%SDK_TMP_DIR%\%ORACLE_CLIENT_DIR%\sdk" "%ORACLE_DIR%\%ORACLE_CLIENT_DIR%"
RD /S /Q "%CLIENT_TMP_DIR%"
RD /S /Q "%SDK_TMP_DIR%"

MD "%ORACLE_HOME%\network"
MD "%ORACLE_HOME%\network\admin"
xcopy /Y "%CURRENT_DIR%TNSNAMES.ORA" "%ORACLE_HOME%\network\admin"
xcopy /Y "%CURRENT_DIR%oci8_windows_amd64.pc" "%ORACLE_HOME%\oci8.pc*"

WHERE choco
IF %ERRORLEVEL% NEQ 0 (
    REM Install Chocolatey
    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
)
choco install -y msys2
C:\tools\msys64\usr\bin\bash.exe -l -c "pacman -Syu --noconfirm --ask=20 mingw-w64-x86_64-gcc mingw64/mingw-w64-x86_64-pkg-config git"

SETX ORACLE_HOME %ORACLE_HOME%
SETX OCI_LIB %ORACLE_HOME%\sdk\lib
SETX TNS_ADMIN %ORACLE_HOME%\network\admin
SETX PKG_CONFIG %ORACLE_HOME%

pathed /APPEND C:\tools\msys64\mingw64\bin /USER
pathed /APPEND C:\tools\msys64\usr\bin /USER