ARG ALPINE_VERSION=3.20
FROM alpine:${ALPINE_VERSION}

# Install required runtime dependencies, including gpg for dynamic key retrieval
RUN apk add --no-cache \
    rsync \
    rrsync \
    findutils \
    openssh \
    tar \
    zstd \
    gnupg \
    python3

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo "AcceptEnv ARCHIVE_NAME" >> /etc/ssh/sshd_config && \
    # Generate SSH host keys
    ssh-keygen -A && \
    ls -l /etc/ssh/ssh_host_*_key

# Create directories
RUN mkdir -p /archives

# Copy scripts to Alpine image
COPY bin /usr/local/bin/

EXPOSE 22
ENV RRSYNC_UID=1000
ENV RRSYNC_GID=1000
ENTRYPOINT ["/usr/local/bin/ssh-init"]
