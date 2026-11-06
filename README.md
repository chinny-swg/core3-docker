# core3-docker

Run a [Core3](https://github.com/chinny-swg/Core3) server in Docker on your own PC and play on it
with the SWGEmu client. The full Windows walkthrough (WSL 2, Docker Desktop, client setup) is
**[Local Server on Windows (WSL + Docker)](https://chinny-swg.github.io/guides/windows-local-server/)**.

Core3 itself is not changed. This repo adds a thin layer on top of the image built from Core3's
own [`docker/`](https://github.com/chinny-swg/Core3/tree/unstable/docker) folder, and everything
specific to playing locally lives here.

## What it adds

| File | Does |
|------|------|
| `Dockerfile` | `core3-local`: Core3's `swgemu/core3-dev` image plus a JDK (Core3's CMake needs Java and the base image has none) and the entrypoint below |
| `entrypoint.sh` | Starts MariaDB on every boot after the first (Core3's `/run.sh` only starts it on first boot), then runs Core3's `/run.sh` unchanged |
| `compose.yaml` | The `swgemu-core3` container: ports, volumes, galaxy address `127.0.0.1`, first boot cloning from `chinny-swg` |
| `build.sh` | Builds `swgemu/core3-dev` from Core3's `docker/` folder on GitHub, then `core3-local` on top |
| `load-tre.sh` | Copies your client's `.tre` files into the `shared-tre` volume |
| `shell.sh` | Opens a shell as `swgemu` in the running container |

## Quick start

From a Linux shell (on Windows, Ubuntu on WSL 2 with Docker Desktop's WSL integration):

```sh
git clone https://github.com/chinny-swg/core3-docker.git
cd core3-docker
./load-tre.sh "/mnt/c/Program Files (x86)/SWGEmu/SWGEmu"   # your SWGEmu client folder
./build.sh                                                  # both images; takes a while
docker compose up -d
docker compose logs core3                                   # first boot: note the passwords
./shell.sh                                                  # then, inside: build, run
```

Then point the client's `swgemu_login.cfg` at `127.0.0.1`, port `44453`. See the guide for
details and troubleshooting.

`build.sh` reads `CORE3_REPO` and `CORE3_REF` to build the base from another Core3 fork or
branch. The container clones its source on first boot from `REPO_PUBLIC_URL` in `compose.yaml`.

## Volumes

- **`shared-tre`**: your `.tre` files, read-only in the container at `/tre`.
- **`swgemu-core3`**: `/home/swgemu`, which holds the source, the compiled server, MariaDB data
  and config. That's your galaxy, so don't delete it.

Both use the same names as Core3's own `docker/run.sh`, so either can use them.

## Legal

Use your own copy of the game, and never share the `.tre` files. Core3 is AGPL-3.0.
