#!/bin/bash
# Copies the client's .tre files into the shared-tre Docker volume, which the server mounts
# read-only at /tre. Run it again after the SWGEmu launcher updates the client.
#
#   ./load-tre.sh "/mnt/c/Program Files (x86)/SWGEmu/SWGEmu"
set -euo pipefail

if [ $# -ne 1 ] || [ ! -d "$1" ]; then
    echo "Usage: $0 <folder with your SWGEmu client's .tre files>" >&2
    exit 2
fi

cd "$1"
shopt -s nullglob
tres=(*.tre)
if [ ${#tres[@]} -eq 0 ]; then
    echo "No .tre files in $1" >&2
    exit 1
fi

echo ">> Copying ${#tres[@]} .tre files into the shared-tre volume"
tar cf - "${tres[@]}" | docker run -i --rm -v shared-tre:/tre debian:bookworm bash -c 'tar xf - -C /tre && ls /tre | wc -l'
