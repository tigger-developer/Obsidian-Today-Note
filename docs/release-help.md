# Release help

`make release` runs `make lint`, then `./scripts/release.sh`, which publishes
one GitHub release of the three plugin files from the `master` branch:

1. Validate the artefacts through `./scripts/build.sh`.
2. Increment the manifest's patch version, or use `VERSION` when supplied.
3. Commit the manifest as `chore: release <version>`.
4. Create an annotated tag and push the commit and tag atomically.
5. Create the GitHub release with `main.js`, `manifest.json`, and `styles.css`
   attached.

Signing is not performed here. The **Release and attest** GitHub Actions
workflow runs when the release is published and attests the three attached
files.

The release refuses to run when a required tool is missing, the current branch
is not `master`, the working tree has uncommitted changes, the local branch
differs from `origin/master`, or the computed tag already exists locally or on
the remote.

Options:

- `--help`, `-h`: display this help.
- `--version`: display the release script version.
- `--dry-run`: report the version that would be released and the files that
  would be attached, without changing the repository or the remote.

Variables:

- `VERSION=x.y.z`: release that exact version instead of the next patch.

Requires `git`, `jq`, and an authenticated `gh`.

If the push succeeds but release creation fails, the commit and tag are already
published. Re-run the release creation for the existing tag rather than
re-tagging:

```bash
gh release create <version> main.js manifest.json styles.css --verify-tag
```
