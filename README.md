# phaser-tools

CI/CD templates for [Phaser](https://phaser.io) (JavaScript) game
projects, in the same spirit as
[ebitengine-tools](../ebitengine-tools) and
[love-tools](../love-tools).

- `example-makefile.make` — project Makefile: local dev targets
  (`build`, `web`, `serve`, `export`, `watch`, `clean`).
- `example-woodpecker.yaml` — a one-line marker (`platform: phaser`): the
  full pipeline (version → build → upload → publish) is served by the update server's Woodpecker
  configuration extension — preview it with
  `curl "https://teletypegames.org/build/config?platform=phaser"`.
- `builder.Dockerfile` — the CI builder image: `node:22-alpine` with
  make/zip/curl baked in.
- `example-tasks.json` — VS Code `.vscode/tasks.json`: `build` (the default
  build task, a syntax check) and `web` as `warpengine` tasks of the WarpEngine
  Toolbox.
- `web/index.html` — the HTML shell downloaded by `make web` and
  packaged next to `phaser.min.js` and the bundled `game.js`.
- `hello/src/main.js` — a minimal Hello World game (copied as
  `src/main.js`).
- `warp-template.json` — what the WarpEngine Toolbox's *New Game*
  copies from this repo ("Start from the template only"): the
  Makefile, the VS Code tasks and the Hello World. The toolbox writes
  `.woodpecker.yaml`, `metadata.json`, `README.md` and `.gitignore`
  itself, so the new project builds and shows "Hello World" as is.

There is no bundler and no `node_modules`: the pinned
`phaser.min.js` build is downloaded from the jsDelivr CDN at export
time (the same way love-tools downloads love.js), and the game
sources in `src/*.js` are concatenated in filename order into a
single `game.js`. Node is only used for a `node --check` syntax pass.

## Dev container

`warp-template.json` has a `devcontainer` key that the WarpEngine Toolbox reads
(an older toolbox ignores it): a new project gets `.devcontainer/` from
`example-devcontainer.json` and `example-devcontainer.Dockerfile` — the CI
builder image the host names (`{builderImage}`) plus git and a `dev` user —
so a computer with only Docker builds with the same toolchain as the pipeline.
The tasks of `example-devcontainer-tasks.json` are merged into
`.vscode/tasks.json`: `dev image` builds the container image, `play` builds the
game and plays it in the host's web runtime. The `play` task builds `make web` in the container and plays `dist/web` in the Play panel. `make serve` still works on a computer with Python; in the container its port is not published, so Play is the way to try the game there.
The container editor gets its extensions from `example-devcontainer.json`: the WarpEngine Toolbox, Makefile Tools (its configure prompts off; the Toolbox tasks build) and ESLint and Prettier. It also mounts the computer's Docker socket, with the Docker CLI in the image and `dev` in the socket's group, so the Toolbox lists, starts and restarts the local engine's containers from inside the container.
For an existing game repo, *WarpEngine: Add Dev Container* adds it and merges
the tasks, keeping yours.

## Usage in a game repo

1. Copy `example-makefile.make` to `Makefile`, set `PROJECT` and
   `PHASER_VERSION`, and put the game sources into `src/` (they are
   concatenated in filename order — prefix with numbers if load order
   matters).
2. Copy `example-woodpecker.yaml` to `.woodpecker.yaml` (a one-line marker — the
   pipeline itself is served by the update server; add `name:` when the
   software name differs from the repo name) and add the
   `application_token` secret in Woodpecker (an ApplicationToken with
   the `update` + `upload` scopes, created in the admin).
3. Copy `example-tasks.json` to `.vscode/tasks.json`.

`make serve` builds the web bundle and serves it on
`http://localhost:8000` (Python 3's built-in HTTP server).

The served pipeline uploads `$(PROJECT)-$(VERSION).html.zip` via `/build/upload`,
then triggers
`/build/publish?platform=phaser&name=$(PROJECT)&version=$(VERSION)`.

## Builder image

It is the base of the dev container too, so it is built for amd64 (the CI
runner) and arm64 (Apple Silicon); both get the same packages:

```sh
docker buildx build --platform linux/amd64,linux/arm64 -f builder.Dockerfile \
  -t git.teletypegames.org/build/phaser-builder:latest --push .
```

Detailed documentation lives on the wiki: `/development/phaser`.
