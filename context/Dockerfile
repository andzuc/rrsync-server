FROM alpine:latest

# Install required runtime dependencies, including gpg for dynamic key retrieval
RUN apk add --no-cache rsync openssh tar zstd gnupg && \
    wget https://rsync.samba.org/ftp/unpacked/rsync/support/rrsync -O /usr/local/bin/rrsync && \
    chmod +x /usr/local/bin/rrsync && \
    # Configure SSH
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "AcceptEnv ARCHIVE_NAME" >> /etc/ssh/sshd_config && \
    # Create directories
    mkdir -p /archives /root/.ssh /var/run/sshd

# Copy the rrsync-wrapper script
COPY rrsync-wrapper /usr/local/bin/rrsync-wrapper

# Copy SSH initialization script
COPY ssh-init /usr/local/bin/ssh-init

# Create placeholder authorized_keys (will be replaced at runtime)
RUN echo '# Placeholder - will be replaced by ssh-init' > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh

# Expose SSH port
EXPOSE 22

# Use init script as entrypoint
ENTRYPOINT ["/usr/local/bin/ssh-init"]
