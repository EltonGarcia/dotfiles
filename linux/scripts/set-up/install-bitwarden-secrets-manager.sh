#!/usr/bin/env bash
set -euo pipefail

REPO="bitwarden/sdk-sm"
BIN_NAME="bws"
INSTALL_DIR="/usr/local/bin"

err() { echo "❌ $*" >&2; exit 1; }
info() { echo "ℹ️  $*"; }

command -v curl >/dev/null || err "curl is required"
command -v jq >/dev/null || err "jq is required"
command -v unzip >/dev/null || err "unzip is required"
command -v uname >/dev/null || err "uname is required"

# ---------- OS / ARCH ----------
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  linux)
    case "$ARCH" in
      x86_64|amd64) TARGET="x86_64-unknown-linux-gnu" ;;
      aarch64|arm64) TARGET="aarch64-unknown-linux-gnu" ;;
      *) err "Unsupported Linux architecture: $ARCH" ;;
    esac
    ;;
  darwin)
    case "$ARCH" in
      arm64) TARGET="aarch64-apple-darwin" ;;
      x86_64) TARGET="x86_64-apple-darwin" ;;
      *) err "Unsupported macOS architecture: $ARCH" ;;
    esac
    ;;
  *)
    err "Unsupported OS: $OS"
    ;;
esac

info "Detected target: $TARGET"

# ---------- fetch releases ----------
info "Fetching releases list..."
RELEASES_JSON="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases?per_page=50")"

# ---------- select latest CLI version ----------
VERSION="$(
  jq -r '
    .[]
    | select(.tag_name | test("^bws-v[0-9]+\\.[0-9]+\\.[0-9]+$"))
    | .tag_name
  ' <<<"$RELEASES_JSON" \
  | sort -V \
  | tail -n1 \
  | sed 's/^bws-v//'
)"

[[ -z "$VERSION" ]] && err "Could not detect latest bws CLI version"

info "Latest bws version: $VERSION"

# ---------- find correct asset ----------
# bws-x86_64-unknown-linux-gnu-1.0.0.zip
ASSET_URL="$(
  jq -r --arg TARGET "$TARGET" --arg VERSION "$VERSION" '
    .[]
    | select(.tag_name == ("bws-v" + $VERSION))
    | .assets[]
    | select(.name == ("bws-" + $TARGET + "-" + $VERSION + ".zip"))
    | .browser_download_url
  ' <<<"$RELEASES_JSON"
)"

[[ -z "$ASSET_URL" ]] && err "Asset not found for target $TARGET"

ASSET_NAME="$(basename "$ASSET_URL")"
info "Selected asset: $ASSET_NAME"

# ---------- download & extract ----------
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

info "Downloading..."
curl -fL "$ASSET_URL" -o "$TMP_DIR/$ASSET_NAME"

info "Extracting..."
unzip -q "$TMP_DIR/$ASSET_NAME" -d "$TMP_DIR"

[[ ! -f "$TMP_DIR/$BIN_NAME" ]] && err "bws binary not found in archive"

# ---------- install ----------
info "Installing to $INSTALL_DIR (sudo may be required)"
sudo install -m 0755 "$TMP_DIR/$BIN_NAME" "$INSTALL_DIR/$BIN_NAME"

# ---------- verify ----------
info "Verifying installation..."
"$INSTALL_DIR/$BIN_NAME" --version

echo "✅ Bitwarden Secrets Manager CLI (bws) installed successfully"
