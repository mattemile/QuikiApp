# Creare un'Icona Placeholder Veloce

## Opzione 1: Online (Più Facile)

Vai su: **https://www.appicon.co/**

1. Carica un'immagine quadrata (o crea una semplice con la "Q" di QuikiApp)
2. Clicca "Generate"
3. Scarica `app_icon.png` (1024x1024)
4. Metti il file in questa cartella (`assets/icon/`)

## Opzione 2: Con Canva (Raccomandato)

1. Vai su https://www.canva.com/
2. Crea un design → Custom size → 1024x1024
3. Aggiungi:
   - Sfondo blu scuro (#1A237E)
   - Cerchio arancione (#FF6F00) al centro
   - Lettera "Q" bianca grande
4. Download → PNG → Download
5. Salva come `app_icon.png` in questa cartella

## Opzione 3: Icona Semplice con Paint/GIMP

### Windows Paint:
1. Apri Paint
2. Resize → 1024x1024 pixels
3. Riempi con colore blu scuro
4. Aggiungi testo "Q" grande in arancione
5. Salva come PNG

### GIMP (Gratis):
1. File → New → 1024x1024
2. Riempi livello con #1A237E
3. Aggiungi testo "Q" (Arial Black, 400pt, #FF6F00)
4. File → Export As → app_icon.png

## Design Suggerito per QuikiApp

```
┌─────────────────────────────────┐
│                                 │
│        SFONDO BLU SCURO         │
│          (#1A237E)              │
│                                 │
│            ┌───┐                │
│            │ Q │ ← Arancione    │
│            └───┘   (#FF6F00)    │
│                                 │
│     Con bordo arrotondato       │
│                                 │
└─────────────────────────────────┘
```

## Template SVG (Convertibile in PNG)

Salva questo come `icon_template.svg` e aprilo in un browser, poi screenshot a 1024x1024:

```svg
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="1024" height="1024" fill="#1A237E" rx="200"/>

  <!-- Orange Circle -->
  <circle cx="512" cy="512" r="280" fill="#FF6F00"/>

  <!-- Q Letter -->
  <text x="512" y="650" font-family="Arial Black" font-size="400"
        fill="#FFFFFF" text-anchor="middle" font-weight="bold">Q</text>
</svg>
```

## Dopo aver creato l'icona

```bash
# Assicurati che il file sia in: assets/icon/app_icon.png
# Poi esegui:

flutter pub get
dart run flutter_launcher_icons
```

Questo genererà automaticamente tutte le icone necessarie!
