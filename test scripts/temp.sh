#!/bin/bash

INTERVAL=2 # interval in seconds
LOG_FILE="/path/to/temp_log.txt"

while true; do

    DATE_TIME=$(date '+%d %m %Y %H:%M:%S')
    CPU_TEMP=$(landscape-sysinfo | grep Temperature | awk '{print $2}')
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

    LOG_ENTRY="$DATE_TIME | CPU: $CPU_TEMP C | GPU: $GPU_TEMP.0 C"

    echo $LOG_ENTRY >> $LOG_FILE

    sleep $INTERVAL

done
