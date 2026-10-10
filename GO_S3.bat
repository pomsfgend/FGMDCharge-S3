@echo off
setlocal EnableExtensions
cd /d "%~dp0"
echo.
echo  FGMDCharge-S3  3.0.0  FD_ROUND_S3
echo  Blank ESP32-S3-DevKit only. This does not touch the original cube.
echo  Cube firmware stays at https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2
echo  ESP-IDF must be 5.0.9 and only 5.0.9.
echo  Bootloader is written at 0x0, not 0x1000. App is ota_0 at 0x10000.
echo  Full chip erase is not used.
echo.
if not defined PORT set /p PORT=COM port of the S3, example COM5: 
set "IDF_DIR=%USERPROFILE%\esp\esp-idf-5.0.9"
if not exist "%IDF_DIR%\export.bat" (
  echo ESP-IDF 5.0.9 not found at %IDF_DIR%
  pause
  exit /b 1
)
call "%IDF_DIR%\export.bat"
if errorlevel 1 exit /b 1
idf.py set-target esp32s3
if errorlevel 1 exit /b 1
idf.py build
if errorlevel 1 exit /b 1
if not exist "build\bootloader\bootloader.bin" exit /b 1
if not exist "build\partition_table\partition-table.bin" exit /b 1
if not exist "build\FD_ROUND_S3.bin" exit /b 1
python -m esptool --chip esp32s3 -p %PORT% -b 460800 --before default_reset --after hard_reset write_flash --flash_mode qio --flash_freq 80m --flash_size 16MB 0x0 build\bootloader\bootloader.bin 0x8000 build\partition_table\partition-table.bin 0x10000 build\FD_ROUND_S3.bin
if errorlevel 1 exit /b 1
echo.
echo  FLASH DONE. Expect READY 3.0.0 in the monitor.
echo  Wi-Fi: Cube   password 12345678   channel 6   http://192.168.4.1/
echo  Official two-port DevKit: cable in the port marked USB.
echo  One-port CH340 clone: switch the console to UART in sdkconfig.defaults first.
idf.py -p %PORT% -b 115200 monitor
exit /b 0
