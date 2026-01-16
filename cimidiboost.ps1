<#
.SYNOPSIS
    Cimidi v6 - FINAL EDITION
    Yazar: cimidi
    Amaç: PowerShell gücüyle Windows'u uçurmak.
#>

# 1. YÖNETİCİ KONTROLÜ
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dayı, yönetici olarak çalıştırmadın! Sağ tıkla 'Yönetici Olarak Çalıştır' de."
    Start-Sleep -s 5
    Exit
}

# --- GÖRSELLİK FONKSİYONU (ORTALAMA) ---
function Write-Center {
    param(
        [string]$Text,
        [ConsoleColor]$Color = "White"
    )
    try { $Width = $Host.UI.RawUI.WindowSize.Width } catch { $Width = 100 }
    $PadLeft = [Math]::Max(0, [int](($Width - $Text.Length) / 2))
    Write-Host (" " * $PadLeft + $Text) -ForegroundColor $Color
}

# --- DONANIM BİLGİSİ ÇEKME ---
function Get-SysInfo {
    try {
        $cpu = (Get-CimInstance Win32_Processor).Name
        $ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
        $gpu = (Get-CimInstance Win32_VideoController)[0].Name
        
        Write-Center "ISLEMCI: $cpu" "DarkGray"
        Write-Center "RAM: $ram GB  |  GPU: $gpu" "DarkGray"
    }
    catch {
        Write-Center "Sistem bilgisi alınamadı..." "Red"
    }
}

# --- İŞLEV FONKSİYONLARI ---

function Sistem-Yedek {
    Write-Center "[*] Sistem Geri Yükleme Noktası alınıyor..." "Yellow"
    try {
        Checkpoint-Computer -Description "Cimidi_v6_Yedek" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Center "    [OK] Yedek alındı. Güvendeyiz." "Green"
    }
    catch {
        Write-Center "    [!] Yedek alınamadı (Sistem koruması kapalı olabilir)." "DarkYellow"
    }
}

function FPS-Ayarla {
    Write-Center "[*] FPS Ayarları (GameBar, GPU, Öncelik) yapılıyor..." "Yellow"
    # GameBar Kapat
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ErrorAction SilentlyContinue
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -ErrorAction SilentlyContinue
    # Oyun Modu Aç
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -ErrorAction SilentlyContinue
    # GPU Öncelik
    $gamesKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    if (Test-Path $gamesKey) {
        Set-ItemProperty -Path $gamesKey -Name "GPU Priority" -Value 8 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $gamesKey -Name "Priority" -Value 6 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $gamesKey -Name "Scheduling Category" -Value "High" -ErrorAction SilentlyContinue
    }
    Write-Center "    [OK] FPS ayarları tamamlandı." "Green"
}

function Guc-Plani {
    Write-Center "[*] Nihai Performans Modu açılıyor..." "Yellow"
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    Write-Center "    [OK] Güç planı: Ultimate Performance." "Green"
}

function Temizlik-Yap {
    Write-Center "[*] Temp, Prefetch ve DNS temizleniyor..." "Yellow"
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-DnsClientCache
    Write-Center "    [OK] Sistem çöpleri atıldı." "Green"
}

function Mouse-Fix {
    Write-Center "[*] Mouse hızlandırma (Acceleration) kapatılıyor..." "Yellow"
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 -ErrorAction SilentlyContinue
    Write-Center "    [OK] Mouse ham veriye (Raw Input) geçti." "Green"
}

function Debloat-Et {
    Write-Center "[*] Gereksiz Windows uygulamaları siliniyor..." "Yellow"
    $bloat = @("*BingWeather*", "*GetHelp*", "*Microsoft3DViewer*", "*MicrosoftSolitaireCollection*", "*WindowsMaps*", "*WindowsFeedbackHub*")
    foreach ($b in $bloat) {
        Get-AppxPackage -Name $b -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    }
    Write-Center "    [OK] Gereksiz uygulamalar uçuruldu." "Green"
}

function Network-Fix {
    Write-Center "[*] Ağ kısıtlaması (Throttling) kaldırılıyor..." "Yellow"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -ErrorAction SilentlyContinue
    Write-Center "    [OK] Ağ ayarları optimize edildi." "Green"
}

# --- ANA MENÜ DÖNGÜSÜ ---

Do {
    Clear-Host
    Write-Host "`n"
    Write-Center "=====================================================" "Cyan"
    Write-Center "           CIMIDI v6 - FINAL EDITION                 " "Cyan"
    Write-Center "=====================================================" "Cyan"
    Get-SysInfo
    Write-Center "-----------------------------------------------------" "Gray"
    Write-Host ""
    Write-Center "1.  FPS ve Oyun Ayarlari (GameBar, GPU Öncelik)" "White"
    Write-Center "2.  Guc Plani (Ultimate Performance)           " "White"
    Write-Center "3.  Sistem Temizligi (Temp, DNS, Cop Dosyalar) " "White"
    Write-Center "4.  Mouse Fix (Aim duzeltme)                   " "White"
    Write-Center "5.  Network Fix (Ping duzeltme)                " "White"
    Write-Center "6.  Debloat (Gereksiz Uygulamalari Sil)        " "White"
    Write-Center "7.  Yapiskan Tuslari Kapat                     " "White"
    Write-Host ""
    Write-Center "-----------------------------------------------------" "Gray"
    Write-Center "99. HEPSINI UYGULA (Full Bakim)                " "Green"
    Write-Center "0.  CIKIS                                      " "Red"
    Write-Center "=====================================================" "Cyan"
    Write-Host "`n"
    
    $pad = " " * ([Math]::Max(0, [int](($Host.UI.RawUI.WindowSize.Width - 40) / 2)))
    $secim = Read-Host "$pad Secimin nedir dayi? (No yaz Enter'a bas)"

    Switch ($secim) {
        "1" { FPS-Ayarla; Start-Sleep -s 2 }
        "2" { Guc-Plani; Start-Sleep -s 2 }
        "3" { Temizlik-Yap; Start-Sleep -s 2 }
        "4" { Mouse-Fix; Start-Sleep -s 2 }
        "5" { Network-Fix; Start-Sleep -s 2 }
        "6" { Debloat-Et; Start-Sleep -s 2 }
        "7" { 
            Write-Center "Yapışkan tuşlar kapatılıyor..." "Yellow"
            Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value "506" -ErrorAction SilentlyContinue
            Write-Center "[OK] Tamamdır." "Green"
            Start-Sleep -s 2
        }
        "99" {
            Sistem-Yedek
            FPS-Ayarla
            Guc-Plani
            Temizlik-Yap
            Mouse-Fix
            Network-Fix
            Debloat-Et
            Write-Host "`n"
            Write-Center "[!!!] ISLEMLER TAMAMLANDI DAYI. PC'YI YENIDEN BASLAT!" "Magenta"
            Read-Host "Çıkmak için Enter..."
        }
        "0" { Write-Center "Hadi eyvallah..." "Red"; Start-Sleep -s 1; Exit }
        Default { Write-Center "Yanlış tuşa bastın yeğenim, tekrar dene." "Red"; Start-Sleep -s 2 }
    }

} Until ($secim -eq "0" -or $secim -eq "99")