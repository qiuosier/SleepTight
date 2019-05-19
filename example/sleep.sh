#!/bin/bash
# Shell Script to eject a specific disk in macOS
#
# 2019 Qiu Qin.
# 
echo "- $(date) Falling into Sleep..."
# Get the disk identifier from UUID
DISK_IDENTIFER=$(diskutil list | grep -B 2 "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" | awk 'NR==1{print $NF}')
# Check if the disk is physically connected
if [ -z "$DISK_IDENTIFER" ] 
then
    echo "- Disk not found."
else
    # Check if the disk is mounted
    if mount | grep "$DISK_IDENTIFER" > /dev/null; then
        diskutil eject "$DISK_IDENTIFER"
    else
        # No need to eject
        echo "- Disk not mounted."
    fi
fi
