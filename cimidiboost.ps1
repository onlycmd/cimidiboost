<#
.SYNOPSIS
    Cimidi v7 - SMART GPU & STUTTER FIX EDITION
    Yazar: cimidi
    Amaç: Ekran kartını algılayan, takılmaları önleyen akıllı optimizasyon.
#>

# 1. YÖNETİCİ KONTROLÜ
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dayı, yönetici olarak çalıştırmadın! Sağ tıkla 'Yönetici Olarak Çalıştır' de."
    Start-Sleep -s 5
    Exit
}

# --- DONANIM VE GPU ALGILAMA (AKILLI MOD) ---
function Get-HardwareInfo {
    try {
        $global:cpuName = (Get-CimInstance Win32_Processor).Name
        $global:ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
        
        # GPU Tespiti
        $gpuInfo = Get-CimInstance Win32_VideoController
        $global:gpuName = $gpuInfo.Name
        
        # Marka Belirleme
        if ($global:gpuName -match "NVIDIA") { $global:gpuType = "NVIDIA" }
        elseif ($global:gpuName -match "AMD" -or $global:gpuName -match "Radeon") { $global:gpuType = "AMD" }
        elseif ($global:gpuName -match "Intel") { $global:gpuType = "INTEL" }
        else { $global:gpuType = "GENEL" }
    }
    catch {
        $global:gpuType = "BILINMIYOR"
    }
}

# --- GÖRSELLİK (ORTALAMA) ---
function Write-Center {
    param([string]$Text, [ConsoleColor]$Color = "White")
    try { $Width = $Host.UI.RawUI.WindowSize.Width } catch { $Width = 100 }
    $PadLeft = [Math]::Max(0, [int](($Width - $Text.Length) / 2))
    Write-Host (" " * $PadLeft + $Text) -ForegroundColor $Color
}

# --- İŞLEVLER ---

function Sistem-Yedek {
    Write-Center "[*] Sistem Geri Yükleme Noktası alınıyor..." "Yellow"
    try {
        Checkpoint-Computer -Description "Cimidi_v7_Yedek" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Center "    [OK] Yedek alındı." "Green"
    }
    catch {
        Write-Center "    [!] Yedek alınamadı (Sistem koruması kapalı olabilir)." "DarkYellow"
    }
}

function FPS-Ayarla-Safe {
    # ARKADAŞININ SORUNUNU ÇÖZEN KISIM BURASI (Safe Mode)
    Write-Center "[*] FPS Ayarları 'Smooth' (Akıcı/Takılmasız) moda alınıyor..." "Yellow"
    
    # GameBar Kapat
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -ErrorAction SilentlyContinue

    # GPU Öncelik Ayarı (DÜZELTİLMİŞ)
    # Priority 6 (High) yerine 2 (Normal) yapıyoruz ki işlemci kilitlenmesin.
    # Scheduling Category 'High' yerine 'Medium' yapıyoruz.
    $gamesKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    if (Test-Path $gamesKey) {
        Set-ItemProperty -Path $gamesKey -Name "GPU Priority" -Value 8 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $gamesKey -Name "Priority" -Value 2 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $gamesKey -Name "Scheduling Category" -Value "Medium" -ErrorAction SilentlyContinue
    }
    Write-Center "    [OK] Ayarlar yapıldı (Stutter Fix uygulandı)." "Green"
}

function GPU-Ozel-Islem {
    Write-Center "[*] GPU Tipi: $global:gpuType için işlemler yapılıyor..." "Cyan"
    
    switch ($global:gpuType) {
        "NVIDIA" {
            Write-Center " -> NVIDIA Denetim Masası açılıyor..." "White"
            Write-Center " -> Lütfen 'Güç Yönetimi' modunu 'Maksimum Performans' yap." "Yellow"
            Start-Process "control.exe"
            # Nvidia PowerMizer Registry (Dikkatli uygula)
            Write-Center " -> (Not: PowerMizer ayarları için sürücü paneli önerilir)" "Gray"
        }
        "AMD" {
            Write-Center " -> AMD Radeon Yazılımı açılıyor..." "White"
            Write-Center " -> 'ULPS' (Ultra Low Power) ayarını MSI Afterburner'dan kapatman önerilir." "Yellow"
            if (Test-Path "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe") {
                Start-Process "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe"
            }
            else {
                Write-Center " -> AMD Yazılımı varsayılan konumda bulunamadı." "Red"
            }
        }
        "INTEL" {
            Write-Center " -> Intel Grafik Kontrol Merkezi açılıyor..." "White"
            Start-Process "shell:AppsFolder\AppUp.IntelGraphicsExperience_8j3eq9eme6ctt!App" -ErrorAction SilentlyContinue
        }
        Default {
            Write-Center " -> Özel bir GPU yazılımı tespit edilemedi." "Red"
        }
    }
    Start-Sleep -s 3
}

