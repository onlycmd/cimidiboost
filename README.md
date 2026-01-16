# 🚀 Cimidi Windows FPS & System Optimizer

**Windows 10 ve Windows 11 için geliştirilmiş, oyun performansını (FPS) artıran, gereksiz hizmetleri kapatan ve sistemi temizleyen hepsi bir arada optimizasyon aracı.**

Bu proje, bilgisayarınızın potansiyelini ortaya çıkarmak, gecikmeyi (input lag) düşürmek ve daha stabil bir oyun deneyimi sunmak için tasarlanmıştır.

## 📂 Dosyalar ve Sürümler

Bu depoda üç temel dosya bulunmaktadır:

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
Optimizasyon sonrası sorun yaşarsanız sistemi eski haline döndüren kurtarıcı dosyadır. Detaylar aşağıdadır.

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

## 🆘 Acil Durum / Sorun Giderme (Troubleshooting)

Her bilgisayarın donanımı ve tepkisi farklıdır. Eğer optimizasyonları yaptıktan sonra:
* 📉 FPS düşüşü yaşarsanız (Örn: Registry ayarları bazı sistemlerde darboğaz yapabilir),
* 🌡️ Bilgisayar çok ısınırsa,
* ⚠️ Sistemde takılmalar olursa;

Korkmanıza gerek yok! **`cimidifix.bat`** dosyası bunun için var.

**Nasıl Geri Alırım?**
1. Klasördeki **`cimidifix.bat`** dosyasına sağ tıklayın.
2. **Yönetici Olarak Çalıştır** deyin.
3. İşlem bitince bilgisayarınızı **yeniden başlatın**.

Bu işlem; yapılan Registry değişikliklerini siler, güç planını dengeliye alır ve sistemi varsayılan ayarlarına geri döndürür.

---

## 🚀 Kurulum ve Kullanım

1.  Bu repoyu indirin veya **Code** butonuna basıp **Download ZIP** deyin.
2.  Klasörü masaüstüne çıkartın.
3.  İhtiyacınıza uygun olan sürümü (`.bat` veya `.ps1`) yönetici olarak çalıştırın.
4.  Açılan menüden yapmak istediğiniz işlemi seçin (Tavsiye: `99` yazıp Enter'a basarak tam bakım yapın).
5.  İşlem bitince bilgisayarınızı **yeniden başlatın**.

---

## ⚠️ Yasal Uyarı (Disclaimer)

Bu yazılım Windows Kayıt Defteri (Registry) ve sistem ayarlarında değişiklikler yapar. Kodların içerisine güvenlik önlemi olarak **Sistem Geri Yükleme Noktası** oluşturma adımı eklenmiştir.
* Her zaman önemli verilerinizi yedekleyiniz.
* Bu scripti kullanmak tamamen kullanıcının sorumluluğundadır.

---
*Developed by cimidi*
