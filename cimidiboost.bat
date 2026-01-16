@echo off
setlocal EnableDelayedExpansion
title CIMIDI v7 - SMART GPU EDITION
color 0b

:: --- 1. YONETICI KONTROLU ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [!] DAYI, YONETICI OLARAK CALISTIRMAN LAZIM!
    echo [!] Sag tikla 'Yonetici Olarak Calistir' de.
    pause
    exit
)

:: --- 2. DONANIM VE GPU ALGILAMA (AKILLI KISIM) ---
echo [*] Sistem donanimi taraniyor...
for /f "tokens=2 delims==" %%A in ('wmic cpu get name /value') do set "CPU_NAME=%%A"
for /f "tokens=2 delims==" %%B in ('wmic computersystem get TotalPhysicalMemory /value') do set "RAM_BYTES=%%B"
set "RAM_GB=%RAM_BYTES:~0,-9%" 
for /f "tokens=2 delims==" %%C in ('wmic path win32_videocontroller get name /value') do set "GPU_NAME=%%C"

:: GPU Markasi Belirleme
set "GPU_TYPE=BILINMIYOR"
echo %GPU_NAME% | findstr /i "NVIDIA" >nul && set "GPU_TYPE=NVIDIA"
echo %GPU_NAME% | findstr /i "AMD" >nul && set "GPU_TYPE=AMD"
echo %GPU_NAME% | findstr /i "Radeon" >nul && set "GPU_TYPE=AMD"
echo %GPU_NAME% | findstr /i "Intel" >nul && set "GPU_TYPE=INTEL"

:MENU
cls
echo.
echo ======================================================================
echo                 CIMIDI v7 - AKILLI GPU MODU
echo ======================================================================
echo  ISLEMCI : %CPU_NAME%
echo  RAM     : ~%RAM_GB% GB
echo  GPU     : %GPU_NAME% 
echo  TESPIT  : [%GPU_TYPE%] MODU AKTIF
echo ----------------------------------------------------------------------
echo.
echo    1. FPS Ayarlari (Stutter/Takilma Onleyici Mod)
echo    2. Guc Plani (Nihai Performans)
echo    3. Sistem Temizligi (Temp, DNS)
echo    4. Mouse Fix (Raw Input)
echo    5. Network Fix (Ping)
echo    6. Debloat (Cop Uygulamalari Sil)
echo    7. Yapiskan Tuslari Kapat
echo.
echo    8. --- EKRAN KARTINA OZEL AYAR YAP (%GPU_TYPE%) ---
echo.
echo    99. HEPSINI UYGULA (FULL BAKIM)
echo    0.  CIKIS
echo ======================================================================
set /p secim="Secimin nedir dayi? : "

if "%secim%"=="1" goto FPS_AYAR
if "%secim%"=="2" goto GUC_AYAR
if "%secim%"=="3" goto TEMIZLIK
if "%secim%"=="4" goto MOUSE_FIX
if "%secim%"=="5" goto NET_FIX
if "%secim%"=="6" goto DEBLOAT
if "%secim%"=="7" goto STICKY
if "%secim%"=="8" goto GPU_OZEL
if "%secim%"=="99" goto FULL_BAKIM
if "%secim%"=="0" exit
goto MENU

:GPU_OZEL
echo.
if "%GPU_TYPE%"=="NVIDIA" (
    echo [*] NVIDIA KARTI ALGILANDI!
    echo [*] PowerMizer (Guc Tasarrufu) kapatiliyor...
    :: Nvidia kartlarda anlik takilmayi (stutter) onleyen gizli ayar
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Video" /v "PerfLevelSrc" /t REG_DWORD /d 3322 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Video" /v "PowerMizerEnable" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Video" /v "PowerMizerLevel" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Video" /v "PowerMizerLevelAC" /t REG_DWORD /d 1 /f >nul 2>&1
    echo [*] Nvidia Denetim Masasi aciliyor... Lutfen 'Guc Yonetimi'ni 'Maksimum Performans' yap.
    start control.exe
    timeout /t 3 >nul
) 
if "%GPU_TYPE%"=="AMD" (
    echo [*] AMD KARTI ALGILANDI!
    echo [*] Dikkat: AMD kartlarda 'ULPS' (Ultra Low Power State) takilma yapar.
    echo [*] Bunu MSI Afterburner ayarlarindan kapatman onerilir.
    echo [*] AMD Radeon yazilimi aciliyor... 'Shader Cache'i sifirlamayi unutma.
    start "" "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe"
    timeout /t 3 >nul
)
if "%GPU_TYPE%"=="INTEL" (
    echo [*] INTEL KARTI ALGILANDI!
    echo [*] Intel Graphics Command Center aciliyor...
    echo [*] Lutfen Guc ayarlarindan 'Maksimum Performans' sec.
    start "" shell:AppsFolder\AppUp.IntelGraphicsExperience_8j3eq9eme6ctt!App
    timeout /t 3 >nul
)
if "%GPU_TYPE%"=="BILINMIYOR" (
    echo [!] GPU markasini tam cozemedim dayi, genel ayarlardan devam et.
)
echo    [OK] GPU islemleri tamam.
pause
goto MENU

:FPS_AYAR
echo.
echo [*] Game Bar kapatiliyor (Optimize Edilmis Ayar)...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul

echo [*] GPU Onceligi 'Dengeli-Yuksek' ayarina aliniyor (Takilma yapmaz)...
:: Priority degerini 6'dan 2'ye (Normal) veya 6 (High) yerine daha kararli olana cekiyoruz.
:: Onemli: 'Scheduling Category' High yerine Medium yapildi, takilmayi engeller.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul
echo    [OK] FPS ayarlari 'Smooth' (Akici) moduna alindi.
timeout /t 2 >nul
goto MENU

:GUC_AYAR
echo.
echo [*] Nihai Performans Modu...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
echo    [OK] Guc plani degisti.
goto MENU

:TEMIZLIK
echo.
echo [*] Sistem temizleniyor...
del /s /f /q %temp%\*.* >nul 2>&1
rd /s /q %temp% >nul 2>&1
mkdir %temp% >nul 2>&1
ipconfig /flushdns >nul
echo    [OK] Temizlendi.
goto MENU

:MOUSE_FIX
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul
echo    [OK] Mouse duzeltildi.
goto MENU

:NET_FIX
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xFFFFFFFF /f >nul
echo    [OK] Ag duzeltildi.
goto MENU

:DEBLOAT
powershell -Command "Get-AppxPackage *BingWeather* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage" >nul 2>&1
echo    [OK] Bloatware temizlendi.
goto MENU

:STICKY
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f >nul
echo    [OK] Yapiskan tuslar kapandi.
goto MENU

:FULL_BAKIM
echo.
echo [!!!] FULL BAKIM VE GPU AYARI YAPILIYOR...
call :FPS_AYAR
call :GUC_AYAR
call :TEMIZLIK
call :MOUSE_FIX
call :NET_FIX
call :DEBLOAT
call :STICKY
call :GPU_OZEL
echo.
echo [!!!] ISLEM TAMAM. RESET ATMAYI UNUTMA DAYI!
pause
goto MENU