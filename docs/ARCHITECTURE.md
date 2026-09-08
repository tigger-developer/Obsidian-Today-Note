# Architecture

<!-- Version: 0.1.0 | Last updated: 2026-09-08 -->

## Architectural boundary

`daily-note-key-plugin` is an Obsidian community-plugin-style package running
inside Obsidian on macOS and iOS. Obsidian owns the vault, note rendering,
editing interface, command palette, keyboard binding, plugin settings storage,
and plugin lifecycle.

The plugin owns only the configuration needed to identify one selected note,
the command that opens it, and the in-app icon that invokes that command. It
does not own note content, vault backup, synchronization, or deployment.

## Components and flows

- **Settings component** presents selection of one file from the current
  Obsidian vault and persists the selected path and preferred keyboard shortcut
  through the standard plugin settings mechanism.
- **Open-note command** resolves the configured file through Obsidian's public
  vault/file APIs and asks Obsidian to open it in its standard interface.
- **macOS/iOS icon** is registered through Obsidian's public ribbon or
  equivalent in-app command surface and invokes the same open-note action.
- **Status component** reflects whether the configured file can currently be
  resolved. An unresolved file uses a red icon and warning glyph.
- **Lifecycle component** registers commands, icon handlers, settings, and
  status updates through Obsidian's `Plugin` and `Component` lifecycle APIs and
  releases them when the plugin unloads.

The intended flow is:

1. The user selects one file in plugin configuration.
2. The plugin stores the selected file reference and preferred shortcut in
   standard Obsidian plugin configuration.
3. The user invokes either the keyboard command or the in-app icon.
4. Obsidian opens the selected file in its normal interface.
5. If resolution fails, the icon remains visibly red with a warning glyph;
   the plugin does not create or alter a replacement note.

## Technology choices

- **Language:** TypeScript compiled to the JavaScript form required by
  Obsidian.
- **Host API:** Obsidian's documented public plugin, component, vault,
  file-management, command, settings, and icon/ribbon APIs only.
- **Platforms:** macOS and iOS. Node.js/Electron APIs are excluded so that the
  plugin does not acquire a desktop-only restriction.
- **Build tooling:** the standard Obsidian TypeScript plugin scaffold and the
  minimum required Node.js/npm tooling are permitted for building the plugin.
  No additional npm package is to be added when a project-owned implementation
  or existing scaffold is sufficient. Biome and oxlint are preferred for
  formatting and linting where their use fits the selected toolchain.
- **Testing:** lightweight pure-logic validation and bounded user testing in
  Obsidian are proportionate. A browser harness or new test framework is not
  part of the foundation.

Node.js/npm is a development/build dependency choice, not a plugin runtime
service. Its exact supported release, package manager version, lockfile, and
dependency controls belong in the implementation specification and project
profile before implementation.

## Data and trust boundaries

The plugin receives a file selection and shortcut preference from the user and
persists only those settings in Obsidian's plugin configuration. It reads file
identity and availability through Obsidian's vault APIs and requests opening
through Obsidian. Note contents remain under Obsidian's ownership and are not
written by this plugin.

There is no network boundary, remote content, telemetry, credential, secret,
external file access, or child process. The plugin must not use direct
filesystem access to resolve or open the note.

The product request describes the stored file reference as an absolute path,
while the selection is made from an Obsidian vault. The feature specification
must settle whether this means a filesystem absolute path or the exact
vault-relative path exposed by Obsidian. The architecture permits only the
public, portable host representation and must not introduce external
filesystem access to satisfy the wording.

## Failure and compatibility behaviour

- A missing, renamed, duplicated-by-name, or otherwise inaccessible target is
  represented by the red warning icon and warning glyph.
- The plugin does not guess among duplicate names and does not create a file
  when the target is unavailable.
- Obsidian's lifecycle facilities must make enable, disable, reload, and
  repeated initialization safe without duplicate commands, icons, handlers, or
  timers.
- Unsupported optional host capabilities must be detected and reported through
  the owning Obsidian interface rather than failing through desktop-only APIs.

The exact command feedback for an unavailable target remains a feature-level
decision. It must be defined before implementation if the command is expected
to communicate more than the icon state.

## Deployment and ownership

The project owner manually builds and deploys the plugin. Obsidian is the host
and owns installation, vault storage, backup, synchronization, and rollback.
Community-plugin publication is outside the current deployment boundary and
requires a later product and governance decision.

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

## Foundation status

The foundation review is recorded in
[`docs/foundation-review.org`](foundation-review.org). Feature-level behaviour,
acceptance criteria, and implementation tasks belong in a separately approved
change specification.
