# Installer help

`make install` or `./scripts/install.sh` builds the plugin and copies `main.js` and
`manifest.json` into the selected Obsidian vault at
`.obsidian/plugins/daily-note-key-plugin/`.

The installer asks for the vault root interactively. The path must contain an
existing `.obsidian` directory. Existing copies of the two plugin artefacts in
the destination are replaced.

Options:

- `--help`, `-h`: display this help.
- `--version`: display the installer version.
- `--dry-run`: validate the vault path and report the planned build and copy
  without changing the vault or generating a build artefact.
