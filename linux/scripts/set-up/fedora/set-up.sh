#!/usr/bin/env bash

# Exits immediately if any command returns non-zero status
set -e

WRKSPC_DIR="$HOME/workspace"
LINUX_DOTFILES_DIR="$WRKSPC_DIR/dotfiles/linux/dotfiles"
PKGS_FILE="dnf-packages.txt"
COPRS_FILE="corps.txt"

clone_dotfiles(){
  mkdir "$WRKSPC_DIR"
  cd "$WRKSPC_DIR"
  git clone git@github.com:EltonGarcia/dotfiles.git
}

apply_dotfiles(){
  cd "$LINUX_DOTFILES_DIR"
  stow .
}

exec_for_each() {
  local CONTENT="$1"
  local CMD="$2"
  echo "$CONTENT" | xargs -I{} sh -c "$CMD" -- {}
}

install_packages(){
  local COPRS=$(sed -E '/^ *#/d; s/#.*//' "$COPRS_FILE" | awk NF)
  local PKGS=$(sed -E '/^ *#/d; s/#.*//' "$PKGS_FILE" | awk NF)
  
  local ENABLECOPR_CMD='sudo dnf copr enable $1'
  local INSTALL_PKG='sudo dnf install $1'
  
  exec_for_each "$COPRS" "$ENABLECOPR_CMD"
  exec_for_each "$PKGS " "$INSTALL_PKG"
}

download_rpms(){
  BITWARDEN_RPM=$(./download-bitwarden-rpm.sh)
}

install_rpms(){
  echo "installing $BITWARDEN_RPM"
  sudo dnf install "$BITWARDEN_RPM"
}

download_rpms
install_packages
clone_dotfiles
apply_dotfiles
