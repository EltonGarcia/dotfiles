#!/bin/bash

git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
[[ "$?" -ne 0 ]] && exit "$?"

cd $(pwd)/nerd-fonts/
[[ "$?" -ne 0 ]] && exit "$?"

git sparse-checkout add patched-fonts/IBMPlexMono
[[ "$?" -ne 0 ]] && exit "$?"

./install.sh IBMPlexMono

#JetBrainsMono
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
