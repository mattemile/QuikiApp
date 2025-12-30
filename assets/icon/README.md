# QuikiApp Icons

## Come Aggiungere le Icone

### 📋 Requisiti

Devi creare **2 immagini PNG**:

1. **`app_icon.png`** - Icona principale
   - Dimensione: **1024x1024 px**
   - Formato: PNG con sfondo
   - Questa sarà l'icona su iOS e web

2. **`app_icon_foreground.png`** - Icona per Android (opzionale ma consigliato)
   - Dimensione: **1024x1024 px**
   - Formato: PNG trasparente
   - Solo il simbolo/logo senza sfondo
   - Per Android Adaptive Icons

### 🎨 Suggerimenti di Design

Per QuikiApp, l'icona dovrebbe rappresentare:
- **Colori**: Blu scuro (#1A237E) e Arancione (#FF6F00)
- **Tema**: Gioco veloce, divertimento, micro-momenti
- **Simboli**: Può includere:
  - Lampo/fulmine (velocità)
  - Controller di gioco stilizzato
  - Cerchio/quadrato colorato
  - Simbolo "Q" stilizzato

### ⚙️ Generare le Icone

Una volta che hai messo i file PNG in questa cartella:

```bash
# 1. Installa le dipendenze
flutter pub get

# 2. Genera le icone per tutte le piattaforme
dart run flutter_launcher_icons

# 3. (Opzionale) Ricompila l'app
flutter build apk
```

### 📱 Cosa Viene Generato

Il comando genererà automaticamente:

✅ **Android**
- `mipmap-hdpi` (72x72)
- `mipmap-mdpi` (48x48)
- `mipmap-xhdpi` (96x96)
- `mipmap-xxhdpi` (144x144)
- `mipmap-xxxhdpi` (192x192)
- Adaptive icons (foreground + background)

✅ **iOS**
- Tutte le dimensioni richieste (da 20x20 a 1024x1024)
- AppIcon.appiconset completo

✅ **Web**
- favicon.png
- icons/Icon-192.png
- icons/Icon-512.png
- icons/Icon-maskable-192.png
- icons/Icon-maskable-512.png

### 🎨 Tool Online per Creare Icone

Se non hai un'icona pronta, puoi usare questi tool gratuiti:

1. **Canva** - https://www.canva.com/
   - Templates per app icons
   - Facile da usare

2. **Figma** - https://www.figma.com/
   - Design professionale
   - Gratis per uso base

3. **Icon Kitchen** - https://icon.kitchen/
   - Generatore di icone Android/iOS
   - Molto veloce

4. **App Icon Generator** - https://www.appicon.co/
   - Carica un'immagine e genera tutte le dimensioni

### 📝 Esempio Veloce con Testo

Se vuoi creare velocemente un'icona placeholder:

```bash
# Su Windows con ImageMagick installato:
magick -size 1024x1024 xc:#1A237E -gravity center -pointsize 400 -fill #FF6F00 -annotate +0+0 "Q" app_icon.png
```

### 🔄 Aggiornare le Icone

Se modifichi le icone:

```bash
# Rigenera tutto
dart run flutter_launcher_icons

# Pulisci e ricompila
flutter clean
flutter pub get
flutter build apk
```

### ⚠️ Note Importanti

- Le immagini devono essere **esattamente 1024x1024 px**
- Usa PNG di alta qualità (non compresse troppo)
- L'icona foreground dovrebbe avere **sfondo trasparente**
- Testa l'icona su diversi dispositivi/temi (chiaro/scuro)
- Per Android 13+, le icone adaptive sono obbligatorie

### 📚 Documentazione

- Flutter Launcher Icons: https://pub.dev/packages/flutter_launcher_icons
- Android Icon Guidelines: https://developer.android.com/distribute/google-play/resources/icon-design-specifications
- iOS Icon Guidelines: https://developer.apple.com/design/human-interface-guidelines/app-icons
