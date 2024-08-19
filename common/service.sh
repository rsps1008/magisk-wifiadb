#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}


start_adb() {
	setprop service.adb.tcp.port 5555
	stop adbd
	sleep 3
}

maintain_adb_availability() {
	while true; do
		if [ "$(getprop service.adb.tcp.port)" != 5555 ]; then
			start_adb
		fi
		start adbd
		sleep 120
	done
}

# This script will be executed in late_start service mode
(
	until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
		sleep 10
	done
	maintain_adb_availability
) &
