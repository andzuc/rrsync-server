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
FROM alpine:latest

# Install required runtime dependencies, including gpg for dynamic key retrieval
RUN apk add --no-cache rsync openssh tar zstd gnupg

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "AcceptEnv ARCHIVE_NAME" >> /etc/ssh/sshd_config && \
    # Create directories
    mkdir -p /archives /root/.ssh /var/run/sshd

# Copy rrsync from builder stage (downloaded with Debian's curl)
COPY --from=rrsync-downloader /rrsync /usr/local/bin/rrsync
RUN chmod +x /usr/local/bin/rrsync

COPY rrsync-wrapper /usr/local/bin/rrsync-wrapper
COPY ssh-init /usr/local/bin/ssh-init

# Create placeholder authorized_keys (will be replaced at runtime)
RUN echo '# Placeholder - will be replaced by ssh-init' > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/ssh-init"]