function Guc-Plani {
    Write-Center "[*] Nihai Performans Modu..." "Yellow"
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    Write-Center "    [OK] Güç planı aktif." "Green"
}

function Temizlik-Yap {
    Write-Center "[*] Sistem temizleniyor..." "Yellow"
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-DnsClientCache
    Write-Center "    [OK] Temizlendi." "Green"
}

function Mouse-Fix {
    Write-Center "[*] Mouse ivmesi kapatılıyor..." "Yellow"
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 -ErrorAction SilentlyContinue
    Write-Center "    [OK] Mouse Raw Input aktif." "Green"
}

function Network-Fix {
    Write-Center "[*] Ağ kısıtlaması kaldırılıyor..." "Yellow"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -ErrorAction SilentlyContinue
    Write-Center "    [OK] Ağ optimize edildi." "Green"
}

function Debloat-Et {
    Write-Center "[*] Gereksiz uygulamalar siliniyor..." "Yellow"
    $bloat = @("*BingWeather*", "*WindowsMaps*", "*GetHelp*")
    foreach ($b in $bloat) { Get-AppxPackage -Name $b -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue }
    Write-Center "    [OK] Bloatware temizlendi." "Green"
}

function Sticky-Fix {
    Write-Center "[*] Yapışkan tuşlar kapatılıyor..." "Yellow"
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value "506" -ErrorAction SilentlyContinue
    Write-Center "    [OK] Shift tuşu sorunu çözüldü." "Green"
}

# --- BAŞLANGIÇ ---
Get-HardwareInfo

# --- MENÜ DÖNGÜSÜ ---
Do {
    Clear-Host
    Write-Host "`n"
    Write-Center "=====================================================" "Cyan"
    Write-Center "      CIMIDI v7 - AKILLI GPU SISTEMI (PS)            " "Cyan"
    Write-Center "=====================================================" "Cyan"
    Write-Center "CPU: $global:cpuName" "DarkGray"
    Write-Center "RAM: $global:ramGB GB  |  GPU: $global:gpuName" "DarkGray"
    Write-Center "TESPIT: [$global:gpuType] MODU AKTIF" "Magenta"
    Write-Center "-----------------------------------------------------" "Gray"
    Write-Host ""
    Write-Center "1.  FPS Ayarlari (Stutter Fix - Takilma Onleyici)  " "White"
    Write-Center "2.  Guc Plani (Nihai Performans)                   " "White"
    Write-Center "3.  Sistem Temizligi (Temp, DNS)                   " "White"
    Write-Center "4.  Mouse Fix (Raw Input)                          " "White"
    Write-Center "5.  Network Fix (Ping)                             " "White"
    Write-Center "6.  Debloat (Gereksizleri Sil)                     " "White"
    Write-Center "7.  Yapiskan Tuslari Kapat                         " "White"
    Write-Host ""
    Write-Center "8.  >>> EKRAN KARTINA OZEL AYAR ($global:gpuType) <<<  " "Yellow"
    Write-Host ""
    Write-Center "-----------------------------------------------------" "Gray"
    Write-Center "99. HEPSINI UYGULA (FULL BAKIM)                    " "Green"
    Write-Center "0.  CIKIS                                          " "Red"
    Write-Center "=====================================================" "Cyan"
    Write-Host "`n"
    
    $pad = " " * ([Math]::Max(0, [int](($Host.UI.RawUI.WindowSize.Width - 40) / 2)))
    $secim = Read-Host "$pad Secimin nedir dayi? (No yaz Enter'a bas)"

    Switch ($secim) {
        "1" { FPS-Ayarla-Safe; Start-Sleep -s 2 }
        "2" { Guc-Plani; Start-Sleep -s 2 }
        "3" { Temizlik-Yap; Start-Sleep -s 2 }
        "4" { Mouse-Fix; Start-Sleep -s 2 }
        "5" { Network-Fix; Start-Sleep -s 2 }
        "6" { Debloat-Et; Start-Sleep -s 2 }
        "7" { Sticky-Fix; Start-Sleep -s 2 }
        "8" { GPU-Ozel-Islem; Start-Sleep -s 2 }
        "99" {
            Sistem-Yedek
            FPS-Ayarla-Safe
            Guc-Plani
            Temizlik-Yap
            Mouse-Fix
            Network-Fix
            Debloat-Et
            Sticky-Fix
            GPU-Ozel-Islem
            Write-Host "`n"
            Write-Center "[!!!] ISLEMLER TAMAMLANDI. RESET ATMAYI UNUTMA!" "Magenta"
            Read-Host "Çıkmak için Enter..."
        }
        "0" { Write-Center "Hadi eyvallah..." "Red"; Start-Sleep -s 1; Exit }
        Default { Write-Center "Yanlış tuş dayı." "Red"; Start-Sleep -s 1 }
    }

} Until ($secim -eq "0" -or $secim -eq "99")