#!/bin/bash
# Builds the two images:
#   1. swgemu/core3-dev  - Core3's own build image, straight from Core3's docker/ folder on GitHub
#   2. core3-local       - this repo's overlay on top of it (Java, MariaDB on every boot)
#
# CORE3_REPO and CORE3_REF pick the Core3 that the base image comes from. The container still
# clones its own Core3 source on first boot (REPO_PUBLIC_URL in compose.yaml).
set -euo pipefail

CORE3_REPO=${CORE3_REPO:-https://github.com/chinny-swg/Core3.git}
CORE3_REF=${CORE3_REF:-unstable}
BASE_IMAGE=${BASE_IMAGE:-swgemu/core3-dev:latest}
IMAGE=${IMAGE:-core3-local:latest}

cd "$(dirname "$0")"

echo ">> Building ${BASE_IMAGE} from ${CORE3_REPO} (${CORE3_REF}), docker/ folder"
docker build -t "${BASE_IMAGE}" "${CORE3_REPO}#${CORE3_REF}:docker"

echo ">> Building ${IMAGE} on top of it"
docker build -t "${IMAGE}" --build-arg "BASE_IMAGE=${BASE_IMAGE}" .

echo ">> Done. Start the server container with: docker compose up -d"
