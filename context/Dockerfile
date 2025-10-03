# Stage 1: Builder - download rrsync using Debian's full curl+OpenSSL
FROM debian:bookworm-slim AS rrsync-downloader

# Install curl with full OpenSSL support
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Download rrsync with robust curl
RUN curl -L --retry 3 --retry-delay 5 --fail \
    -o /rrsync \
    https://rsync.samba.org/ftp/unpacked/rsync/support/rrsync

# Stage 2: Runtime - minimal Alpine image
FROM alpine:3.20

# Install required runtime dependencies, including gpg for dynamic key retrieval
RUN apk add --no-cache rsync openssh tar zstd gnupg python3

ARG RRSYNC_UID=1000
ARG RRSYNC_GID=1000
RUN addgroup -g ${RRSYNC_GID} rrsync && \
    adduser -u ${RRSYNC_UID} -G rrsync -D rrsync && \
    passwd -u rrsync

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo "AcceptEnv ARCHIVE_NAME" >> /etc/ssh/sshd_config && \
    # Create directories
    mkdir -p /archives /var/run/sshd && \
    # Generate SSH host keys
    ssh-keygen -A && \
    ls -l /etc/ssh/ssh_host_*_key

# Copy scripts to Alpine image
COPY --from=rrsync-downloader --chmod=755 /rrsync /usr/local/bin/rrsync
COPY rrsync-wrapper /usr/local/bin/rrsync-wrapper
COPY rrsync-wrapper-init /usr/local/bin/rrsync-wrapper-init
COPY ssh-init /usr/local/bin/ssh-init

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/ssh-init"]
