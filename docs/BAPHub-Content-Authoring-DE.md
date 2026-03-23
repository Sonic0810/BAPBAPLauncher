# BAPHub Content Authoring (DE) - V8.1.4

Diese Anleitung zeigt, wie du neue Inhalte fuer den BAPBAP Launcher im BAPHub-Repo pflegst.

## 1) Schnellstart

1. Dateien fuer eine neue Version unter `manifest/channels/release/<package-id>/versions/<version>/files/` ablegen.
2. SHA-256 fuer jede Datei berechnen.
3. `version.json` erstellen.
4. `package.json` aktualisieren.
5. `packages.json` aktualisieren.
6. Bilder unter `manifest/assets/packages/` ablegen.
7. Push nach `main`, dann den Launcher neu starten oder den Dev-/Review-Build neu laden.

## 2) Struktur

```text
manifest/
  index.json
  game-versions.json
  assets/
    instances/
    packages/
  channels/
    release/
      packages.json
      <package-id>/
        package.json
        versions/
          <version>/
            version.json
            files/
```

## 3) Pflichtdateien pro Paket

- `packages.json`: Kachel/Liste im Channel
- `<package-id>/package.json`: Detaildaten
- `<package-id>/versions/<version>/version.json`: installierbare Dateien + Hash

Beispiel `files[]` in `version.json`:

```json
{
  "schemaVersion": 1,
  "id": "my.cool.mod",
  "version": "1.0.0",
  "files": [
    {
      "sourcePath": "files/MyCoolMod.dll",
      "targetPath": "Mods/MyCoolMod.dll",
      "sha256": "<sha256-hex-lowercase>"
    }
  ]
}
```

SHA-256 berechnen (PowerShell):

```powershell
$h = Get-FileHash -Algorithm SHA256 .\manifest\channels\release\my.cool.mod\versions\1.0.0\files\MyCoolMod.dll
$h.Hash.ToLower()
```

## 4) Track-Support pro Paket (`supportedTracks`)

Mit `supportedTracks` steuerst du, fuer welche Spiel-Tracks ein Paket sichtbar ist.

Zulaessige Werte:

- `bapbap`
- `latest` (nur neueste normale BAPBAP-Version)
- `boss-rush`
- `battle-royale`
- optional konkrete offizielle IDs (z. B. `latest`, `boss-rush`, oder konkrete `instanceId`)

Beispiel:

```json
"supportedTracks": ["bapbap", "latest"]
```

Wenn `supportedTracks` fehlt, ist das Paket fuer alle Tracks sichtbar.

## 5) Optionale Paket-Felder (`links`, `compatibility`)

Ab V8.1.4 sind in `<package-id>/package.json` zusaetzliche optionale Felder erlaubt:

- `links[]` mit `label`, `url`, optional `kind`
- `compatibility` mit optional `tracks[]`, optional `environments[]`, optional `platforms[]`

Kurzes Beispiel:

```json
"links": [
  { "label": "Source", "url": "https://github.com/<owner>/<repo>", "kind": "source" },
  { "label": "Support", "url": "https://discord.gg/<invite>" }
],
"compatibility": {
  "tracks": ["bapbap", "latest"],
  "environments": ["production"],
  "platforms": ["windows-x64"]
}
```

Wenn `links` oder `compatibility` fehlen, bleibt das Paket gueltig (abwaertskompatibel).

## 6) Visual Model (V8.2.4)

`visual` ist optional und kann in `packages.json` und/oder `package.json` gesetzt werden (unveraendert seit V8.1.3).

Unterstuetzte Felder:

- `visual.preset` (`default`, `featured`, `shiny`, `holo`, `neon`, `frost`, `ember`, `prism`, `glitch`, `aurora`, `frozen`, `plasma`, `toxic`, `cosmic`, `vapor`, `storm`, `inferno`, `velvet`, `matrix`, `ghost`, `crystal`, `chrome`, `noir`, `sunset`, `void`, `candy`, `dev`, `event`)
- `visual.tags[]` (kurze visuelle Marker, inkl. hidden-Tokens)
- `visual.badges[]` mit `text`, optional `color`, optional `textColor`
- `visual.ribbon` mit `text`, optional `color`, optional `textColor`
- `visual.frame` mit optional `borderColor`, optional `glowColor`, optional `pulse`
- `visual.overlay` mit optional `surfaceColor`, optional `accentColor` (Hex)

