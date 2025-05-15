#!/bin/bash
# This is just an example of what could be done here
# /usr/bin/curl -s -X POST http://homeassistant.local:8123/api/webhook/turn-off-tv
echo "This script ran just before system suspension" > /tmp/suspend.log
