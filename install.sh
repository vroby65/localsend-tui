#!/usr/bin/env bash
set -euo pipefail

case "$(uname -m)" in
    x86_64)
        arch=x86_64
        ;;
    aarch64|arm64)
        arch=aarch64
        ;;
    *)
        printf 'Unsupported Linux architecture: %s\n' "$(uname -m)" >&2
        exit 1
        ;;
esac

install_dir="$HOME/.local/opt/localsend-tui"
archive=$(mktemp)
trap 'rm -f "$archive"' EXIT

mkdir -p "$install_dir"
curl -fL --retry 3 \
    "https://github.com/vroby65/localsend-tui/releases/latest/download/localsend-tui-linux-${arch}.tar.gz" \
    -o "$archive"
tar -xzf "$archive" -C "$install_dir"
chmod 0755 "$install_dir/localsend-tui"

exec "$install_dir/localsend-tui" "$@"
