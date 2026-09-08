# Installer help

`make install` or `./scripts/install.sh` copies the existing `main.js` and
`manifest.json` into the selected Obsidian vault at
`.obsidian/plugins/daily-note-key-plugin/`.

Build the plugin separately with `make build` before installing it.

The installer asks for the vault root interactively. The path must contain an
existing `.obsidian` directory. Existing copies of the two plugin artefacts in
the destination are replaced.

Options:

- `--help`, `-h`: display this help.
- `--version`: display the installer version.
- `--dry-run`: validate the vault path and report the planned copy without
  changing the vault.
