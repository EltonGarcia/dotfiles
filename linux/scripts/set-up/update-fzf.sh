#!/bin/bash

# Uninstall apt package
sudo apt purge fzf -y

if ! test -d ~/.packages/.fzf; then
  echo "Downloading package"
  # Create packages folder if it does not exists
  mkdir ~/.packages 2>/dev/null

  # Install from source
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.packages/.fzf 2>/dev/null
fi

# Provide controlled input for the install script
# Respond yes to the first two prompts and no to the last
# Install prompts:
# - Do you want to enable fuzzy auto-completion? ([y]/n) y
# - Do you want to enable key bindings? ([y]/n) y
# - Do you want to update your shell configuration files? ([y]/n) n
yes_no_script=$(mktemp)
cat << 'EOF' > $yes_no_script
y
y
n
EOF

# Run the install script with the controlled input
cat $yes_no_script | ~/.packages/.fzf/install

# Remove the temporary script
rm $yes_no_script

# Source shell configuration (if modified)
#source ~/.bashrc  # bash
#source ~/.zshrc   # zsh

# Verify the installation
#fzf --version
