#!/bin/sh

DIR=$(dirname $(readlink -f "$0"))
source ${DIR}/vars.sh

/bin/mount $(/sbin/hal_app --get_boot_pd port_id=0)6 /tmp/config

# Mount TimeCapsule
PASSWD="${TC_PASS}" /sbin/mount.cifs //${TC_IP}/Data ${STORAGE}/Data -o sec=ntlm
