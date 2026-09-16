#!/usr/bin/env bash
# ABOUTME: Publishes a version-bumped GitHub release of the three plugin files.
# ABOUTME: Attestation and signing stay with the Release and attest workflow.
set -eo pipefail

release_version="0.1.0"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
project_root="$(cd "$script_dir/.." && pwd -P)"
help_file="$project_root/docs/release-help.md"
release_branch="master"
dry_run=0

case "${1:-}" in
    "" ) ;;
    -h|--help)
        cat "$help_file"
        exit 0
        ;;
    --version)
        printf '%s\n' "$release_version"
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

for tool in git jq gh; do
    if ! command -v "$tool" > /dev/null; then
        printf 'Releasing requires %s.\n' "$tool" >&2
        exit 1
    fi
done

cd "$project_root"
"$script_dir/build.sh"

branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" != "$release_branch" ]]; then
    printf 'Releases are published from %s; the current branch is %s.\n' \
        "$release_branch" "$branch" >&2
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    printf 'The working tree has uncommitted changes.\n' >&2
    printf 'Commit or set them aside so the release matches the published files.\n' >&2
    exit 1
fi

git fetch --quiet origin "$release_branch"
if [[ "$(git rev-parse HEAD)" != "$(git rev-parse "origin/$release_branch")" ]]; then
    printf 'Local %s differs from origin/%s.\n' "$release_branch" "$release_branch" >&2
    printf 'Pull or push first so the release tag matches the published branch.\n' >&2
    exit 1
fi

semver='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
if [[ -n "${VERSION:-}" ]]; then
    if [[ ! "$VERSION" =~ $semver ]]; then
        printf 'VERSION must be an x.y.z version, not: %s\n' "$VERSION" >&2
        exit 2
    fi
    version="$VERSION"
else
    version=$(jq -er '.version | split(".") |
        .[2] = ((.[2] | tonumber) + 1 | tostring) | join(".")' manifest.json)
fi

if git rev-parse --verify --quiet "refs/tags/$version" > /dev/null ||
    [[ -n "$(git ls-remote --tags origin "refs/tags/$version")" ]]; then
    printf 'Tag %s already exists; choose another VERSION.\n' "$version" >&2
    exit 1
fi

if (( dry_run )); then
    printf 'Dry run: would release version %s from %s\n' "$version" "$release_branch"
    printf 'Dry run: would attach main.js, manifest.json, and styles.css\n'
    exit 0
fi

# The temporary file stays beside the manifest so the replacement is atomic.
versioned_manifest=$(mktemp "$project_root/.manifest.XXXXXX.json")
cleanup() {
    if [[ -e "$versioned_manifest" ]]; then
        trash -- "$versioned_manifest"
    fi
}
trap cleanup EXIT
jq --arg version "$version" '.version = $version' manifest.json > "$versioned_manifest"
mv "$versioned_manifest" manifest.json

git add manifest.json
git commit -m "chore: release $version"
git tag -a "$version" -m "Daily Note Key $version"
git push --atomic origin "HEAD:refs/heads/$release_branch" "refs/tags/$version"

gh release create "$version" main.js manifest.json styles.css \
    --verify-tag --title "Daily Note Key $version" \
    --notes 'A ribbon button and configurable keyboard shortcut that open one pre-selected note.'

printf 'Released %s. The Attest release workflow signs the attached files.\n' "$version"
