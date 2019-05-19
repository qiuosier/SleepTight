# Eject External Disks on Sleep and Reconnect on Wake Up
macOS does not eject external disks when going into sleep. If we connect an external disk to the mac all the time (for Time Machine, or extra storage), it is likely that we get a "Disk not ejected properly" message when we wake up the mac.

There was a long discussion about this issue, see [Automatically eject external disks on sleep and reconnect after on OS X](https://www.atpeaz.com/automaticlly-eject-external-disks-on-sleep-reconnect-after-os-x/).

## The SleepWatcher Solution
A possible solution is to use SleepWatcher and execute shell scripts to eject the disk on sleep and reconnect it on wake up.
This directory contains two scripts:
* `sleep.sh` ejects a particular disk (by UUID)
* `wake.sh` unlocks an encrypted disk (by UUID) and re-mounts it.

These scripts are test on macOS Mojave 10.14.
