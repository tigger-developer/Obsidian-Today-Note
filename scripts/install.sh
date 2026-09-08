#!/usr/bin/env bash
set -eo pipefail

installer_version="0.1.0"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
project_root="$(cd "$script_dir/.." && pwd -P)"
help_file="$project_root/docs/install-help.md"
dry_run=0

case "${1:-}" in
    "" ) ;;
    -h|--help)
        cat "$help_file"
        exit 0
        ;;
    --version)
        printf '%s\n' "$installer_version"
        exit 0
        ;;
    --dry-run)
        dry_run=1
        ;;
    *)
        printf 'Unknown option: %s\n' "$1" >&2
        printf 'Use --help for usage.\n' >&2
        exit 2
        ;;
esac

printf 'Obsidian vault root: '
IFS= read -r vault_root
case "$vault_root" in
    "~") vault_root="$HOME" ;;
esac
if [[ "${vault_root:0:1}" == "~" && "${vault_root:1:1}" == "/" ]]; then
    vault_root="$HOME/${vault_root:2}"
fi
printf '\n'

if [[ ! -d "$vault_root" ]]; then
    printf 'Vault root does not exist or is not a directory: %s\n' "$vault_root" >&2
    exit 1
fi

if [[ ! -d "$vault_root/.obsidian" ]]; then
    printf 'Not an Obsidian vault root: %s\n' "$vault_root" >&2
    printf 'The directory must contain .obsidian.\n' >&2
    exit 1
fi

vault_root="$(cd "$vault_root" && pwd -P)"
plugin_dir="$vault_root/.obsidian/plugins/daily-note-key-plugin"

if (( dry_run )); then
    printf 'Dry run: would copy manifest.json and main.js to %s\n' "$plugin_dir"
    exit 0
fi

for artifact in manifest.json main.js; do
    artifact_path="$project_root/$artifact"
    if [[ ! -s "$artifact_path" ]]; then
        printf 'Required plugin file is missing or empty: %s\n' "$artifact_path" >&2
        printf 'Build the plugin first with: make build\n' >&2
        exit 1
    fi
done

mkdir -p "$plugin_dir"
cp -f "$project_root/manifest.json" "$project_root/main.js" "$plugin_dir/"
printf 'Installed daily-note-key-plugin in %s\n' "$plugin_dir"
