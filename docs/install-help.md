# Installer help

`make install` runs `./scripts/install.sh`, which copies the existing `main.js`,
`manifest.json`, and `styles.css` into the selected Obsidian vault at
`.obsidian/plugins/daily-note-key-plugin/`.

The repository does not build or bundle the plugin. The three plugin files must
already exist before installation.

The installer asks for the vault root interactively. The path must contain an
existing `.obsidian` directory. Existing copies of the three plugin artefacts in
the destination are replaced.

Options:

- `--help`, `-h`: display this help.
- `--version`: display the installer version.
- `--dry-run`: validate the vault path and report the planned copy without
  changing the vault.
