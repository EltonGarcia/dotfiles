#!/usr/bin/env bash

NVIDIA_OPTS='options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp'
echo "$NVIDIA_OPTS" | sudo tee -a /etc/modprobe.d/nvidia-power-management.conf

sudo tee /etc/udev/rules.d/70-nvidia.rules > /dev/null <<EOF
ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="/usr/bin/nvidia-modprobe -c 0 -u"
EOF

# i2c setup, required by ddcutil and brightnessctl
echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf

sudo tee /etc/udev/rules.d/45-ddcutil.rules > /dev/null <<EOF
SUBSYSTEM=="i2c-dev", GROUP="i2c", MODE="0660"
EOF

sudo groupadd -f i2c       # Creates the 'i2c' group if it doesn't exist
sudo usermod -aG i2c $USER # Adds your user to the group
