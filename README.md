# daily-note-key-plugin

`daily-note-key-plugin` opens one fixed, user-selected Obsidian vault note from
a configurable keyboard shortcut or a small in-app icon on macOS and iOS.

The target is not an Obsidian Daily Note: it is one undated file whose filename
does not change. The plugin does not create or modify notes, and has no network,
telemetry, URL-scheme, widget, template, or synchronization integration.

## Project documents

- [Vision](docs/VISION.md) describes purpose, scope, constraints, and deferred
  product decisions.
- [Architecture](docs/ARCHITECTURE.md) describes the Obsidian boundary,
  technology choices, data flows, and operational ownership.
- [Foundation review](docs/foundation-review.org) records the self-review and
  project-owner sign-off.

## Local installation

Run the installer from the project root. `make install` asks for the Obsidian
vault root and copies the existing plugin artefacts into the vault's standard
community-plugin directory.

```bash
make install
```

Use `./scripts/install.sh --dry-run` to validate the vault path and preview the
destination without copying files. The Bash installer is copy-only.
