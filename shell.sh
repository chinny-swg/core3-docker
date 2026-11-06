#!/bin/bash
# Opens a login shell as the swgemu user in the running server container: `build` compiles,
# `run` starts the server and attaches to its console (detach with Ctrl-A, then D).
set -euo pipefail
cd "$(dirname "$0")"
exec docker compose exec -u swgemu core3 bash -l
