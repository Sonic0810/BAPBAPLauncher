# BAPHub Backend (BAPBAP Launcher)

This folder is the GitHub-driven backend consumed by the BAPBAP launcher.

## Raw URL

Use this as launcher manifest source:

`https://raw.githubusercontent.com/Sonic0810/BAPBAPLauncher/main/manifest/index.json`

## Included

- `index.json`: root manifest, game info, channels, MelonLoader requirements
- `game-versions.json`: official versions list with tracks
- `channels/release/*`: starter package index + package manifests
- `assets/*`: version/package images

## Boss Rush

Boss Rush is a dedicated track entry and currently pinned to:

`steamManifestId = 9199065605303375081`

## MelonLoader

Required version is fixed to:

`0.7.2-ci.2388`

Artifacts are mirrored under:

`/melonloader/0.7.2-ci.2388/`

## Authoring Guide (DE)

Step-by-step guide for adding versions/packages/files:

`docs/BAPHub-Content-Authoring-DE.md`
