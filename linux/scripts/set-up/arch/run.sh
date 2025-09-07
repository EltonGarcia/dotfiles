#!/usr/bin/env bash

# enable bluetooth
systemctl enable bluetooth
systemctl start bluetooth

# enable nvidia daemons
systemctl enable nvidia-suspend.service
systemctl enable nvidia-hibernate.service
systemctl enable nvidia-resume.service

# enable waybar through uwsm: https://wiki.hypr.land/Useful-Utilities/Status-Bars/#how-to-launch
systemctl --user enable --now waybar.service

# enable atd service used by remind script with at library
systemctl enable atd


# docker
systemctl enable docker.service
usermod -aG docker $USER
newgrp docker

# create secrets
../private/configure-secrets.sh
