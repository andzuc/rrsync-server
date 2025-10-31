# rrsync-server

Restricted rsync server with archive compression (zstd) and GPG key authentication.

## Features

- **Secure rsync over SSH** with `rrsync` restrictions
- **Automatic archive creation** (.tar.zst) after transfers
- **Resume support** with `--partial --append`
- **GPG key authentication** (runtime configuration)
- **Volume-based persistence** for archives

## Quick Start

### 1. Build the image
```bash
./bin/build
