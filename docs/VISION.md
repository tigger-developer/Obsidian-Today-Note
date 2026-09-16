# Vision

<!-- Version: 0.2.2 | Last updated: 2026-09-16 -->

## Purpose

`today-note-custom-hotkey` provides a dependable shortcut to one user-selected
note in an Obsidian vault. The note is a single fixed file chosen by the user;
it is not an Obsidian Daily Note, is not dated, and does not change name.

## Intended users and context

The plugin is for Obsidian users who repeatedly return to one note and want a
short keyboard route on macOS and a clearly identifiable in-app route on iOS.
The user continues to view and edit the note through Obsidian's standard
interface.

## Delivered outcome

The released plugin provides:

- one configuration entry for the selected vault note;
- one Obsidian command, `Open today note`, to which the user assigns a keyboard
  shortcut through Obsidian's own Hotkeys settings; and
- one small Obsidian ribbon icon on macOS and iOS that invokes the same action.

If the selected note cannot be resolved, the ribbon icon changes to a red
warning state with a warning glyph, and invoking the command or icon displays a
notice, so that the problem is apparent without opening or modifying a note.

The plugin stores only the selected note's vault-relative path in its standard
Obsidian plugin configuration. Obsidian owns the hotkey assignment. The plugin
never writes note content.

## Scope boundaries

The plugin opens the configured note for viewing or editing in Obsidian. It
does not create, rename, date, search for, or modify notes.

The following are explicit non-goals for the foreseeable releases:

- integration with Obsidian Daily Notes;
- date rollover or date-based lookup;
- multiple configured notes;
- note creation or templates;
- widgets or operating-system shortcuts outside Obsidian;
- URL-scheme integration;
- synchronization integrations; and
- network access, telemetry, or external services.

## Distribution and roadmap

No product roadmap beyond this deliberately small feature is authorized.

Preparation for the Obsidian community directory is authorized and tracked in
[W002 - marketplace prep](../specs/002-marketplace-prep/spec.org). That work
covers package identity, licensing, public documentation, and version-matched
GitHub releases. Submitting the plugin to the community directory, and the
review and maintenance obligations that follow, remains a separate decision
that has not been taken. Until it is, manual installation from a GitHub release
is the only distribution route.

## Product constraints

- Supported platforms are macOS and iOS using the latest stable Obsidian
  versions at release time.
- Submission and public-listing decisions remain with the project owner.
- Releases are published deliberately with `make release`, which carries
  `main.js`, `manifest.json`, and `styles.css`; GitHub then attests those files.
  Release mechanics are described in the README.
- Vault backup and plugin rollback remain the user's responsibility through
  Obsidian's normal vault and plugin mechanisms.
- The plugin has no service availability or telemetry obligation.

## Resolved product decisions

- **Stored path representation:** the plugin stores the vault-relative path
  reported by Obsidian's public vault APIs, not a filesystem absolute path.
  Settled in [W001 - fixed-note access](../specs/001-today-note-access/spec.org)
  and reflected in the delivered settings view.
- **Unavailable-target feedback:** the command and the ribbon icon both display
  an Obsidian notice when no note is configured or the configured path does not
  resolve, alongside the red warning icon state. Settled in W001.

## Unresolved product decisions

- The manifest declares `minAppVersion` `1.13.0` as the support baseline. That
  value is a project-owner decision; version-specific compatibility testing on
  macOS and iOS has not been recorded against it. Latest stable Obsidian
  versions remain the support intent.
- Community-directory submission, including its review and ongoing maintenance
  obligations, is still deferred.

## Foundation status

The foundation review is recorded in
[`docs/foundation-review.org`](foundation-review.org). The review is a
self-review of the foundation documents, not an independent audit. Foundation
approval is recorded separately in that document.

## Document changelog

- **0.2.2, 2026-09-16:** releases are published by `make release` rather than by
  every push to `master`.
- **0.2.1, 2026-09-16:** recorded the `minAppVersion` `1.13.0` support baseline
  and that compatibility testing against it is outstanding.
- **0.2.0, 2026-09-16:** recorded the delivered behaviour, corrected the
  settings-storage description to the vault-relative path only, moved the
  settled path-representation and unavailable-target decisions to resolved,
  and replaced the publication non-goal with the authorized marketplace
  preparation and the outstanding submission decision.
- **0.1.0, 2026-09-08:** initial foundation Vision.
