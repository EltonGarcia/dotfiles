#!/usr/bin/env bash

set -e

sudo systemctl start bluetooth

DEV_UUID=$(cat bose-qc-35-se-device-uuid)

bluetoothctl power on
bluetoothctl agent on
bluetoothctl connect "$DEV_UUID" #4C:87:5D:81:CC:B7
