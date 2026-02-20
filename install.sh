#!/usr/bin/env bash
set -euo pipefail

REPO="cardpointers/cli"
BIN_NAME="cardpointers"

fail() {
  echo "Error: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

need_cmd curl
need_cmd jq

OS="$(uname -s)"
case "$OS" in
  Darwin|Linux) ;;
  *) fail "Unsupported OS: $OS (macOS and Linux only)" ;;
esac

LATEST_TAG="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | jq -r .tag_name)"
[ -n "$LATEST_TAG" ] && [ "$LATEST_TAG" != "null" ] || fail "Unable to determine latest release tag"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

ASSET_URL="https://github.com/${REPO}/releases/download/${LATEST_TAG}/${BIN_NAME}"

curl -fsSL "$ASSET_URL" -o "$TMP_DIR/$BIN_NAME" || fail "Failed to download ${ASSET_URL}"
chmod +x "$TMP_DIR/$BIN_NAME"

INSTALL_DIR="/usr/local/bin"
if [ -w "$INSTALL_DIR" ]; then
  install -m 0755 "$TMP_DIR/$BIN_NAME" "$INSTALL_DIR/$BIN_NAME"
elif command -v sudo >/dev/null 2>&1; then
  if sudo -n true >/dev/null 2>&1; then
    sudo install -m 0755 "$TMP_DIR/$BIN_NAME" "$INSTALL_DIR/$BIN_NAME"
  else
    echo "sudo password required to install to $INSTALL_DIR" >&2
    sudo install -m 0755 "$TMP_DIR/$BIN_NAME" "$INSTALL_DIR/$BIN_NAME" || true
  fi
fi

if ! command -v "$BIN_NAME" >/dev/null 2>&1; then
  INSTALL_DIR="$HOME/.local/bin"
  mkdir -p "$INSTALL_DIR"
  install -m 0755 "$TMP_DIR/$BIN_NAME" "$INSTALL_DIR/$BIN_NAME"
  echo "Installed to $INSTALL_DIR/$BIN_NAME"
  echo "Ensure $INSTALL_DIR is in your PATH."
else
  echo "Installed to $(command -v "$BIN_NAME")"
fi
