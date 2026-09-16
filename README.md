# Daily Note Key

This is a very simple Obsidian plugin: a ribbon button and a configurable
keyboard shortcut that open one pre-selected note. That is all.

The note can be any Markdown note in the vault. I use this for my "today" note,
which is always the same file (not to be confused with daily notes), hence the
name.

The plugin ID is `today-note-custom-hotkey`. It is intended for macOS and iOS.
The plugin does not create or modify notes, and has no network,
telemetry, URL-scheme, widget, template, or synchronization integration.

## Use

1. Enable **Daily Note Key** in Obsidian's Community plugins settings.
2. Open its settings and select **Choose note**. Search the vault's Markdown
   files and select the note to open. The stored path includes its folders.
3. In Obsidian's **Hotkeys** settings, find **Daily Note Key: Open today note**
   and assign a shortcut.
4. Open the note with that shortcut, the **Open today note** command, or the
   calendar icon in Obsidian's ribbon. The icon is also the in-app access route
   intended for iOS.

The selected path persists in plugin settings; Obsidian manages the hotkey.
The settings reset control clears the selection. **Back** closes settings.

If no note is selected, or the selected path no longer exists, the ribbon icon
shows a red warning triangle. Attempting to open it displays a notice. After
moving or renaming the note, select it again: the plugin does not follow renames
or create a replacement.

## Installation and compatibility

Community-directory publication is in preparation. The intended platforms are
macOS and iOS using current stable Obsidian versions. The minimum supported
version and platform checks still need release validation.

For manual installation, place these repository files together in
`<vault>/.obsidian/plugins/today-note-custom-hotkey/`:

- `main.js`
- `manifest.json`
- `styles.css`

Reload Obsidian and enable **Daily Note Key** under Community plugins.
Installing again replaces these three files while retaining plugin settings.
For a vault using a custom configuration directory, substitute that directory
for `.obsidian`; the Bash installer below supports the default directory only.

Earlier local installations used ID `daily-note-key-plugin`. When moving to
the new ID, disable the old installation first, enable the new installation,
select the note again, and reassign its hotkey. The installer leaves the old
directory and settings untouched; it does not migrate them.

## Privacy

The plugin stores only the selected vault-relative note path in its settings.
It lists Markdown file paths for selection and asks Obsidian to open the exact
file. It does not read note contents, modify notes, contact external services,
collect telemetry, or require an account.

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

`main.js` is the maintained plain-JavaScript entry file; no compilation, Node.js,
or npm installation is needed. With `oxlint` installed, `make lint` checks it.

The release files are the same three files listed above. A future GitHub release
must attach them individually and use a tag matching `manifest.json`'s version.

Marketplace preparation is tracked in
[W002 - marketplace prep](specs/002-marketplace-prep/spec.org).

## Licence

[MIT](LICENSE). Copyright (c) 2026 Taḋg.
