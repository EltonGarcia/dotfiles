#!/usr/bin/env bash

pacman -S hplip cups system-config-printer gtk3-print-backends python-pillow python-pyqt5 sane xsane
gpasswd -a $(whoami) scanner
systemctl enable --now cups

echo "Running hp-setup, ensure printer is on and connected to the wifi" >&2
hp-setup -i 192.168.0.212
