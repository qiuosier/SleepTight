#!/bin/bash
# Shell Script to unlock and mount a specific disk in MacOS
#
# 2019 Qiu Qin.
# 
echo "- $(date) Waking Up..."
# Wait 5 seconds
sleep 5
# Get the disk identifier from UUID
DISK_IDENTIFER=$(diskutil list | grep -B 2 "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" | awk 'NR==1{print $NF}')
# Check if the disk is physically connected
if [ -z "$DISK_IDENTIFER" ] 
then
    echo "- Disk not found."
else
    # Check if the disk is already mounted
    if mount | grep "$DISK_IDENTIFER" > /dev/null; then
        echo "- $DISK_IDENTIFER already mounted."
    else
        # Unlock
        echo "- Unlocking..."
        diskutil coreStorage unlockVolume XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX -passphrase YOUR_PASS_PHRASE
        # Mount
        echo "- Mounting..."
        diskutil mount /dev/"$DISK_IDENTIFER"
    fi
fi
