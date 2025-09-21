# Stage 1: Builder - recupera la SSH public key da GPG
FROM alpine:latest AS builder

# Install gpg e dipendenze per recuperare la key
RUN apk add --no-cache gnupg

# Argomento: GPG_KEYID da passare in build time
ARG GPG_KEYID

# Recupera la key dal keyring o da keyserver
RUN gpg --list-keys "${GPG_KEYID}" >/dev/null 2>&1 \
    || gpg --recv-key "${GPG_KEYID}"

# Estrai la SSH public key (formato authorized_keys)
RUN gpg --export-ssh-key "${GPG_KEYID}" > /tmp/public_key

# Stage 2: Runtime - immagine finale senza gpg
FROM alpine:latest

# Install required runtime dependencies
RUN apk add --no-cache rsync openssh tar zstd && \
    wget https://rsync.samba.org/ftp/unpacked/rsync/support/rrsync -O /usr/local/bin/rrsync && \
    chmod +x /usr/local/bin/rrsync && \
    # Configure SSH
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "AcceptEnv ARCHIVE_NAME" >> /etc/ssh/sshd_config && \
    # Create directories
    mkdir -p /archives /root/.ssh /var/run/sshd

# Copy SSH public key from builder stage
COPY --from=builder /tmp/public_key /root/.ssh/authorized_keys

# Set correct permissions for authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh

# Copy the rrsync-wrapper script (permissions preserved)
COPY rrsync-wrapper /usr/local/bin/rrsync-wrapper

# Configure authorized_keys with rrsync-wrapper as forced command
RUN sed -i "s/^ssh-rsa /command=\"\/usr\/local\/bin\/rrsync-wrapper\",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa /" /root/.ssh/authorized_keys

# Expose SSH port
EXPOSE 22

# Start SSHD
CMD ["/usr/sbin/sshd", "-D"]
