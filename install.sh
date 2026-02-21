#!/usr/bin/env bash
set -euo pipefail

REPO="cardpointers/cli"
BIN_NAME="cardpointers"

usage() {
  cat <<'EOF'
CardPointers CLI installer

Usage:
  install.sh [options]

Options:
  -b, --bin-dir <dir>   Install to a specific directory
  --system              Install to /usr/local/bin (may require sudo)
  -h, --help             Show this help

Environment variables:
  CARDPOINTERS_INSTALL_DIR  Install to a specific directory
  CARDPOINTERS_BIN_DIR      Same as above
  BIN_DIR                   Same as above
  XDG_BIN_HOME              Preferred default if set
EOF
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

need_cmd curl
need_cmd jq

expand_path() {
  case "$1" in
    "~"|"~/"*) echo "${HOME}${1#\~}" ;;
    *) echo "$1" ;;
  esac
}

path_contains_dir() {
  case ":$PATH:" in
    *":$1:"*) return 0 ;;
    *) return 1 ;;
  esac
}

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

BIN_DIR_OVERRIDE=""
EXPLICIT_SYSTEM=0
while [ $# -gt 0 ]; do
  case "$1" in
    -b|--bin-dir)
      [ $# -ge 2 ] || fail "Missing value for $1"
      BIN_DIR_OVERRIDE="$2"
      shift 2
      ;;
    --system)
      EXPLICIT_SYSTEM=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown option: $1"
      ;;
  esac
done

if [ -n "$BIN_DIR_OVERRIDE" ] && [ "$EXPLICIT_SYSTEM" -eq 1 ]; then
  fail "Use either --system or --bin-dir, not both"
fi

if [ "$EXPLICIT_SYSTEM" -eq 1 ]; then
  INSTALL_DIR="/usr/local/bin"
else
  INSTALL_DIR="${BIN_DIR_OVERRIDE:-${CARDPOINTERS_INSTALL_DIR:-${CARDPOINTERS_BIN_DIR:-${BIN_DIR:-${XDG_BIN_HOME:-}}}}}"
fi

if [ -z "$INSTALL_DIR" ]; then
  if path_contains_dir "$HOME/.local/bin"; then
    INSTALL_DIR="$HOME/.local/bin"
  elif path_contains_dir "$HOME/bin"; then
    INSTALL_DIR="$HOME/bin"
  elif path_contains_dir "$HOME/.cardpointers/bin"; then
    INSTALL_DIR="$HOME/.cardpointers/bin"
  elif [ -d "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
  elif [ -d "$HOME/bin" ]; then
    INSTALL_DIR="$HOME/bin"
  elif [ -d "$HOME/.cardpointers/bin" ]; then
    INSTALL_DIR="$HOME/.cardpointers/bin"
  else
    INSTALL_DIR="$HOME/.local/bin"
  fi
fi

INSTALL_DIR="$(expand_path "$INSTALL_DIR")"
INSTALL_PATH="$INSTALL_DIR/$BIN_NAME"

mkdir -p "$INSTALL_DIR"

if [ -w "$INSTALL_DIR" ]; then
  install -m 0755 "$TMP_DIR/$BIN_NAME" "$INSTALL_PATH"
elif [ "$EXPLICIT_SYSTEM" -eq 1 ] || [ "$INSTALL_DIR" = "/usr/local/bin" ]; then
  command -v sudo >/dev/null 2>&1 || fail "No write access to $INSTALL_DIR and sudo is not available"
  if sudo -n true >/dev/null 2>&1; then
    sudo install -m 0755 "$TMP_DIR/$BIN_NAME" "$INSTALL_PATH"
  else
    echo "sudo password required to install to $INSTALL_DIR" >&2
    sudo install -m 0755 "$TMP_DIR/$BIN_NAME" "$INSTALL_PATH"
  fi
else
  fail "No write access to $INSTALL_DIR. Choose a writable directory with --bin-dir."
fi

VERSION="$("$INSTALL_PATH" --version 2>/dev/null || true)"
if [ -z "$VERSION" ]; then
  VERSION="$LATEST_TAG"
fi

echo "CardPointers CLI installed."
echo "Path: $INSTALL_PATH"
echo "Version: $VERSION"

if ! path_contains_dir "$INSTALL_DIR"; then
  echo ""
  echo "Add it to your PATH (choose one):"
  echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
  echo "Then restart your shell."
fi
