#!/bin/bash

mkdir -p /tmp/bat
curl -L -o /tmp/bat/bat.deb https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-musl_0.24.0_amd64.deb
cd /tmp/bat
sudo dpkg -i bat.deb
