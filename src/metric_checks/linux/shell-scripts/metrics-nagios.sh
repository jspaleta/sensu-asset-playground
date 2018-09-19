#!/bin/bash

PREFIX="unknown"

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -p|--prefix-with-argument)
      PREFIX=$2
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"



cpu () {
	cpu=$(mpstat | awk '$11 ~ /[0-9.]+/ { print 100 - $11 }')
}

disk_io () {
	disk_io=$(iostat -d -z ALL | awk 'NF==6 {s+=$2} END {print s}')
}

disk_usage () {
	disk_usage=$(df -k / | awk 'NR > 1 {print $5}' | cut -d "%" -f 1)
}

heartbeat () {
	heartbeat=1
}

memory () {
	memory=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
}

network_io () {
	network_in=$(($((`date "+%s"`)) % 20))
        network_out=$(($((`date "+%s"`+ 10 )) % 20))
}

ping_ok () {
	ping -c 1 $PING_REMOTE_HOST > /dev/null 2>&1
  	if [ $? -eq 0 ]; then
    	ping_ok=1
  	else
    	ping_ok=0
  	fi
}

cpu
disk_io
disk_usage
heartbeat
memory
network_io
ping_ok

echo METRICS ok \| ${PREFIX}.cpu=$cpu, ${PREFIX}.disk_io=$disk_io, ${PREFIX}.disk_usage=$disk_usage, ${PREFIX}.heartbeat=$heartbeat, ${PREFIX}.memory=$memory, ${PREFIX}.network_in=$network_in, ${PREFIX}.network_out=$network_out, ${PREFIX}.ping_ok=$ping_ok
