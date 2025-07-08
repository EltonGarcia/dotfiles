#!/usr/bin/env bash

# enable bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# enable nvidia daemons
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