Beispiel:

```json
  "visual": {
    "preset": "shiny",
    "tags": ["shiny", "new", "community-pick"],
  "badges": [
    { "text": "Shiny", "color": "#f59e0b", "textColor": "#1f1300" },
    { "text": "Limited", "color": "#ef4444", "textColor": "#ffffff" }
  ],
  "ribbon": { "text": "DEV", "color": "#7c3aed", "textColor": "#ffffff" },
  "frame": {
    "borderColor": "#ff1e78",
    "glowColor": "#ff1e78",
    "pulse": true
  },
  "overlay": {
    "surfaceColor": "#343844",
    "accentColor": "#ff1e78"
  }
}
```

### Effekt-Tags (sichtbar vs hidden)

- Sichtbare Effekt-Tags:
  `shiny`, `holo`, `neon`, `frost`, `ember`, `prism`, `glitch`, `aurora`,
  `frozen`, `plasma`, `toxic`, `cosmic`, `vapor`, `storm`, `inferno`, `velvet`,
  `matrix`, `ghost`, `crystal`, `chrome`, `noir`, `sunset`, `void`, `candy`
- Hidden-Varianten:
  `hidden_<token>` fuer jeden der obigen Tokens, z. B. `hidden_shiny`, `hidden_frozen`, `hidden_matrix`
- Hidden-Varianten aktivieren den Effekt, blenden aber den Tag-Chip/Auto-Badge aus.
- Alle `hidden_*` Tokens sind reine Style-Tokens und werden im Launcher nicht als sichtbare Tag-Chips gerendert.
- V8.2.4 rendert Effekte in drei Schichten: statischer Stil + Motion + Partikel. Partikel laufen nur auf aktiven Karten (Hover/Auswahl/Overlay), damit die Performance stabil bleibt.
- V8.2.5 erweitert die Partikel intern um stilbezogene Achsen (Pattern/Blend/Alpha/Spawn/Size/Noise), damit Tokens visuell klar unterscheidbar sind.

Empfohlene Nutzung:

- `shiny`: cleaner diagonaler Schimmer (dezenter Specular-Glanz).
- `frozen`: starker Ice-Look, kalt und kristallig.
- `plasma`: violett/elektrisch, energiereich.
- `toxic`: gruen/acid, radioaktiver Stil.
- `cosmic`: tiefer Space-Look mit breiten Farbnebeln.
- `vapor`: pink/cyan Retro-Wave.
- `storm`: dunkler elektro-storm Look.
- `inferno`: heisser rot/orange Flare.
- `velvet`: dunkler violetter Soft-Glow.
- `matrix`: digital gruen mit Scanline-Charakter.
- `ghost`: bleich/transluzent und leise.
- `crystal`: cyan-blau, sauberer Crystal-Glanz.
- `chrome`: metallisch/silber.
- `noir`: dunkler low-gloss Look.
- `sunset`: orange/pink Abendgradient.
- `void`: dunkler Deep-Space Stil.
- `candy`: bunter sweet-pop Look.

## 7) Legacy-Felder (noch 1 Release unterstuetzt)

Diese alten Felder sind legacy, bleiben aber fuer eine weitere Release-Version kompatibel:

- `visual.badgeText`
- `visual.badgeColor`
- `visual.ribbonText`
- `visual.ribbonColor`
- `visual.borderColor`
- `visual.glowColor`

Migration:

- `badgeText`/`badgeColor` -> `badges[0].text`/`badges[0].color`
- `ribbonText`/`ribbonColor` -> `ribbon.text`/`ribbon.color`
- `borderColor`/`glowColor` -> `frame.borderColor`/`frame.glowColor`

## 8) Best Practices

- Maximal 1 bis 2 Badges pro Karte.
- Hoher Farbkontrast fuer Badge-/Ribbon-Text.
- `thumbnailPath` fuer Grid/Liste (klein, gerne quadratisch).
- `heroImagePath` fuer die grosse Detailbuehne nutzen, wenn du ein echtes Hero-Bild hast.
- `imagePath` bleibt der normale Card-/Fallback-Assetpfad.
- `gallery` nur fuer zusaetzliche Bilder verwenden; `gallery[0]` wird nicht mehr automatisch als Hero genommen.
- Wenn nur ein kleines Icon oder dieselbe Datei fuer `imagePath` und `thumbnailPath` existiert, faellt der Launcher auf eine kompakte Detaildarstellung zurueck.
- `supportedTracks` gezielt nutzen, damit Boss-Rush/Battle-Royale sauber getrennt bleiben.
- `thumbnailPath` fuer Cards besser quadratisch (z. B. 512x512), damit `object-contain` sauber wirkt.
- `visual.overlay.surfaceColor` auf dunkle, solide Hex-Farbe setzen (Default im Launcher: `#343844`).

