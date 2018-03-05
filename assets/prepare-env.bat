@echo off
SET CURRENT_DIR=%~dp0

"%CURRENT_DIR%utils\elevate.exe" -k "%CURRENT_DIR%setup.bat"
