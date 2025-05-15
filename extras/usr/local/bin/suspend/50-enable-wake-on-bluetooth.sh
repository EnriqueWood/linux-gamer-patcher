#!/bin/bash

LOG_TAG="enable-wake-bluetooth"
WAKE_PATH=""

# Find the first Bluetooth USB device wakeup path
for dev in /sys/class/bluetooth/*; do
  dev_name=$(readlink -f "$dev" | grep -Po "(?<=usb\\d/)[^/]+")
  path="/sys/bus/usb/devices/$dev_name/power/wakeup"
  if [[ -f "$path" ]]; then
    WAKE_PATH="$path"
    break
  fi
done

if [[ -z "$WAKE_PATH" ]]; then
  logger -t "$LOG_TAG" "No Bluetooth wakeup path found. Exiting."
  exit 1
fi

logger -t "$LOG_TAG" "Found a bt adapter on $WAKE_PATH"

current=$(cat "$WAKE_PATH")
if [[ "$current" != "enabled" ]]; then
  echo enabled > "$WAKE_PATH"
  logger -t "$LOG_TAG" "Restored 'enabled' to $WAKE_PATH"
fi
