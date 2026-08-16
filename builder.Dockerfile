# CI builder image for Phaser projects: Node (syntax check) + packaging
# tools, so the pipeline's build step does not run apk on every run.
#
# Build & push (the CI runner is linux/amd64):
#   docker build --platform linux/amd64 -f builder.Dockerfile \
#     -t git.teletypegames.org/build/phaser-builder:latest .
#   docker push git.teletypegames.org/build/phaser-builder:latest

FROM node:22-alpine

RUN apk add --no-cache make zip curl git

WORKDIR /workspace

CMD ["/bin/sh"]
