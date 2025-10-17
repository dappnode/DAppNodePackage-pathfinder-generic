# syntax=docker/dockerfile:1
ARG UPSTREAM_VERSION
FROM eqlabs/pathfinder:${UPSTREAM_VERSION}

# Stay as root for everything
USER root

# Install rclone and zstd
RUN apt-get update && apt-get install -y curl zstd unzip && \
    curl https://rclone.org/install.sh | bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
