#!/bin/bash

# Replace 'XX:XX:XX:XX:XX:XX' with your Bluetooth mouse's MAC address
MAC_ADDRESS="04:4B:ED:D0:C9:F6"

echo "Connecting to Bluetooth mouse..."

# Check if Bluetooth is enabled
if ! rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    echo "Bluetooth is enabled."

    # Connect to the Bluetooth device
    echo -e "connect $MAC_ADDRESS\nquit" | bluetoothctl > /dev/null 2>&1

    # Check if the connection was successful
    if [ $? -eq 0 ]; then
        echo "Connected to the Bluetooth mouse."
    else
        echo "Failed to connect to the Bluetooth mouse. Please check if the device is discoverable and try again."
    fi
else
    echo "Bluetooth is currently disabled. Please enable Bluetooth and try again."
fi

