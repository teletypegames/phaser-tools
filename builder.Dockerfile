# CI builder image for Phaser projects: Node (syntax check) + packaging
# tools, so the pipeline's build step does not run apk on every run.
#
# It is also the base of a project's dev container (.devcontainer/Dockerfile),
# so it is built for amd64 (the CI runner) and arm64 (Apple Silicon) alike;
# both carry the same packages.
#
# Build & push (a docker-container buildx builder):
#   docker buildx build --platform linux/amd64,linux/arm64 -f builder.Dockerfile \
#     -t git.teletypegames.org/build/phaser-builder:latest --push .

FROM node:22-alpine

RUN apk add --no-cache make zip curl git

WORKDIR /workspace

CMD ["/bin/sh"]
