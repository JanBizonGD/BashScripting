#!/bin/bash 
# Creates report
set -e

echo Timestamp: "$(date +'%F %T')"
echo Username: "$USER"
echo Internal IP: "$(ifconfig | grep "inet " | cut -f2 -d' ')"
echo External IP: "$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo Hostname: "$(hostname)"
echo Version: "$(uname -s` `uname -r)"
echo Uptime: "$(uptime | cut -f5 -d' ')"
echo Used/Free space: "$(free -h | awk -F '[[:space:]]+' '{print $3 "/" $4 }' | head -n 2 | tail -n 1)"
# prefer -h then -g
# "$(free -g | cut -f2,3 -d' ')" # "$(df -chI 2>/dev/null | grep total)" # free
echo Total/Free RAM space: "$( sudo cat /proc/meminfo | grep -e MemTotal -e MemFree | awk -F ':' '{print $2}' | xargs)" # "$(/proc/meminfo | grep Memtotal Memfree )"
echo Number and freq of CPU: "$(lscpu | grep Hz | cut -f2 -d'@' | xargs echo "$(nproc)")" 

