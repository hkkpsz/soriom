# Quiz Uygulaması

Flutter ile geliştirilmiş interaktif quiz uygulaması.

## Özellikler

### Ana Kategoriler
- **Fotoğraf Quiz**: Görsel bilginizi test edin
  - Genel Kültür: Türkiye'deki tarihi ve turistik yerler
  - Futbol: Futbolcu tanıma quizi

- **Müzik Quiz**: Müzik bilginizi test edin
  - Arabesk
  - Pop
  - Rap

## Kurulum

1. Flutter SDK'nın yüklü olduğundan emin olun
2. Projeyi klonlayın
3. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

## Kullanılan Paketler

- `audioplayers`: Müzik çalma özelliği için
- `cupertino_icons`: iOS tarzı ikonlar için

## Ekran Görüntüleri

Uygulama tasarımı modern ve kullanıcı dostu bir arayüze sahiptir:
- Ana kategori seçim ekranı
- Alt kategori seçim ekranı
- Fotoğraf quiz ekranı
- Müzik quiz ekranı

## Geliştirme Notları

- **Ses dosyaları**: Gerçek MP3 dosyaları `assets/audio/arabesk/` klasörüne konulmalıdır
- **Futbolcu resimleri**: `assets/images/futbolcular/` klasörüne konulmalıdır  
- **Quiz soruları**: JSON dosyalarından yüklenir (`assets/data/`)
- Futbolcu kategorisi için 20 soru hazır durumda
- Genel Kültür kategorisi için 20 soru hazır durumda (Türkiye'deki tarihi ve turistik yerler)
- Arabesk müzik kategorisi için 22 soru hazır durumda (Müslüm Gürses, Bergen, Ferdi Tayfur vb.)
- Rap müzik kategorisi için 19 soru hazır durumda (Ceza, Sagopa, Norm Ender, Ben Fero vb.)
- Pop müzik kategorisi için 23 soru hazır durumda (Simge, Hadise, Edis, Buray, Sıla vb.)

## 🎵 Müzik Quiz'i - Aktif Mod

**Müzik quiz'i tamamen aktif:**
- Gerçek MP3 dosyalarını çalar
- Doğru/yanlış cevap gösterimi aktif
- Play/Pause kontrolleri çalışıyor
- Skor takibi yapılıyor

**Kullanım:**
1. Arabesk şarkılarını `assets/audio/arabesk/` klasörüne koyun
2. Dosya isimleri JSON'daki path'lerle tam olarak eşleşmeli
3. Müzik → Arabesk kategorisinden quiz'i başlatın

## JSON Veri Yapısı

Quiz soruları JSON formatında saklanır:
```json
{
  "question": "Soru metni",
  "image": "assets/images/futbolcular/resim.jpg",
  "options": ["Seçenek A", "Seçenek B", "Seçenek C", "Seçenek D"],
  "answer": "Doğru cevap"
}
```

## Dosya Yapısı

```
lib/
├── main.dart                    # Ana uygulama
├── models/
│   └── question.dart           # Soru modeli
├── services/
│   └── quiz_service.dart       # Quiz veri servisi
├── screens/
│   ├── main_category_screen.dart
│   ├── sub_category_screen.dart
│   └── quiz_screen.dart
└── widgets/
    ├── category_card.dart
    ├── sub_category_button.dart
    ├── answer_option.dart
    └── answer_button.dart

assets/
├── data/
│   ├── futbolcu_sorulari.json     # Futbolcu soruları
│   ├── genel_kultur_sorulari.json # Genel kültür soruları
│   └── arabesk_sorulari.json      # Arabesk müzik soruları
├── images/
│   ├── futbolcular/               # Futbolcu resimleri
│   └── gezilecek_yerler/          # Tarihi ve turistik yer resimleri
└── audio/
    └── arabesk/                   # Arabesk müzik dosyaları
```