## 8.1) Sichtbarkeit, Secret Mods und Passwort-Flow

Wenn ein Paket aktuell ganz normal sichtbar sein soll, **nichts** dafuer setzen.

Wenn ein Paket spaeter als Secret-Mod verborgen sein soll, nutze im Manifest:

```json
"visibility": "secret"
```

Das Feld kann in `packages.json` und im `package.json` des Pakets gesetzt werden. Der Launcher behandelt `visibility: "secret"` als eigentliche Sichtbarkeits-Wahrheit.

Wichtig:

- `visual.ribbonTags: ["secret"]` ist **nur** ein visuelles Ribbon und versteckt das Paket nicht automatisch.
- Wenn du ein Paket wirklich verbergen willst, nimm `visibility: "secret"`.
- Wenn du **nur** einen Ribbon willst, aber das Paket sichtbar bleiben soll, nutze nur das Ribbon und **kein** `visibility`.

### Secret-Gruppen und Passwort-Hashes

Secret-Mods koennen zusaetzlich einer Unlock-Gruppe zugeordnet werden:

```json
"secretUnlockId": "easter-egg"
```

Das Feld ist optional. Wenn es fehlt, nutzt der Launcher intern die Default-Gruppe `default`.

Die erlaubten Passwoerter liegen im Root-Manifest `manifest/index.json` unter `secretUnlocks[]`:

```json
"secretUnlocks": [
  {
    "id": "easter-egg",
    "label": "Easter Egg Mods",
    "passwordSha256": "<sha256-hex-lowercase>"
  }
]
```

Der Launcher vergleicht **nicht** Klartext im Manifest, sondern nur den SHA-256-Hash.

PowerShell-Beispiel zum Berechnen:

```powershell
$text = "meinpasswort"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
$hash = [System.Security.Cryptography.SHA256]::HashData($bytes)
([System.BitConverter]::ToString($hash) -replace "-", "").ToLower()
```

Praktisch bedeutet das:

- `visibility: "secret"` entscheidet, ob ein Paket versteckt startet
- `secretUnlockId` entscheidet, welche Secret-Gruppe es freischaltet
- `manifest/index.json > secretUnlocks[]` entscheidet, welcher Passwort-Hash zu welcher Gruppe gehoert

Wenn gerade **keine** Mod verborgen sein soll, setze einfach **keine** `visibility: "secret"`-Felder.

## 8.2) Zeitgesteuerte Geschenk-/Unboxing-Karten

Pakete koennen bis zu einer festen UTC-Zeit versiegelt und nicht installierbar bleiben.

Dafuer im Paket:

```json
"unlockAtUtc": "2026-12-24T18:00:00Z"
```

Dann zeigt der Launcher die Karte als gesperrt/verpackt an und schaltet sie erst frei, wenn die vertrauenswuerdige Netzwerkzeit erreicht ist.

### Vertrauenswuerdige Zeitquelle

Im Root-Manifest `manifest/index.json` muss dafuer eine `timeSourceUrl` gesetzt sein:

```json
"timeSourceUrl": "https://raw.githubusercontent.com/Sonic0810/BAPBAPLauncher/main/manifest/index.json"
```

Der Launcher liest von dort den HTTP-`Date`-Header und verwendet **nicht** einfach blind die lokale Windows-Uhr.

Das ist wichtig fuer:

- Advent-/Event-Drops
- Geschenke mit Countdown
- exakte Freischaltmomente ueber GitHub/HTTP

### Typisches Beispiel

```json
{
  "id": "my.cool.mod",
  "name": "Holiday Surprise",
  "visibility": "public",
  "unlockAtUtc": "2026-12-24T18:00:00Z"
}
```

Das Paket bleibt sichtbar, aber bis zur Zeit gesperrt.

Wenn du eine Mod **sowohl** geheim als auch spaeter freischaltbar machen willst:

```json
{
  "visibility": "secret",
  "unlockAtUtc": "2026-12-24T18:00:00Z"
}
```

