# BAPHub Doku (DE): Inhalte für den BAPBAP Launcher hinzufügen

Diese Anleitung zeigt dir, wie du neue Inhalte in dein BAPHub-Repo einpflegst:

- neue offizielle Versionen (BAPBAP/Boss Rush)
- neue Pakete (Mod, Map, Playlist, Model, Tool, Content)
- Bilder, Beschreibung, Autoren, Tags
- Multi-File-Installationen mit Hash-Check

## 1) Voraussetzungen

- Dein GitHub-Repo (Backend): `https://github.com/Sonic0810/BAPBAPLauncher`
- Manifest-Root im Repo:
  - `manifest/index.json`
  - `manifest/game-versions.json`
  - `manifest/channels/...`
- Launcher-Default-URL:
  - `https://raw.githubusercontent.com/Sonic0810/BAPBAPLauncher/main/manifest/index.json`

## 2) Ordnerstruktur (empfohlen)

```text
manifest/
  index.json
  game-versions.json
  assets/
    instances/
    packages/
  channels/
    release/
      channel.json
      packages.json
      <package-id>/
        package.json
        versions/
          <version>/
            version.json
            files/
              ...
melonloader/
  0.7.2-ci.2388/
    MelonLoader.Windows.x64.CI.Release.zip
    MelonLoader.Windows.x86.CI.Release.zip
tools/
  generate-game-versions.ps1
```

## 3) Neue offizielle Spielversionen eintragen

Die offiziellen Instanzen kommen aus `manifest/game-versions.json`.

- `track = "bapbap"`: normale Builds
- `track = "boss-rush"`: Boss-Rush-Tab
- Boss Rush Manifest-ID:
  - `9199065605303375081`

`latest` wird im Launcher über das neueste `releaseDateUtc` im `bapbap`-Track markiert.

Wenn du eine CSV hast (`depot_id,seen_date_utc,manifest_id`), nutze:

```powershell
pwsh ./tools/generate-game-versions.ps1 -InputCsv .\versions.csv -OutputJson .\manifest\game-versions.json
```

## 4) Neues Paket hinzufügen (Beispiel)

### Schritt A: Paketdateien ablegen

Beispiel:

```text
manifest/channels/release/my.cool.mod/versions/1.0.0/files/MyCoolMod.dll
```

### Schritt B: SHA-256 berechnen

```powershell
$h = Get-FileHash -Algorithm SHA256 .\manifest\channels\release\my.cool.mod\versions\1.0.0\files\MyCoolMod.dll
$h.Hash.ToLower()
```

### Schritt C: `packages.json` erweitern

Datei: `manifest/channels/release/packages.json`

```json
{
  "id": "my.cool.mod",
  "type": "mod",
  "name": "My Cool Mod",
  "summary": "Kurze Zusammenfassung",
  "description": "Längere Beschreibung",
  "imagePath": "../../../assets/packages/my-cool-mod-cover.png",
  "packageManifestPath": "my.cool.mod/package.json",
  "tags": ["qol", "ui"],
  "featured": false
}
```

### Schritt D: `package.json` anlegen

Datei: `manifest/channels/release/my.cool.mod/package.json`

```json
{
  "schemaVersion": 1,
  "id": "my.cool.mod",
  "type": "mod",
  "name": "My Cool Mod",
  "summary": "Kurze Zusammenfassung",
  "description": "Längere Beschreibung",
  "imagePath": "../../../assets/packages/my-cool-mod-cover.png",
  "gallery": [
    "../../../assets/packages/my-cool-mod-1.png"
  ],
  "authors": [
    {
      "name": "DeinName",
      "profileUrl": "https://github.com/DeinName",
      "role": "Author"
    }
  ],
  "requirements": [
    {
      "text": "MelonLoader 0.7.2-ci.2388 erforderlich",
      "type": "melonloader_version",
      "value": "0.7.2-ci.2388",
      "severity": "warning"
    }
  ],
  "latestVersion": "1.0.0",
  "versions": [
    {
      "version": "1.0.0",
      "changelog": "Initial release",
      "versionManifestPath": "versions/1.0.0/version.json"
    }
  ]
}
```

