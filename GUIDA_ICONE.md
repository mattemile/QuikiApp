# 🎨 Guida Rapida: Aggiungere la Tua Icona

## ✅ Passi da Seguire

### 1. Prepara la tua immagine

**Requisiti:**
- Formato: PNG
- Dimensione: **1024x1024 pixel**
- Nome file: `app_icon.png`

Se la tua immagine non è 1024x1024, ridimensionala:
- Online: https://www.iloveimg.com/resize-image
- Oppure usa Paint/GIMP/Photoshop

### 2. Copia l'immagine nella cartella giusta

```
Copia il tuo file app_icon.png in:
📁 c:\_TEST\QuikiApp\assets\icon\app_icon.png
```

### 3. Installa le dipendenze

```bash
flutter pub get
```

### 4. Genera tutte le icone

```bash
dart run flutter_launcher_icons
```

Questo comando genererà automaticamente:
- ✅ Tutte le icone Android (5 dimensioni + adaptive)
- ✅ Tutte le icone iOS (AppIcon completo)
- ✅ Favicon e icone web
- ✅ Icone maskable per PWA

### 5. Ricompila l'app

```bash
flutter build apk --release
```

## 📱 Risultato

Dopo questi passi, la tua icona sarà visibile:
- Nell'app drawer Android
- Nella home screen iOS
- Come favicon nel browser (web)
- In tutti gli store (Google Play, App Store)

## 🎯 Opzionale: Icona Adaptive per Android

Se vuoi un risultato migliore su Android 8+, puoi creare anche:

**`app_icon_foreground.png`** (1024x1024, sfondo trasparente)

Poi decommentare nel `pubspec.yaml` le righe:
```yaml
# adaptive_icon_background: "#1A237E"
# adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

E ri-eseguire: `dart run flutter_launcher_icons`

## 🔄 Per Cambiare l'Icona in Futuro

1. Sostituisci `app_icon.png` con la nuova immagine
2. Esegui: `dart run flutter_launcher_icons`
3. Ricompila: `flutter build apk`

## ❓ Problemi Comuni

**"File not found"**
→ Assicurati che il file sia esattamente in `assets/icon/app_icon.png`

**"Invalid image size"**
→ L'immagine deve essere esattamente 1024x1024 px

**"Icona non cambia nell'emulatore"**
→ Disinstalla l'app e reinstallala

**"Command not found: dart run"**
→ Assicurati di aver eseguito `flutter pub get` prima

## 📚 Maggiori Info

README completo: `assets/icon/README.md`
