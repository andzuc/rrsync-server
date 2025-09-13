ARG PYTHON_VERSION=3.10-slim
FROM python:$PYTHON_VERSION

# Installa dipendenze necessarie
RUN apt-get update && apt-get install -y \
    libfuse-dev \
    fuse \
    rsync \
    openssh-server \
    libarchive-dev \
    && rm -rf /var/lib/apt/lists/*

# Instal ratarmount
RUN pip install ratarmount

# Instal rrsync
RUN wget -O /usr/local/bin/rrsync https://download.samba.org/pub/rsync/src/rrsync && \
    chmod +x /usr/local/bin/rrsync

# wrapper: gestore montaggio dinamico
COPY rrsync-wrapper /usr/local/bin/

# Setup SSH to accept variable ARCHIVE_NAME
RUN echo "AcceptEnv ARCHIVE_NAME" >> /etc/ssh/sshd_config && \
    mkdir /var/run/sshd && \
    mkdir -p /root/.ssh && \
    echo 'command="/usr/local/bin/rrsync-wrapper",no-agent-forwarding,no-port-forwarding,no-pty ${SSH_PUBLIC_KEY}' >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# Setup directory for archve and mount point
RUN mkdir /archive /mnt

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
