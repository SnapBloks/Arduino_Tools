#!/bin/bash

#set -e

if [ $# -lt 4 ]; then
  echo "Usage: $0 $# <dummy_port> <altID> <usbID> <binfile>" >&2
  exit 1
fi
altID="$2"
usbID="$3"
binfile="$4"
dummy_port_fullpath="/dev/$1"
if [ $# -eq 5 ]; then
  dfuse_addr="--dfuse-address $5"
else
  dfuse_addr=""
fi

# Get the directory where the script is running.
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

#  ----------------- IMPORTANT -----------------
# The 2nd parameter to upload-reset is the delay after resetting before it exits
# This value is in milliseonds
# You may need to tune this to your system
# 750ms to 1500ms seems to work on my Mac

"${DIR}/upload-reset" "${dummy_port_fullpath}" 750

"${DIR}/dfu-util.sh" -d "${usbID}" -a "${altID}" -D "${binfile}" ${dfuse_addr} -R

echo -n Waiting for "${dummy_port_fullpath}" serial...

COUNTER=0
while [ ! -r "${dummy_port_fullpath}" ] && ((COUNTER++ < 40)); do
  sleep 0.1
done

echo Done
