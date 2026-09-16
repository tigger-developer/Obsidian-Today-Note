# Architecture

<!-- Version: 0.3.1 | Last updated: 2026-09-16 -->

## Architectural boundary

`today-note-custom-hotkey` is an Obsidian community-plugin-style package running
inside Obsidian on macOS and iOS. Obsidian owns the vault, note rendering,
editing interface, command palette, keyboard binding, plugin settings storage,
and plugin lifecycle.

The plugin owns only the configuration needed to identify one selected note,
the command that opens it, and the in-app icon that invokes that command. It
does not own note content, vault backup, synchronization, or deployment.

## Components and flows

- **Settings component** presents selection of one file from the current
  Obsidian vault, persists the selected note path through the standard plugin
  settings mechanism, and offers controls to clear the selection and to close
  the settings view. Keyboard shortcuts are assigned in Obsidian's own Hotkeys
  settings and are not stored by the plugin.
- **Open-note command** resolves the configured file through Obsidian's public
  vault/file APIs and asks Obsidian to open it in its standard interface.
- **macOS/iOS icon** is registered through Obsidian's public ribbon or
  equivalent in-app command surface and invokes the same open-note action.
- **Status component** reflects whether the configured file can currently be
  resolved. An unresolved file uses a red icon, a warning glyph, and a
  descriptive accessible label, and is refreshed on vault create, delete, and
  rename events.
- **Lifecycle component** registers commands, icon handlers, settings, and
  status updates through Obsidian's `Plugin` and `Component` lifecycle APIs and
  releases them when the plugin unloads.

The flow is:

1. The user selects one file in plugin configuration.
2. The plugin stores that file's vault-relative path in standard Obsidian
   plugin configuration.
3. The user invokes either the keyboard command or the in-app icon.
4. Obsidian opens the selected file in its normal interface.
5. If resolution fails, the icon is red with a warning glyph and the invocation
   raises an Obsidian notice; the plugin does not create or alter a replacement
   note.

## Technology choices

- **Language:** Plain JavaScript in the single `main.js` artefact required by
  Obsidian.
- **Host API:** Obsidian's documented public plugin, component, vault,
  file-management, command, settings, and icon/ribbon APIs only.
- **Platforms:** macOS and iOS. Node.js/Electron APIs are excluded so that the
  plugin does not acquire a desktop-only restriction.
- **Build tooling:** no project-local build or package-manager step. `main.js`
  is the maintained plugin artefact and `oxlint` is the only selected static
  check. Node.js and npm are not part of the project architecture.
- **Release tooling:** a GitHub Actions workflow using pinned action revisions,
  `jq`, and the GitHub CLI. It runs outside the plugin runtime and adds no
  plugin dependency.
- **Testing:** lightweight source-level linting and bounded user testing in
  Obsidian are proportionate. A browser harness, compiler, package manager, or
  new test framework is not part of the foundation.

## Data and trust boundaries

The plugin receives a file selection from the user and persists only that
selection in Obsidian's plugin configuration. It reads file identity and
availability through Obsidian's vault APIs and requests opening through
Obsidian. Note contents remain under Obsidian's ownership and are not written
by this plugin.

At runtime there is no network boundary, remote content, telemetry, credential,
secret, external file access, or child process. The plugin must not use direct
filesystem access to resolve or open the note.

The stored reference is the vault-relative path that Obsidian's public vault
APIs expose for the selected file, not a filesystem absolute path. The earlier
product wording described an "absolute path"; that wording is satisfied by the
exact file the user selects from the vault, and the architecture permits only
the public, portable host representation.

## Release and attestation boundary

Publication runs entirely outside the plugin runtime, on GitHub's hosted
infrastructure:

- A push to `master` triggers a release job that increments the manifest patch
  version, commits it, pushes an annotated tag atomically, and publishes a
  release carrying exactly `main.js`, `manifest.json`, and `styles.css`.
- A dependent attestation job checks out the published tag without persisting
  checkout credentials, verifies the tag, the manifest version, the exact asset
  set, and byte equality between checkout, tag, and downloaded assets, then
  attests those three files.
- Job permissions are separated: only the release job receives write access to
  repository contents; the attestation job holds read, identity-token, and
  attestation permissions and cannot alter release assets.
- Verification failure must reject the release rather than relax the
  comparison.

## Failure and compatibility behaviour

- A missing, renamed, duplicated-by-name, or otherwise inaccessible target is
  represented by the red warning icon and warning glyph, and invoking the
  command or icon raises an Obsidian notice.
- The plugin does not guess among duplicate names and does not create a file
  when the target is unavailable.
- Obsidian's lifecycle facilities must make enable, disable, reload, and
  repeated initialization safe without duplicate commands, icons, handlers, or
  timers.
- Unsupported optional host capabilities must be detected and reported through
  the owning Obsidian interface rather than failing through desktop-only APIs.

The declared `minAppVersion` is `1.13.0`. It is the recorded support baseline,
not yet confirmed by version-specific compatibility testing.

## Deployment and ownership

There is no build step: the maintained source files are the released files.
The release workflow publishes and attests them automatically. Installation
into a vault is a manual copy, either through the repository's copy-only
installer or by placing the three released files in the vault's plugin
directory. Obsidian is the host and owns installation, vault storage, backup,
synchronization, and rollback.

Submission to the Obsidian community directory is outside the current
deployment boundary and requires a product decision that has not been taken.

## Architectural trade-offs

- **Public host APIs over filesystem access:** this preserves macOS/iOS
  portability and Obsidian ownership, at the cost of resolving the path using
  the representation the host exposes rather than an assumed filesystem path.
- **One shared open action over separate platform implementations:** this
  keeps keyboard and icon behaviour aligned and limits lifecycle state.
- **User testing over a browser harness:** host-specific opening and icon
  presentation need real Obsidian judgement, while a new harness would add
  disproportionate dependency and maintenance cost for this plugin's size.
- **Minimal dependencies over convenience packages:** the build remains
  smaller and reduces supply-chain exposure; formatting and linting tools are
  selected only when they can be pinned and maintained.
- **Release per push over curated releases:** every `master` push produces one
  attested patch release, which keeps published bytes traceable to tagged
  source at the cost of releases for documentation-only changes.

## Foundation status

The foundation review is recorded in
[`docs/foundation-review.org`](foundation-review.org). Feature-level behaviour,
acceptance criteria, and implementation tasks belong in a separately approved
change specification.

## Document changelog

- **0.3.1, 2026-09-16:** recorded the `minAppVersion` `1.13.0` support
  baseline.
- **0.3.0, 2026-09-16:** corrected the settings component and data boundary to
  the stored note path only, recorded the notice raised for an unresolved
  target, settled the vault-relative path representation, added the release and
  attestation boundary, and replaced manual build and deployment with the
  automated release route.
- **0.2.0, 2026-09-08:** plain-JavaScript, no-Node/npm architecture amendment.
- **0.1.0, 2026-09-08:** initial foundation Architecture.
