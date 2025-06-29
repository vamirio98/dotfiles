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

# Timeout and interval in seconds
timeout=5
interval=1

# vhd
vhd_file_path=("D:/Tools/vm/wsl/user.vhdx")

# Drive to check and mount
target_drive=("/dev/sde")

# Mount point
mount_point=("/home")

# Execute mount
for vhd in "${vhd_file_path[@]}"; do
	/mnt/c/Users/$username/AppData/Local/Microsoft/WindowsApps/wsl.exe -d $distribution --mount --vhd $vhd --bare
done

# Initialize elapsed time counter
elapsed=0

# Wait for the target drive to be ready
while true; do
	all_drive_ready=true
	for drive in "${target_drive[@]}"; do
		if [ ! -e "${drive}" ]; then
			all_drive_ready=false
			break
		fi
	done

	if [ "${all_drive_ready}" == true ]; then
		break
	fi

    if [ $elapsed -ge $timeout ]; then
        echo "Timed out waiting for "$drive" to be ready."
        exit 1
    fi

    echo "Waiting for "$drive" to be ready..."
    sleep $interval
    elapsed=$((elapsed + interval))
done

# Mount the target drive
for (( i = 0; i < ${#target_drive[@]}; i++ )); do
	mount ${target_drive[${i}]} ${mount_point[${i}]}
done

# Check the mounted target drive
for drive in "${target_drive[@]}"; do
	mount -l | grep ${drive}
done
