# Local-play overlay on SWGEmu Core3's own build image.
#
# The base is the image Core3's docker/Dockerfile builds (tagged swgemu/core3-dev by Core3's
# build.sh, and by ./build.sh here). Core3 itself is not changed: everything local-play-specific
# lives in this layer.
ARG BASE_IMAGE=swgemu/core3-dev:latest
FROM ${BASE_IMAGE}

# Core3's CMake requires Java for the IDL compiler (idlc.jar), and the base image ships none.
RUN set -xe; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y default-jdk-headless; \
    rm -rf /var/lib/apt/lists/*; \
    java -version

# Starts MariaDB on every boot after the first, then hands over to Core3's /run.sh.
COPY entrypoint.sh /usr/local/bin/core3-docker-entrypoint
RUN chmod 755 /usr/local/bin/core3-docker-entrypoint

ENTRYPOINT ["/usr/local/bin/core3-docker-entrypoint"]
