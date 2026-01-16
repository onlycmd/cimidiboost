# 🚀 Cimidi Windows FPS & System Optimizer

**Windows 10 ve Windows 11 için geliştirilmiş, oyun performansını (FPS) artıran, gereksiz hizmetleri kapatan ve sistemi temizleyen hepsi bir arada optimizasyon aracı.**

Bu proje, bilgisayarınızın potansiyelini ortaya çıkarmak, gecikmeyi (input lag) düşürmek ve daha stabil bir oyun deneyimi sunmak için tasarlanmıştır.

---

## 📥 Hızlı İndirme Linkleri (Direct Downloads)

Dosyalar arasında kaybolmadan ihtiyacınız olan sürümü buradan direkt indirebilirsiniz:

| Sürüm | Dosya Tipi | Açıklama | İndir |
| :--- | :---: | :--- | :---: |
| **Cimidi v6 (Önerilen)** | `.bat` | Kurulumsuz, hızlı, herkes için. | [📥 Tıkla İndir](https://github.com/[onlycmd]/[cimidiboost]/raw/main/cimidiboost.bat) |
| **Cimidi PowerShell** | `.ps1` | Detaylı bilgi ekranlı, ileri düzey. | [📥 Tıkla İndir](https://github.com/[onlycmd]/[cimidiboost]/raw/main/cimidiboost.ps1) |
| **Acil Durum Kiti** | `.bat` | Sorun çıkarsa sistemi geri alır. | [🚑 Tıkla İndir](https://github.com/[onlycmd]/[cimidiboost]/raw/main/cimidifix.bat) |

---

## 📸 Ekran Görüntüleri (Screenshots)

**Cimidi v6 Komuta Merkezi:**
<div align="center">
  <img src="https://i.hizliresim.com/3i4ylwi.png" alt="Cimidi Menü Önizleme" width="700">
  <br>
  <em>Sistem bilgilerini otomatik algılar ve seçenekleri menü halinde sunar.</em>
</div>

<div align="center">
  <img src="https://i.hizliresim.com/qvahcro.png" alt="Cimidi fix önizleme" width="700">
  <br>
  <em>Yaptığınız ayarları varsayılan ayara çevirir.</em>
</div>

---

## 📂 Hangi Dosyayı Seçmeliyim?

### 1. ⚡ Batch (CMD) Sürümü (`Cimidi_v6.bat`) - *Önerilen*
Bu sürüm, efsanevi Windows Komut İstemi (CMD) altyapısını kullanır.
- **Kimler için?** "Kodla uğraşamam, tıkla çalışsın" diyenler ve kurulumla uğraşmak istemeyenler için.
- **Özellikleri:** Kurulum gerektirmez, menülüdür, hızlı ve basittir.
- **Kullanımı:** Sağ tık -> *Yönetici Olarak Çalıştır* (Run as Administrator).

### 2. 🛠️ PowerShell Sürümü (`Cimidi_v6_Final.ps1`)
Bu sürüm, Windows'un modern komut satırı olan PowerShell üzerine kuruludur.
- **Kimler için?** Teknolojiyle arası iyi olan, detaylı çıktı ve donanım bilgisi görmek isteyenler için.
- **Kullanımı:** Sağ tık -> *PowerShell ile Çalıştır* (Run with PowerShell).

### 3. 🚑 Acil Durum Düzeltici (`cimidifix.bat`)
Optimizasyon sonrası sorun yaşarsanız sistemi eski haline döndüren kurtarıcı dosyadır.

---

## 🔥 Özellikler

Bu araç aşağıdaki optimizasyonları otomatik veya seçmeli olarak uygular:

* **🎮 FPS ve Oyun Modu:** Xbox Game Bar ve DVR'ı kapatır, oyunlara GPU ve CPU önceliği ("High Priority") atar.
* **⚡ Güç Planı:** Windows'un gizli **"Nihai Performans" (Ultimate Performance)** güç planını aktif eder.
* **🧹 Sistem Temizliği:** Temp, Prefetch klasörlerini ve DNS önbelleğini temizler.
* **🖱️ Mouse Fix:** Windows'un "İşaretçi hassasiyetini artır" (Mouse Acceleration) ayarını kapatarak oyunlarda kas hafızasının bozulmasını engeller.
* **🌐 Network Fix:** Ağ kısıtlamasını (Network Throttling) kaldırarak ping dalgalanmalarını azaltır.
* **🚫 Debloat:** Windows ile gelen gereksiz uygulamaları (Haritalar, İpuçları vb.) temizler.
* **⌨️ Yapışkan Tuşlar:** Shift tuşuna çok basınca oyunun bölünmesini engeller.

---

## 🆘 Acil Durum / Fabrika Ayarlarına Dönüş (Fix Ultra)

Eğer optimizasyon sonrası bilgisayarda takılma, donma veya FPS düşüşü yaşarsanız; **`cimidifix.bat`** dosyasını kullanın.

**Bu dosya ne yapar?**
* 🛑 **Tüm Optimizasyonları Siler:** Windows'u orijinal haline döndürür.
* 🎮 **GPU Ayarlarını Sıfırlar:** NVIDIA veya AMD kartınızın ayarlarını varsayılana (Default) çeker.
* ⚡ **Hizmetleri Açar:** Kapatılan arka plan hizmetlerini geri yükler.

**Kullanım:**
1. `cimidifix.bat` dosyasına sağ tıklayıp **Yönetici Olarak Çalıştır** deyin.
2. İşlem bitince bilgisayarı **yeniden başlatın**.

---

## ⚠️ Yasal Uyarı (Disclaimer)

Bu yazılım Windows Kayıt Defteri (Registry) ve sistem ayarlarında değişiklikler yapar. Kodların içerisine güvenlik önlemi olarak **Sistem Geri Yükleme Noktası** oluşturma adımı eklenmiştir.
* Her zaman önemli verilerinizi yedekleyiniz.
* Bu scripti kullanmak tamamen kullanıcının sorumluluğundadır.

---
*Developed by cimidi*
