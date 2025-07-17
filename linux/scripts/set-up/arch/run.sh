#!/usr/bin/env bash

# enable bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# enable nvidia daemons
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

# enable waybar through uwsm: https://wiki.hypr.land/Useful-Utilities/Status-Bars/#how-to-launch
systemctl --user enable --now waybar.service

# create secrets
../private/configure-secrets.sh
