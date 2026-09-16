#!/usr/bin/env bash
# ABOUTME: Validates the three maintained Obsidian plugin artefacts.
# ABOUTME: The plugin has no compilation step, so validation is the build.
set -eo pipefail

build_version="0.1.0"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
project_root="$(cd "$script_dir/.." && pwd -P)"
help_file="$project_root/docs/build-help.md"

case "${1:-}" in
    "" ) ;;
    -h|--help)
        cat "$help_file"
        exit 0
        ;;
    --version)
        printf '%s\n' "$build_version"
        exit 0
        ;;
    *)
        printf 'Unknown option: %s\n' "$1" >&2
        printf 'Use --help for usage.\n' >&2
        exit 2
        ;;
esac

if ! command -v jq > /dev/null; then
    printf 'jq is required to validate manifest.json.\n' >&2
    exit 1
fi

for artefact in main.js manifest.json styles.css; do
    if [[ ! -s "$project_root/$artefact" ]]; then
        printf 'Required plugin file is missing or empty: %s\n' "$artefact" >&2
        exit 1
    fi
done

if ! jq -e '.id and .name and
    (.version | test("^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)$"))' \
    "$project_root/manifest.json" > /dev/null; then
    printf 'manifest.json needs an id, a name, and an x.y.z version.\n' >&2
    exit 1
fi

version=$(jq -r '.version' "$project_root/manifest.json")
printf 'Build: main.js, manifest.json, and styles.css are valid at version %s.\n' "$version"
