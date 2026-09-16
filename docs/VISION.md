# Vision

<!-- Version: 0.1.0 | Last updated: 2026-09-08 -->

## Purpose

`today-note-custom-hotkey` provides a dependable shortcut to one user-selected
note in an Obsidian vault. The note is a single fixed file chosen by the user;
it is not an Obsidian Daily Note, is not dated, and does not change name.

## Intended users and context

The plugin is for Obsidian users who repeatedly return to one note and want a
short keyboard route on macOS and a clearly identifiable in-app route on iOS.
The user continues to view and edit the note through Obsidian's standard
interface.

## First usable outcome

The first release provides:

- one configuration entry for the selected vault note;
- one user-configurable keyboard shortcut invoking the open-note command; and
- one small Obsidian in-app icon on macOS and iOS that invokes the same action.

If the selected note cannot be resolved, the icon visibly changes to a red
warning state with a warning glyph so that the problem is apparent without
opening or modifying a note.

The first release stores the selected note path and preferred keyboard shortcut
in the plugin's standard Obsidian configuration. It never writes note content.

## Scope boundaries

The plugin opens the configured note for viewing or editing in Obsidian. It
does not create, rename, date, search for, or modify notes.

The following are explicit non-goals for the first release and foreseeable
releases:

- integration with Obsidian Daily Notes;
- date rollover or date-based lookup;
- multiple configured notes;
- note creation or templates;
- widgets or operating-system shortcuts outside Obsidian;
- URL-scheme integration;
- synchronization integrations;
- network access, telemetry, or external services; and
- community-plugin publication at this stage.

## Roadmap

No product roadmap beyond this deliberately small feature is currently
authorized. Community-plugin publication may be considered later as a separate
decision and change.

## Product constraints

- Supported platforms are macOS and iOS using the latest stable Obsidian
  versions at release time.
- Release and deployment decisions remain with the project owner and are
  performed manually.
- Vault backup and plugin rollback remain the user's responsibility through
  Obsidian's normal vault and plugin mechanisms.
- The plugin has no service availability or telemetry obligation.

## Unresolved product decisions

- The configuration wording and storage representation for an "absolute path"
  must be reconciled with the path representation exposed by Obsidian's public
  vault APIs. The product intent is the exact file selected from the vault; the
  feature specification must confirm the portable representation.
- The keyboard command's user-visible behaviour when the configured file is
  unavailable is not yet defined. The red warning icon is defined for the icon
  state; command feedback needs a separate feature-level decision.
- The minimum exact Obsidian version is deferred to release planning; latest
  stable macOS and iOS Obsidian versions remain the current support intent.
- Community-plugin publication, including its review and release obligations,
  is deferred.

## Foundation status

The foundation review is recorded in
[`docs/foundation-review.org`](foundation-review.org). The review is a
self-review of the foundation documents, not an independent audit. Foundation
approval is recorded separately in that document.
