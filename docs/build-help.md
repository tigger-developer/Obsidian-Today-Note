# Build help

`make build` runs `./scripts/build.sh`, which validates the three maintained
plugin artefacts that make up a release:

- `main.js`
- `manifest.json`
- `styles.css`

The plugin has no compilation, bundling, or package-manager step, so the
maintained source files are the released files and validation is the whole
build. The check fails when an artefact is missing or empty, or when
`manifest.json` lacks an `id`, a `name`, or an `x.y.z` version.

Options:

- `--help`, `-h`: display this help.
- `--version`: display the build script version.

Requires `jq`.
