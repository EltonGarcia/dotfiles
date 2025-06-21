#!/usr/bin/env bash

set -e

sudo systemctl start bluetooth

bluetoothctl power on
bluetoothctl agent on
bluetoothctl connect 4C:87:5D:81:CC:B7
