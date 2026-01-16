@echo off
setlocal EnableDelayedExpansion
title CIMIDI v6 - FINAL CMD EDITION
color 0b

:: --- 1. YONETICI KONTROLU ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [!] DAYI, YONETICI OLARAK CALISTIRMAN LAZIM!
    echo [!] Sag tikla 'Yonetici Olarak Calistir' de.
    echo.
    pause
    exit
)

:: --- 2. SISTEM BILGILERINI CEKME (WMI) ---
for /f "tokens=2 delims==" %%A in ('wmic cpu get name /value') do set "CPU_NAME=%%A"
for /f "tokens=2 delims==" %%B in ('wmic computersystem get TotalPhysicalMemory /value') do set "RAM_BYTES=%%B"
:: RAM'i kabaca GB'a cevir (Bytes / 1073741824) - CMD'de matematik zordur, yaklasik deger aliyoruz string kirparak
set "RAM_GB=%RAM_BYTES:~0,-9%" 
for /f "tokens=2 delims==" %%C in ('wmic path win32_videocontroller get name /value') do set "GPU_NAME=%%C"

:MENU
cls
echo.
echo ======================================================================
echo                 CIMIDI v6 - CMD FINAL KOMUTA MERKEZI
echo ======================================================================
echo  ISLEMCI : %CPU_NAME%
echo  RAM     : ~%RAM_GB% GB
echo  EKRAN K : %GPU_NAME%
echo ----------------------------------------------------------------------
echo.
echo    1. FPS ve Oyun Ayarlari (GameBar Kapat, GPU Oncelik)
echo    2. Guc Plani (Nihai Performans - Ultimate)
echo    3. Sistem Temizligi (Temp, DNS, Cop Dosyalar)
echo    4. Mouse Fix (Ivme Kapat - Raw Input)
echo    5. Network Fix (Ping ve Lag Azaltma)
echo    6. Debloat (Gereksiz Uygulamalari Sil - Win10/11)
echo    7. Yapiskan Tuslari Kapat (Shift sorunu)
echo.
echo    ---------------------------------------------------
echo    99. HEPSINI UYGULA (FULL BAKIM - TAVSIYE EDILEN)
echo    0.  CIKIS
echo ======================================================================
echo.
set /p secim="Secimin nedir dayi? (Numara yaz Enter'a bas): "

if "%secim%"=="1" goto FPS_AYAR
if "%secim%"=="2" goto GUC_AYAR
if "%secim%"=="3" goto TEMIZLIK
if "%secim%"=="4" goto MOUSE_FIX
if "%secim%"=="5" goto NET_FIX
if "%secim%"=="6" goto DEBLOAT
if "%secim%"=="7" goto STICKY
if "%secim%"=="99" goto FULL_BAKIM
if "%secim%"=="0" exit
goto MENU

:FPS_AYAR
echo.
echo [*] Game Bar kapatiliyor ve GPU onceligi ayarlaniyor...
:: GameBar Registry
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul
:: GPU Oncelik (System Profile)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
echo    [OK] FPS ayarlari tamamlandi.
timeout /t 2 >nul
goto MENU

:GUC_AYAR
echo.
echo [*] Nihai Performans (Ultimate) Modu aciliyor...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
echo    [OK] Guc plani degistirildi.
timeout /t 2 >nul
goto MENU

:TEMIZLIK
echo.
echo [*] Cop dosyalar siliniyor...
:: Temp Klasorleri
del /s /f /q %temp%\*.* >nul 2>&1
rd /s /q %temp% >nul 2>&1
mkdir %temp% >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
:: DNS Flush
ipconfig /flushdns >nul
echo    [OK] Disk ve Internet onbellegi temizlendi.
timeout /t 2 >nul
goto MENU

:MOUSE_FIX
echo.
echo [*] Mouse ivmesi (Acceleration) kapatiliyor...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul
echo    [OK] Mouse aim ayari (Raw Input) yapildi.
timeout /t 2 >nul
goto MENU

:NET_FIX
echo.
echo [*] Ag kisitlamasi kaldiriliyor (Network Throttling)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xFFFFFFFF /f >nul
echo    [OK] Ping optimizasyonu yapildi.
timeout /t 2 >nul
goto MENU

:DEBLOAT
echo.
echo [*] Gereksiz uygulamalar temizleniyor (PowerShell cagriliyor)...
echo     (Haritalar, Bing Hava Durumu, Ipuclari vb.)
powershell -Command "Get-AppxPackage *BingWeather* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *GetHelp* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *MicrosoftSolitaireCollection* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1
echo    [OK] Cop uygulamalar ucuruldu.
timeout /t 2 >nul
goto MENU

:STICKY
echo.
echo [*] Yapiskan tuslar (Sticky Keys) kapatiliyor...
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f >nul
echo    [OK] Shift tusu artik sorun cikarmayacak.
timeout /t 2 >nul
goto MENU

:SISTEM_YEDEK
echo.
echo [*] Sistem Geri Yukleme noktasi olusturuluyor...
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Cimidi_BAT_Yedek' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
echo    [OK] Yedek alma islemi denendi.
goto :EOF

:FULL_BAKIM
echo.
echo [!!!] TAM BAKIM BASLATILIYOR... ARKANA YASLAN DAYI.
call :SISTEM_YEDEK
echo.
call :FPS_AYAR
echo.
call :GUC_AYAR
echo.
call :TEMIZLIK
echo.
call :MOUSE_FIX
echo.
call :NET_FIX
echo.
call :DEBLOAT
echo.
call :STICKY
echo.
echo ==========================================================
echo [!!!] TUM ISLEMLER BITTI. 
echo       Bilgisayari YENIDEN BASLATMAYI unutma!
echo ==========================================================
pause
goto MENU