### Schritt E: `version.json` anlegen

Datei: `manifest/channels/release/my.cool.mod/versions/1.0.0/version.json`

```json
{
  "schemaVersion": 1,
  "id": "my.cool.mod",
  "version": "1.0.0",
  "files": [
    {
      "sourcePath": "files/MyCoolMod.dll",
      "targetPath": "Mods/MyCoolMod.dll",
      "sha256": "<sha256-hex-lowercase>",
      "description": "Main mod dll"
    }
  ]
}
```

## 5) Multi-File / Extra Files (Levels, Configs, Tools)

Du kannst beliebig viele Dateien pro Version installieren:

```json
"files": [
  {
    "sourcePath": "files/MyCoolMod.dll",
    "targetPath": "Mods/MyCoolMod.dll",
    "sha256": "..."
  },
  {
    "sourcePath": "files/default-config.json",
    "targetPath": "UserData/MyCoolMod/config.json",
    "sha256": "..."
  },
  {
    "sourcePath": "files/arena.level",
    "targetPath": "Levels/Arena/arena.level",
    "sha256": "..."
  }
]
```

Sicherheitsregeln im Launcher:

- nur `https`-Downloads
- `sha256` pro Datei Pflicht
- keine absoluten Pfade / kein `..`

## 6) Tools-Tab

Wenn `type = "tool"`-Pakete vorhanden sind, erscheinen sie im Tools-Bereich.
Wenn keine vorhanden sind, zeigt der Launcher `Coming Soon`.

## 7) MelonLoader (automatisch, feste Version)

Im Root-Manifest ist MelonLoader fix auf `0.7.2-ci.2388`.

- Nach offiziellem Download wird MelonLoader automatisch installiert/repariert.
- Beim Launch-Preflight wird der Zustand erneut geprüft.

Pfad in `manifest/index.json`:

```json
"melonLoader": {
  "requiredVersion": "0.7.2-ci.2388",
  "x64": { "url": "...", "sha256": "..." },
  "x86": { "url": "...", "sha256": "..." }
}
```

## 8) Test-Checkliste

1. `manifest/index.json` per Raw-URL erreichbar?
2. `manifest/game-versions.json` erreichbar?
3. Paketbilder (`manifest/assets/...`) erreichbar?
4. `files[].sha256` korrekt?
5. Launcher Settings -> `Test Connection`:
   - Root OK
   - Game versions OK
   - Boss Rush vorhanden
6. Paket installieren und prüfen, ob Dateien im Zielpfad landen.

## 9) Typische Fehler

- `No official versions available`: meist falsche Manifest-URL oder falscher relativer Pfad.
- 404 auf Paketbilder: `imagePath` relativ zur referenzierenden JSON falsch.
- Install schlägt fehl: Hash passt nicht oder `targetPath` unsicher.

## 10) Kurzworkflow (empfohlen)

1. Datei(en) unter `versions/<ver>/files/` ablegen.
2. SHA-256 berechnen.
3. `version.json` erstellen.
4. `package.json` aktualisieren.
5. `packages.json` Eintrag anlegen.
6. Bilder in `manifest/assets/packages/` ablegen.
7. Push nach `main`.

## 11) Visual-Effekte (`visual.tags`)

Du kannst pro Paket visuelle Effekte setzen:

- sichtbare Tokens: `shiny`, `holo`, `neon`, `frost`, `ember`, `prism`, `glitch`, `aurora`
- hidden Tokens: `hidden_shiny`, `hidden_holo`, `hidden_neon`, `hidden_frost`, `hidden_ember`, `hidden_prism`, `hidden_glitch`, `hidden_aurora`

`hidden_*` aktiviert den Effekt, ohne dass der Tag als Chip angezeigt wird.

Beispiel:

```json
"visual": {
  "tags": ["hidden_prism"]
}
```
8. Im Launcher `Refresh` drücken.