## 8.3) Ribbon-Tags

Ribbons werden ueber `visual.ribbonTags` gesetzt:

```json
"visual": {
  "ribbonTags": ["host-only"]
}
```

Aktuell sinnvolle Ribbon-Tags:

- `host-only`
- `secret`
- `featured`
- `recommended`
- `new`
- `experimental`
- `beta`
- `hot`
- `sneakpeek`

Wichtig:

- `update-available` wird **nicht** manuell im Manifest gesetzt. Das Ribbon entsteht dynamisch, wenn eine installierte Version aelter als `latestVersion` ist.
- Auf Mod-Karten zeigt der Launcher immer nur **ein** primaeres Ribbon.
- `UPDATE` hat Vorrang vor `HOST ONLY`, wenn eine Host-Only-Mod veraltet installiert ist.

### Host-Only Beispiel

```json
"visual": {
  "ribbonTags": ["host-only"]
}
```

### Featured-Beispiel

```json
"visual": {
  "ribbonTags": ["featured"]
}
```

## 8.4) Bilder fuer Karten, Detailseite und Galerie

Empfohlene Rollen:

- `thumbnailPath`: Grid-/Listenbild
- `imagePath`: normale Hauptgrafik / Fallback
- `heroImagePath`: grosses Bild fuer die Mod-Detailseite
- `gallery`: zusaetzliche Bilder

Beispiel:

```json
"thumbnailPath": "../../assets/packages/my-mod-thumb.png",
"imagePath": "../../assets/packages/my-mod-card.png",
"heroImagePath": "../../assets/packages/my-mod-hero.png",
"gallery": [
  "../../assets/packages/my-mod-shot-1.png",
  "../../assets/packages/my-mod-shot-2.png"
]
```

Wichtig:

- `heroImagePath` ist die beste Wahl fuer die grosse Mod-Page.
- `gallery[0]` wird **nicht** automatisch mehr als Hero missbraucht.
- Wenn `imagePath` und `thumbnailPath` dieselbe kleine Datei sind, schaltet der Launcher auf den kompakten Art-Modus um.
- Kleine Icons werden dann bewusst kleiner gezeigt statt haesslich auf die ganze Buehne gezogen.

## 8.5) `packages.json` vs `package.json`

Faustregel:

- `packages.json` = Listen-/Kachel-Infos fuer den Channel
- `<package-id>/package.json` = volle Detailseite

Wenn moeglich, halte folgende Felder in beiden konsistent:

- `name`
- `summary`
- `thumbnailPath`
- `imagePath`
- `latestVersion`
- `visibility`
- `unlockAtUtc`
- `visual`

## 9) Validierung

- Nur `https`-Downloads.
- Jeder `files[]`-Eintrag braucht `sha256`.
- Keine unsicheren Zielpfade (`..`, absolute Pfade).
- Launcher Settings -> `Test Connection`: Root OK, Game versions OK, Boss Rush vorhanden.
- Launcher Settings -> `Content-Effekte` -> `Effekt-Testkarte anzeigen`:
  damit kannst du jeden Token live pruefen, ohne echte Paketdaten umzubauen.
- Optional: `Partikel-Debug-Overlay anzeigen` zeigt Pattern/Spawn/Blend/FPS fuer die Testkarte.

## 10) Offizielle Versionen direkt als ZIP hosten (ohne SteamCMD)

In `manifest/game-versions.json` kannst du pro offizieller Version optional direkte ZIP-Downloads definieren:

- `directDownloadUrl` (HTTPS, z. B. GitHub Raw URL zur ZIP)
- `directDownloadSha256` (empfohlen, Integritaetspruefung)
- `directDownloadFileName` (optional)

Beispiel (GitHub Release Asset):

```json
{
  "id": "latest",
  "track": "bapbap",
  "gameVersion": "build-2025-08-19-750068",
  "steamManifestId": "3691247073315750068",
  "directDownloadUrl": "https://github.com/Sonic0810/BAPBAPLauncher/releases/download/depots-v1/latest.zip",
  "directDownloadSha256": "<sha256-hex>"
}
```

Verhalten im Launcher:

- Wenn `directDownloadUrl` gesetzt ist, wird diese ZIP direkt geladen und entpackt.
- Wenn nicht gesetzt, faellt der Launcher auf SteamCMD/DepotDownloader zurueck.
