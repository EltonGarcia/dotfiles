#!/bin/bash

#curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar xz

#curl -LO https://github.com/neovim/neovim-releases/releases/download/v0.10.2/nvim-linux64.tar.gz
#sudo rm -rf /opt/nvim
#sudo tar -C /opt -xzf nvim-linux64.tar.gz

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
