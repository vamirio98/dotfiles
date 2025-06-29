#!/usr/bin/env bash

# automount partition/drive
# ref: https://github.com/microsoft/WSL/issues/6073#issuecomment-2305319910

# also add these to wsl.conf:
# ```
# [boot]
# systemd=true
# command="bash /boot.sh > /boot.log"
# ```

# General values
username=vamirio
distribution="Fedora"
vhd_file_path="D:/Tools/vm/wsl/user.vhdx"

# Timeout and interval in seconds
timeout=5
interval=1

# Drive to check and mount
target_drive="/dev/sde"

# Mount point
mount_point="/home"

# Execute mount
/mnt/c/Users/$username/AppData/Local/Microsoft/WindowsApps/wsl.exe -d $distribution --mount --vhd $vhd_file_path --bare

# Initialize elapsed time counter
elapsed=0

# Wait for the target drive to be ready
while [ ! -e $target_drive ]; do
    if [ $elapsed -ge $timeout ]; then
        echo "Timed out waiting for $target_drive to be ready."
        exit 1
    fi

    echo "Waiting for $target_drive to be ready..."
    sleep $interval
    elapsed=$((elapsed + interval))
done

# Mount the target drive
mount $target_drive $mount_point

# Check the mounted target drive
mount -l | grep $target_drive
