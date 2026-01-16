@echo off
title CIMIDI - ACIL DURUM DUZELTME KITI
color 0c

echo ==========================================================
echo       CIMIDI - ACIL DURUM DUZELTME (UNDO) KITI
echo       "Bozulan ayarlari varsayilana donduruyoruz..."
echo ==========================================================
echo.

:: 1. GPU ÖNCELİK AYARLARINI SİL (Sorunun %90 kaynağı burası)
echo [*] GPU ve CPU oncelik ayarlari siliniyor...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /f >nul 2>&1

:: 2. AĞ KISITLAMASINI VARSAYILANA DÖNDÜR
echo [*] Network Throttling varsayilana donuyor...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul

:: 3. GAME DVR AYARLARINI ESKİSİ GİBİ YAP (Bazen oyunlar bunu arar)
echo [*] GameDVR ayarlari varsayilana aliniyor...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 1 /f >nul

:: 4. GÜÇ PLANINI DENGELİ YAP (Isınma sorunu varsa çözer)
echo [*] Guc plani 'Dengeli' moduna aliniyor...
powercfg -restoredefaultschemes >nul

echo.
echo ==========================================================
echo   ISLEM TAMAMLANDI YEGENIM.
echo   Bilgisayari YENIDEN BASLAT, sorun duzelmis olmali.
echo ==========================================================
pause