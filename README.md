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
- `example-tasks.json` — VS Code `.vscode/tasks.json` with the common
  dev tasks: **Serve** (`make serve`, default build task,
  `Cmd+Shift+B`), **Build Web** and **Make build**.
- `web/index.html` — the HTML shell downloaded by `make web` and
  packaged next to `phaser.min.js` and the bundled `game.js`.

There is no bundler and no `node_modules`: the pinned
`phaser.min.js` build is downloaded from the jsDelivr CDN at export
time (the same way love-tools downloads love.js), and the game
sources in `src/*.js` are concatenated in filename order into a
single `game.js`. Node is only used for a `node --check` syntax pass.

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

```sh
docker build --platform linux/amd64 -f builder.Dockerfile \
  -t git.teletypegames.org/internal/phaser-builder:latest .
docker push git.teletypegames.org/internal/phaser-builder:latest
```

Detailed documentation lives on the wiki: `/development/phaser`.
