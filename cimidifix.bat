@echo off
setlocal EnableDelayedExpansion
title CIMIDI FIX ULTRA - FABRIKA AYARLARINA DONUS
color 4f

:: --- YONETICI KONTROLU ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [!] DAYI, YONETICI OLARAK CALISTIRMAN LAZIM!
    echo.
    pause
    exit
)

cls
echo ======================================================================
echo          CIMIDI FIX ULTRA - HER SEYI VARSAYILANA DONDUR
echo ======================================================================
echo.
echo [!] DIKKAT: Bu islem su ayarlari sifirlayacak:
echo     - Yaptigimiz tum FPS ve GPU oncelik ayarlari silinecek.
echo     - Guc plani 'Dengeli'ye donecek.
echo     - NVIDIA/AMD kontrol paneli ayarlari varsayilana donecek.
echo     - Mouse ivmesi (Windows varsayilan) acilacak.
echo.
set /p onay="Devam etmek istiyor musun dayi? (E/H): "
if /i "%onay%" neq "E" exit

echo.
echo ----------------------------------------------------------------------
echo [1/6] Windows GPU ve CPU Oncelikleri Temizleniyor...
echo ----------------------------------------------------------------------
:: Bizim ekledigimiz ozel anahtarlari siliyoruz
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /f >nul 2>&1
echo    [OK] Darbogaz yapan ayarlar silindi.

echo.
echo ----------------------------------------------------------------------
echo [2/6] Ag ve GameBar Ayarlari Sifirlaniyor...
echo ----------------------------------------------------------------------
:: Ag kisitlamasi varsayilan (10) yapiliyor
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul
:: GameBar varsayilan aciliyor
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 1 /f >nul
echo    [OK] Ag ve DVR varsayilana dondu.

echo.
echo ----------------------------------------------------------------------
echo [3/6] Hizmetler ve Mouse Geri Aciliyor...
echo ----------------------------------------------------------------------
:: SysMain (Superfetch) geri aciliyor
sc config "SysMain" start= auto >nul 2>&1
net start "SysMain" >nul 2>&1
:: Mouse hizlandirma varsayilan (1)
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "6" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "10" /f >nul
echo    [OK] Hizmetler ve Mouse eski haline geldi.

echo.
echo ----------------------------------------------------------------------
echo [4/6] Guc Plani Sifirlaniyor...
echo ----------------------------------------------------------------------
powercfg -restoredefaultschemes >nul
echo    [OK] Guc plani 'Dengeli' oldu.

echo.
echo ----------------------------------------------------------------------
echo [5/6] Ekran Karti Ayarlari Sifirlaniyor (NVIDIA/AMD)...
echo ----------------------------------------------------------------------
:: GPU Tespiti
set "GPU_TYPE=BILINMIYOR"
for /f "tokens=2 delims==" %%C in ('wmic path win32_videocontroller get name /value') do set "GPU_NAME=%%C"
echo %GPU_NAME% | findstr /i "NVIDIA" >nul && set "GPU_TYPE=NVIDIA"
echo %GPU_NAME% | findstr /i "AMD" >nul && set "GPU_TYPE=AMD"

if "%GPU_TYPE%"=="NVIDIA" (
    echo    [*] NVIDIA Tespit Edildi.
    echo    [*] Surucu ayarlari Registry'den temizleniyor...
    :: Kullanicinin yaptigi 3D ayarlari siliyoruz (Surucu resetlenir)
    reg delete "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /f >nul 2>&1
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /f >nul 2>&1
    echo    [OK] NVIDIA ayarlari varsayilana dondu.
) 

if "%GPU_TYPE%"=="AMD" (
    echo    [*] AMD Tespit Edildi.
    echo    [*] Radeon ayarlari Registry'den temizleniyor...
    :: Radeon Software veritabanini (CN) sifirliyoruz
    reg delete "HKCU\Software\AMD\CN" /f >nul 2>&1
    echo    [OK] AMD Radeon ayarlari varsayilana dondu.
)

if "%GPU_TYPE%"=="BILINMIYOR" (
    echo    [!] Intel veya Bilinmeyen GPU. Genel temizlik yeterli oldu.
)

echo.
echo ----------------------------------------------------------------------
echo [6/6] Sifirlama Tamamlandi!
echo ----------------------------------------------------------------------
echo.
echo [!!!] ISLEM BITTI DAYI. 
echo [!!!] BILGISAYARI YENIDEN BASLATINCA ESKI HALINE DONECEK.
echo.
pause