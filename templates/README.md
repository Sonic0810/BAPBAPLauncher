# Templates

These templates help you add new BAPHub content quickly.

- `index.template.json`: root manifest skeleton
- `game-versions.template.json`: official versions schema (tracks + manifest IDs)
- `package.template.json`: package metadata
- `version.template.json`: installable file list with mandatory SHA-256

All download targets must be `https` and every file entry needs `sha256`.

## Visual effect tags

Use `visual.tags` in `package.json` / `packages.json`:

- visible: `shiny`, `holo`, `neon`, `frost`, `ember`, `prism`, `glitch`, `aurora`
- hidden: `hidden_shiny`, `hidden_holo`, `hidden_neon`, `hidden_frost`, `hidden_ember`, `hidden_prism`, `hidden_glitch`, `hidden_aurora`

`hidden_*` applies the effect without rendering a visible tag chip.

German authoring guide:

`docs/BAPHub-Content-Authoring-DE.md`
